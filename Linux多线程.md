---
title: Linux多线程
date: 2020-05-21
tags:
- Multi-threads
categories:
- Multi-threads
---

## **Linux多线程**

[TOC]

#### **1. 多线程的优势**

在多进程编程中，程序每处理一个任务，都需要创建一个进程进行处理，而每个进程在创建时都需要复制父进程的进程上下文，且有自己独立的地址空间，当只需要并发处理很小的任务时（如并发服务器处理客户端的请求），这种开销是很不划算的，且每个进程之间的变量并不共享，使得进程间的通信也很麻烦。

这时候多线程的优势就体现了出来，线程也有自己的上下文(thread context)，但是只是一些如线程ID、栈、栈指针、程序计数器、通用寄存器之类的东西，所以创建线程的开销较小。这些一般都是在线程运行的函数里被指定，所以在每个线程中都是独立的。而所有线程依旧在这个进程内共享一片地址空间，包括它的代码、堆、共享库和打开的文件等。

#### **2. 线程的创建**

在下面的线程相关函数中都默认导入了`<pthread.h>`头文件，且在编译时链接了`pthread`库文件。

`pthread`即遵守Posix标准的多线程，它是C语言处理线程的一个标准接口。

Linux中通过`pthread_create`函数来创建线程，其定义为

`int pthread_create(pthread_t* tidp, const pthread_attr_t* attr, (void*)(*start_run)(void*), void* arg);`

创建线程函数无非做了两件事（对程序员来说，对操作系统来说做了很多），让操作系统在当前进程创建一个线程，将线程的相关信息写入第一个参数指向的`pthread_t`类型的线程类型中，这个类型在Linux内部的定义实际是`unsigned long int`类型，代表线程ID；`attr`参数用于指定线程的一些属性；后两个参数则是做的另一件事——让创建后的线程去做什么事，`start_run`对应要做的事的函数指针，`arg`则是需要传入的参数，注意函数指针的参数和返回值都必须定义为`void*`类型。

#### **3. 线程的退出**

线程的退出中主要有两个函数配套使用，`pthread_exit`与`pthread_join`

在讲这两个函数前，先讲一下主线程的概念，一般进程创建时默认只有一条线程，这条线程一般叫做主线程，其他线程都是通过主线程创建出来的，然而不同于进程，被创建出来的线程与主线程是平级的。主线程可以等待其它线程的退出，其它线程也可以等待主线程的退出，如果主线程退出后还存在其它线程，则进程依旧不会退出。所以主线程的概念只是一个虚的概念，没有哪一条线程是真正为“主”的。

`void pthread_exit(void* retval);`

`pthread_exit`在需要退出的线程中使用，使得线程显式地退出，当然线程也可以通过函数的return关键字隐式地退出。线程退出时允许携带一个返回值，这个值将被调用`pthread_join`的线程接收到。

在讲`pthread_join`函数前，需要讲一下Linux的线程状态。Linux线程状态分为joinable状态和unjoinable状态。如果是joinable状态的线程，则线程所占用的资源即使在线程return或`pthread_exit`时都不会释放，只有在其它线程中调用`pthread_join`函数才会释放。而unjoinable状态的线程的资源在线程退出时就会自动释放，不需要`pthread_join`函数进行手动释放。所以`pthread_join`操作的线程必须是joinable的。

至于线程创建时具体是什么状态可以通过`pthread_create`的`attr`属性进行指定，默认是joinable的。

更深入的讲，`pthread_join`执行的其实是线程的合并，将调用函数的线程与指定的线程进行合并，然后调用线程会等待退出线程的退出，退出后进行资源的释放，这一点从函数名的join中或许可以看出来。

`int pthread_join(pthread_t* thread, void** retval);`

`pthread_join`在等待线程退出的线程中使用，`thread`参数代表等待的线程的ID。需要声明的是这个函数执行后是阻塞的，目的是等待`thread`的退出，如果指定的线程已经退出了的话就会立刻返回。

`int pthread_detach(pthread* thread);`

该函数不会将调用线程与退出线程合并，也不会阻塞调用线程，只是在等待退出线程退出后将资源回收，效果与将线程设置为unjoinable相同。

