---
author: lunar
date: Fri 23 Oct 2020 07:44:36 PM CST
---

### 自制Typora夜樱主题

本夜樱主题是根据Typora原生newsrint通过颜色修改而来。

效果如下：

![image-20201106141040935](https://i.loli.net/2020/11/06/jBFCIa3v5serh8T.png)

NightSakura.css文件如下：
```css
/* meyer reset -- http://meyerweb.com/eric/tools/css/reset/ , v2.0 | 20110126 | License: none (public domain) */

@include-when-export url(https://fonts.loli.net/css?family=PT+Serif:400,400italic,700,700italic&subset=latin,cyrillic-ext,cyrillic,latin-ext);

/* =========== */

/* pt-serif-regular - latin */
@font-face {
  font-family: 'PT Serif';
  font-style: normal;
  font-weight: normal;
	src: local('PT Serif'), local('PTSerif-Regular'), url('./newsprint/pt-serif-v11-latin-regular.woff2') format('woff2');
	unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
}
/* pt-serif-italic - latin */
@font-face {
  font-family: 'PT Serif';
  font-style: italic;
  font-weight: normal;
	src: local('PT Serif Italic'), local('PTSerif-Italic'), url('./newsprint/pt-serif-v11-latin-italic.woff2') format('woff2');
	unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
}
/* pt-serif-700 - latin */
@font-face {
  font-family: 'PT Serif';
  font-style: normal;
  font-weight: bold;
	src: local('PT Serif Bold'), local('PTSerif-Bold'), url('./newsprint/pt-serif-v11-latin-700.woff2') format('woff2');
	unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
}
/* pt-serif-700italic - latin */
@font-face {
  font-family: 'PT Serif';
  font-style: italic;
  font-weight: bold;
	src: local('PT Serif Bold Italic'), local('PTSerif-BoldItalic'), url('./newsprint/pt-serif-v11-latin-700italic.woff2') format('woff2');
	unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
}

:root {
	--active-file-bg-color: #dadada;
	--active-file-bg-color: rgba(32, 43, 51, 0.63);
	--active-file-text-color: white;
	--bg-color: #1d424c;
	--text-color: #FFD7D7;
	--control-text-color: #444;
	--rawblock-edit-panel-bd: #3b4252;

	--select-text-bg-color: rgba(32, 43, 51, 0.63);
  --select-text-font-color: white;
}

pre {
	--select-text-bg-color: #36284e;
	--select-text-font-color: #fff;
}

html {
	font-size: 16px;
}

html, body {
	background-color: #3b4252;
	font-family: "PT Serif", 'Times New Roman', Times, serif;
	color: #ffd7d7;
	line-height: 1.5em;
}

/*#write {
	overflow-x: auto;
    max-width: initial;
	padding-left: calc(50% - 17em);
    padding-right: calc(50% - 17em);
}

@media (max-width: 36em) {
 	#write {
 		padding-left: 1em;
    	padding-right: 1em;
 	}
}*/

#write {
	max-width: 40em;
}

@media only screen and (min-width: 1400px) {
	#write {
			max-width: 914px;
	}
}

ol li {
	list-style-type: decimal;
	list-style-position: outside;
}
ul li {
	list-style-type: disc;
	list-style-position: outside;
}

ol,
ul {
	list-style: none;
}

blockquote,
q {
	quotes: none;
}
blockquote:before,
blockquote:after,
q:before,
q:after {
	content: '';
	content: none;
}
table {
	border-collapse: collapse;
	border-spacing: 0;
}
/* styles */

/* ====== */

/* headings */

h1,
h2,
h3,
h4,
h5,
h6 {
	font-weight: bold;
}
h1 {
	font-size: 1.875em;
	/*30 / 16*/
	line-height: 1.6em;
	/* 48 / 30*/
	margin-top: 2em;
}
h2,
h3 {
	font-size: 1.3125em;
	/*21 / 16*/
	line-height: 1.15;
	/*24 / 21*/
	margin-top: 2.285714em;
	/*48 / 21*/
	margin-bottom: 1.15em;
	/*24 / 21*/
}
h3 {
	font-weight: normal;
}
h4 {
	font-size: 1.125em;
	/*18 / 16*/
	margin-top: 2.67em;
	/*48 / 18*/
}
h5,
h6 {
	font-size: 1em;
	/*16*/
}
h1 {
	border-bottom: 1px solid;
	margin-bottom: 1.875em;
	padding-bottom: 0.8125em;
}
/* links */

a {
	text-decoration: none;
	color: #065588;
}
a:hover,
a:active {
	text-decoration: underline;
}
/* block spacing */

p,
blockquote,
.md-fences {
	margin-bottom: 1.5em;
}
h1,
h2,
h3,
h4,
h5,
h6 {
	margin-bottom: 1.5em;
}
/* blockquote */

blockquote {
	font-style: italic;
	border-left: 5px solid;
	margin-left: 2em;
	padding-left: 1em;
}
/* lists */

ul,
ol {
	margin: 0 0 1.5em 1.5em;
}
/* tables */
.md-meta,.md-before, .md-after {
	color:#999;
}

table {
	margin-bottom: 1.5em;
	/*24 / 16*/
	font-size: 1em;
	/* width: 100%; */
}
thead th,
tfoot th {
	padding: .25em .25em .25em .4em;
	text-transform: uppercase;
}
th {
	text-align: left;
}
td {
	vertical-align: top;
	padding: .25em .25em .25em .4em;
}

/*代码块颜色*/
code,
.md-fences {
	background-color: #364455;
}

code {
	padding-left: 2px;
	padding-right: 2px;
}

.md-fences {
	margin-left: 2em;
	margin-bottom: 3em;
	padding-left: 1ch;
	padding-right: 1ch;
}

pre,
code,
tt {
	font-size: .875em;
	line-height: 1.714285em;
}
/* some fixes */

h1 {
	line-height: 1.3em;
	font-weight: normal;
	margin-bottom: 0.5em;
}

p + ul,
p + ol{
	margin-top: .5em;
}

h3 + ul,
h4 + ul,
h5 + ul,
h6 + ul,
h3 + ol,
h4 + ol,
h5 + ol,
h6 + ol {
	margin-top: .5em;
}

li > ul,
li > ol {
	margin-top: inherit;
	margin-bottom: 0;
}

li ol>li {
	list-style-type: lower-alpha;
}

li li ol>li{
	list-style-type: lower-roman;
}

h2,
h3 {
	margin-bottom: .75em;
}
hr {
	border-top: none;
	border-right: none;
	border-bottom: 1px solid;
	border-left: none;
}
h1 {
	border-color: #c5c5c5;
}
blockquote {
	border-color: #bababa;
	color: #656565;
}

blockquote ul,
blockquote ol {
	margin-left:0;
}

.ty-table-edit {
	background-color: transparent;
}
thead {
	background-color: #cdadfb;
}
tr:nth-child(even) {
	background: #e8e7e7;
}
hr {
	border-color: #c5c5c5;
}
.task-list{
	padding-left: 1rem;
}

.md-task-list-item {
	padding-left: 1.5rem;
	list-style-type: none;
}

.md-task-list-item > input:before {
	content: '\221A';
	display: inline-block;
	width: 1.25rem;
  	height: 1.6rem;
	vertical-align: middle;
	text-align: center;
	color: #ddd;
	background-color: #3b4252;
}

.md-task-list-item > input:checked:before,
.md-task-list-item > input[checked]:before{
	color: inherit;
}

#write pre.md-meta-block {
	min-height: 1.875rem;
	color: #555;
	border: 0px;
	background: transparent;
	margin-top: -4px;
	margin-left: 1em;
	margin-top: 1em;
}

/*图片链接的颜色*/
.md-image>.md-meta {
	color: #d94f8a;
}

.md-image>.md-meta{
	font-family: Menlo, 'Ubuntu Mono', Consolas, 'Courier New', 'Microsoft Yahei', 'Hiragino Sans GB', 'WenQuanYi Micro Hei', serif;
}


#write>h3.md-focus:before{
	left: -1.5rem;
	color:#999;
	border-color:#999;
}
#write>h4.md-focus:before{
	left: -1.5rem;
	top: .25rem;
	color:#999;
	border-color:#999;
}
#write>h5.md-focus:before{
	left: -1.5rem;
	top: .0.3125rem;
	color:#999;
	border-color:#999;
}
#write>h6.md-focus:before{
	left: -1.5rem;
	top: 0.3125rem;
	color:#999;
	border-color:#999;
}

.md-toc:focus .md-toc-content{
	margin-top: 19px;
}

/*链接的颜色*/
.md-toc-content:empty:before{
	color: #87ffaf;
}
.md-toc-item {
	color: #FE5067;
}
#write div.md-toc-tooltip {
	background-color: #f3f2ee;
}

#typora-sidebar {
	background-color: #f3f2ee;
	-webkit-box-shadow: 0 6px 12px rgba(0, 0, 0, 0.375);
  	box-shadow: 0 6px 12px rgba(0, 0, 0, 0.375);
}

.pin-outline #typora-sidebar {
	background: inherit;
	box-shadow: none;
	border-right: 1px dashed;
}

.pin-outline #typora-sidebar:hover .outline-title-wrapper {
	border-left:1px dashed;
}

.outline-item:hover {
  background-color: #;
  border-left: 28px solid #dadada;
  border-right: 18px solid #dadada;
}

.typora-node .outline-item:hover {
  	border-right: 28px solid #dadada;
}

.outline-expander:before {
  content: "\f0da";
  font-family: FontAwesome;
  font-size:14px;
  top: 1px;
}

.outline-expander:hover:before,
.outline-item-open>.outline-item>.outline-expander:before {
  content: "\f0d7";
}

/*消息提示的背景颜色*/
.modal-content {
	background-color: #3B4252;
}

.auto-suggest-container ul li {
	list-style-type: none;
}

/** UI for electron */

/*toggle bar的文字颜色和背景颜色*/
.megamenu-menu,
#top-titlebar, #top-titlebar *,
.megamenu-content {
	background: #f3f2ee;
	color: #ffd7d7;
}

.megamenu-menu-header {
	border-bottom: 1px dashed #202B33;
}

.megamenu-menu {
	box-shadow: none;
	border-right: 1px dashed;
}

header, .context-menu, .megamenu-content, footer {
	font-family: "PT Serif", 'Times New Roman', Times, serif;
    color: #1f0909;
}

#megamenu-back-btn {
	color: #1f0909;
	border-color: #1f0909;
}

.megamenu-menu-header #megamenu-menu-header-title:before {
	color: #1f0909;
}

.megamenu-menu-list li a:hover, .megamenu-menu-list li a.active {
	color: inherit;
	background-color: #e8e7df;
}

.long-btn:hover {
	background-color: #e8e7df;
}

#recent-file-panel tbody tr:nth-child(2n-1) {
    background-color: transparent !important;
}

.megamenu-menu-panel tbody tr:hover td:nth-child(2) {
    color: inherit;
}

.megamenu-menu-panel .btn {
	background-color: #D2D1D1;
}

.btn-default {
	background-color: transparent;
}

.typora-sourceview-on #toggle-sourceview-btn,
.ty-show-word-count #footer-word-count {
	background: #c7c5c5;
}

#typora-quick-open {
    background-color: inherit;
}

.md-diagram-panel {
	margin-top: 8px;
}

.file-list-item-file-name {
	font-weight: initial;
}

.file-list-item-summary {
	opacity: 1;
}

.file-list-item {
	color: #777;
}

/*文件列表文字颜色*/
.file-list-item.active {
	background-color: inherit;
	color: #ffd7d7;
}

.ty-side-sort-btn.active {
	background-color: inherit;
}

.file-list-item.active .file-list-item-file-name  {
	font-weight: bold;
}

.file-list-item{
    opacity:1 !important;
}

.file-library-node.active>.file-node-background{
	background-color: rgba(32, 43, 51, 0.63);
	background-color: var(--active-file-bg-color);
}

.file-tree-node.active>.file-node-content{
	color: white;
	color: var(--active-file-text-color);
}

.md-task-list-item>input {
	margin-left: -1.7em;
	margin-top: calc(1rem - 12px);
}

input {
	border: 1px solid #aaa;
}

.megamenu-menu-header #megamenu-menu-header-title,
.megamenu-menu-header:hover, 
.megamenu-menu-header:focus {
	color: inherit;
}

.dropdown-menu .divider {
	border-color: #565a63;
}

/* https://github.com/typora/typora-issues/issues/2046 */
.os-windows-7 strong,
.os-windows-7 strong  {
	font-weight: 760;
}

.ty-preferences .btn-default {
	background: transparent;
}

.ty-preferences .window-header {
	border-bottom: 1px dashed #202B33;
	box-shadow: none;
}

#sidebar-loading-template, #sidebar-loading-template.file-list-item {
	color: #777;
}

.searchpanel-search-option-btn.active {
	background: #777;
	color: white;
}

```

修改颜色发现原来的那个代码的颜色很丑，于是修改一下代码配色。在themes文件夹下建立base.user.css文件，输入：

```css
/*背景和一般代码颜色*/
.cm-s-inner.CodeMirror { background: #3B4252; color: #ffd7d7; }
/*选中背景*/
.cm-s-inner div.CodeMirror-selected { background: #49483E; }
.cm-s-inner .CodeMirror-line::selection, .cm-s-inner .CodeMirror-line > span::selection, .cm-s-inner .CodeMirror-line > span > span::selection { background: rgba(73, 72, 62, .99); }
.cm-s-inner .CodeMirror-line::-moz-selection, .cm-s-inner .CodeMirror-line > span::-moz-selection, .cm-s-inner .CodeMirror-line > span > span::-moz-selection { background: rgba(73, 72, 62, .99); }
.cm-s-inner .CodeMirror-gutters { background: #272822; border-right: 0px; }
.cm-s-inner .CodeMirror-guttermarker { color: white; }
.cm-s-inner .CodeMirror-guttermarker-subtle { color: #d0d0d0; }
.cm-s-inner .CodeMirror-linenumber { color: #ff79c6; }
.cm-s-inner .CodeMirror-cursor { border-left: 1px solid #f8f8f0; }

.cm-s-inner span.cm-comment { color: #6b9fb2; }
.cm-s-inner span.cm-atom { color: #ae81ff; }
.cm-s-inner span.cm-number { color: #ae81ff; }

.cm-s-inner span.cm-property, .cm-s-inner span.cm-attribute { color: #a6e22e; }
.cm-s-inner span.cm-keyword { color: #f92672; } /*品红色*/
.cm-s-inner span.cm-builtin { color: #66d9ef; } /*天蓝*/
.cm-s-inner span.cm-string { color: #e6db74; } /*黄色*/

.cm-s-inner span.cm-variable { color: #f8f8f2; }
.cm-s-inner span.cm-variable-2 { color: #9effff; } /*浅蓝*/
.cm-s-inner span.cm-variable-3 { color: #66d9ef; } /*天蓝*/
.cm-s-inner span.cm-def { color: #fe5067; }
.cm-s-inner span.cm-bracket { color: #ffd7d7; }
.cm-s-inner span.cm-tag { color: #f92672; }
.cm-s-inner span.cm-header { color: #ae81ff; }
.cm-s-inner span.cm-link { color: #ae81ff; }
.cm-s-inner span.cm-error { background: #f92672; color: #f8f8f0; }

.cm-s-inner .CodeMirror-activeline-background { background: #373831; }
.cm-s-inner .CodeMirror-matchingbracket {
  text-decoration: underline;
  color: white !important;
}

/**apply to code fences with plan text**/
.md-fences {
  background-color: #3B4252;
  color: #ffd7d7;
  border: none;
}

.md-fences .code-tooltip {
  background-color: #3B4252;
}

```

大功告成！