#### **4. 线程同步**

**4.1 互斥锁**

在同一个进程中，不同线程的运行先后顺序对程序员来说是不确定的。在操作系统内部，内核在很短的时间内不断地在不同的线程上下文间进行切换。因此，当有多个线程操作一个临界资源时，需要程序员进行线程的同步。

这时就诞生了**互斥锁(mutex)**，互斥锁允许同时有一个或多个线程拥有它（一般都是一个），当多个线程需要同时操作某临界资源时，它们需要先抢占互斥锁，抢到了互斥锁的线程就可以继续运行，没抢到的则被阻塞，直到有线程释放了互斥锁，则继续抢占。所以在线程抢占了互斥锁操作完临界资源后应该尽早释放互斥锁，避免其它线程阻塞过久。

互斥锁实现的方式有多种，程序员可以自己定义一个互斥锁，这里主讲`pthread.h`中提供的互斥锁接口。

互斥锁的主要操作函数有三个，首先定义一个互斥锁

`pthread_mutex_t mutex;`

`pthread_mutex_init(pthread_mutex_t* mutex);`

初始化一个互斥锁

`pthread_mutex_lock(pthread_mutex_t* mutex);`

抢占互斥锁，如果没有抢到则被阻塞

`pthread_mutex_unlock(pthread_mutex_t* mutex);`

释放互斥锁

**4.2 条件变量**

考虑这样一种场景，某一条线程需要临界资源满足某一种条件才对临界资源进行操作，如抢票系统要在票卖完后进行加票。则加票的线程需要一直进行互斥锁的抢占，抢占后只是检查票是否卖完了，但大部分时间是没卖完的，所以多了很多不必要的抢占。而在票真正卖完后，加票线程又可能需要抢占多轮才能抢到互斥锁，导致程序的延误。这些都是只用互斥锁的程序很难解决的，于是Linux提供了条件变量接口。

于是就产生了条件变量(condition variable)，系统会将使用条件变量的线程阻塞，直到满足条件时才唤醒，唤醒后互斥锁将被当前线程锁定。

定义条件变量：`pthread_cond_t cond;`

`int pthread_cond_init(pthread_cond_t* cond, pthread_condattr_t* cond_attr);`

初始化条件变量，`cond_attr`表示需要赋予条件变量的属性，在Linux man pages中有一段话

> The LinuxThreads implementation supports no attributes for conditions, hence the *cond_attr* parameter is actually ignored.

所以一般置为NULL就好了。

`int pthread_cond_signal(pthread_cond_t* cond);`

唤醒一个正在阻塞的使用条件变量的线程，如果有多个正在阻塞的线程，依旧只唤醒一条线程，但是无法确定是哪一条。

`int pthread_cond_broadcast(pthread_cond_t* cond);`

唤醒所有正在阻塞的线程，如果有多个正在阻塞的线程，则这些线程需要再次抢占互斥锁。

`int pthread_cond_wait(pthread_cond_t* cond, pthread_mutex_t* mutex);`

阻塞线程，等待条件变量响应后唤醒，唤醒后得到相应的互斥锁mutex（如果有多个阻塞线程需要抢占）。但是线程离开阻塞状态不一定是因为条件变量满足，也有可能遇到了中断信号或出现错误，这一点很重要。

`int pthread_cond_timewait(pthread_cond_t* cond, pthread_mutex_t* mutex, const struct timespec* abstime);`

在`pthread_cond_wait`的基础上加入了阻塞时限。

`int pthread_cond_destroy(pthread_cond_t* cond);`

释放条件变量。

#### **5. 线程池模板**

最后提供一个线程池模板程序，我已在一个web server项目中成功使用。

由于线程的创建和销毁都需要消耗时间，在需要持续处理高并发任务时，通常线程在处理一个任务并不会直接退出，而是阻塞或者接着执行下一个任务，这就是线程池。

本线程池模板使用任务队列的架构，即线程池将所有接收到的任务放到一个任务队列中，然后所有线程领取任务队列中的任务进行执行。当然任务的领取需要处理线程的同步问题。

源码：

头文件

```c
/*
 * FILE: threadpool.h
 * Copyright (C) Lunar Eclipse
 * Copyright (C) Railgun
 */

#ifndef THREADPOOL_H
#define THREADPOOL_H

#ifdef __cplusplus
extern "C" {
#endif
    
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <stdint.h>
#include "debug.h"
    
#define THREAD_NUM 8

typedef struct task_s {
    void (*func)(void*);  //task function pointer
    void *arg;            //function arguments
    struct task_s* next;  //points to the next task in the task queue
} task_t;

typedef struct {
    pthread_mutex_t lock; //mutex
    pthread_cond_t cond; //condition variable
    pthread_t* threads; //thread_t type array
    
    task_t* head;
    int thread_count; //thread number in the threadpool
    int queue_size;  //task number in the task queue
    int shutdown;   /*indicate if the threadpool is shutdown. Shutdown fall into two categories[immediate_shutdown, graceful_shutdown], immediate_shutdown means the threadpool has to shutdown no matter if there are tasks or not, graceful_shutdown will wait until all tasks are executed. */
    int started; //number of threads started
} threadpool_t;

typedef enum {
    tp_invalid = -1,
    tp_lock_fail = -2,
    tp_already_shutdown = -3,
    tp_cond_broadcast = -4,
    tp_thread_fail = -5,
} threadpool_error_t;

threadpool_t* threadpool_init(int thread_num);

int threadpool_add(threadpool_t* pool, void (*func)(void*), void* arg);

int threadpool_destory(threadpool_t* pool, int graceful);

#ifdef __cplusplus
}
#endif

#endif
```

源文件

```c
/*
 * FILE: threadpool.c
 * Copyright (C) Lunar Eclipse
 * Copyright (C) Railgun
 */

#include "threadpool.h"

typedef enum {
    immediate_shutdown = 1,
    graceful_shutdown = 2
} threadpool_st_t;

static int threadpool_free(threadpool_t* pool);
static void* threadpool_worker(void* arg);

threadpool_t* threadpool_init(int thread_num) {
    if (thread_num <= 0) {
        LOG_ERR("the arg of the threadpool_init must greater than 0");
        return NULL;
    }
    
    threadpool_t* pool;
    if ((pool = (threadpool_t*)malloc(sizeof(threadpool_t))) == NULL) {
        goto ERR;
    }
    
    pool->thread_count = 0;
    pool->queue_size = 0;
    pool->shutdown = 0;
    pool->started = 0;
    pool->threads = (pthread_t*)malloc(sizeof(pthread_t) * thread_num);
    pool->head = (task_t*)malloc(sizeof(task_t)); //dummy head
    
    if ((pool->threads == NULL) || (pool->head == NULL)) {
        goto ERR;
    }
    
    pool->head->func = NULL;
    pool->head->arg = NULL;
    pool->head->next = NULL;
    
    if (pthread_mutex_init(&(pool->lock), NULL) != 0) {
        goto ERR;
    }
    
    if (pthread_cond_init(&(pool->cond), NULL) != 0) {
        pthread_mutex_destroy(&(pool->lock));
        goto ERR;
    }
    
    int i;
    for (i = 0; i < thread_num; i++) {
        if (pthread_create(&(pool->threads[i]), NULL, threadpool_worker, (void*)pool) != 0) {
            threadpool_destroy(pool, 0);
            return NULL;
        }
        //output the thread id as an 8-bit hexadecimal number
        LOG_INFO("thread: %08x started", (uint32_t)pool->threads[i]);
        
        pool->thread_count++;
        pool->started++;
    }
    return pool;
    
ERR:
    if (pool) {
        threadpool_free(pool);
    }
    return NULL;
}

//add a task to the threadpool, not thread
int threadpool_add(threadpool_t* pool, void (*func)(void*), void* arg) {
    int res, err = 0;
    if (pool == NULL || func == NULL) {
        LOG_ERR("pool = NULL or func = NULL");
        return -1;
    }
    
    if (pthread_mutex_lock(&(pool->lock)) != 0) {
        LOG_ERR("pthread_mutex_lock");
        return -1;
    }
    
    if (pool->shutdown) {
        err = tp_already_shutdown;
        goto OUT;
    }
    
    //TODO: use a memory pool
    task_t* task = (task_t*)malloc(sizeof(task_t));
    if (task == NULL) {
        LOG_ERR("malloc task fail");
        goto OUT;
    }
    
    //TODO: use a memory pool
    task->func = func;
    task->arg = arg;
    task->next = pool->head->next;
    pool->head->next = task;
    
    pool->queue_size++;
    
    res = pthread_cond_signal(&(pool->cond));
    CHECK(res == 0, "pthread_cond_signal");
    
OUT:
    if (pthread_mutex_unlock(&pool->lock) != 0) {
        LOG_ERR("pthread_mutex_unlock");
        return -1;
    }
    
    return err;
}

//free all threads in the threadpool
int threadpool_free(threadpool_t* pool) {
    if (pool == NULL || pool->started > 0) {
        return -1;
    }
    
    if (pool->threads) {
        free(pool->threads);
    }
    
    task_t* node;
    while (pool->head->next) {
        node = pool->head->next;
        pool->head->next = pool->head->next->next;
        free(node);
    }
    
    return 0;
}

//destroy the threadpool
int threadpool_destroy(threadpool_t* pool, int graceful) {
    int err = 0;
    
    if (pool == NULL) {
        LOG_ERR("pool is NULL");
        return tp_invalid; //tp_invalid is in enum
    }
    
    if (pthread_mutex_lock(&(pool->lock)) != 0) {
        return tp_lock_fail;
    }
    
    do {
        if (pool->shutdown) {
            err = tp_already_shutdown;
            break;
        }
        
        pool->shutdown = (graceful) ? graceful_shutdown : immediate_shutdown;
        
        if (pthread_cond_broadcast(&(pool->cond)) != 0) {
            err = tp_cond_broadcast;
            break;
        }
        
        if (pthread_mutex_unlock(&(pool->lock)) != 0) {
            err = tp_lock_fail;
            break;
        }
        
        int i;
        for (i = 0; i < pool->thread_count; i++) {
            if (pthread_join(pool->threads[i], NULL) != 0) {
                err = tp_thread_fail;
            }
            LOG_INFO("thread %08x exit", (uint32_t)pool->threads[i]);
        }
    } while (0);
     
    if (!err) {
        pthread_mutex_destroy(&(pool->lock));
        pthread_cond_destroy(&(pool->cond));
        threadpool_free(pool);
    }
    
    return err;
}

static void* threadpool_worker(void* arg) {
    if (arg == NULL) {
        LOG_ERR("arg should be type threadpool_t");
        return NULL;
    }
    
    threadpool_t* pool = (threadpool_t*)arg;
    task_t* task;
    
    while (1) {
        pthread_mutex_lock(&(pool->lock));
        
        //wait on condition variable, check for fake wakeups
        while ((pool->queue_size == 0) && !(pool->shutdown)) {
            pthread_cond_wait(&(pool->cond), &(pool->lock));
        }
        
        if (pool->shutdown == immediate_shutdown) {
            break;
        }
        else if ((pool->shutdown == graceful_shutdown) && pool->queue_size == 0) {
            break;
        }
        
        task = pool->head->next;
        if (task == NULL) {
            pthread_mutex_unlock(&(pool->lock));
            continue;
        }
        
        pool->head->next = task->next;
        pool->queue_size--;
        
        pthread_mutex_unlock(&(pool->lock));
        
        (*(task->func))(task->arg);
        //TODO: memory pool
        free(task);
    }
    
    pool->started--;
    pthread_mutex_unlock(&(pool->lock));
    pthread_exit(NULL);
    
    return NULL;
}
```



---

#### **参考资料**

[1. Linux man-pages](http://man7.org/linux/man-pages/man3)

[2. Linux中pthread_join和pthread_detach详解](https://blog.csdn.net/weibo1230123/article/details/81410241)

[3. Debian Linux man-pages](https://manpages.debian.org/buster/glibc-doc/pthread_cond_signal.3.en.html)