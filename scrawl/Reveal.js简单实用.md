## Reveal.js简单实用 

#####代码获取
官网下载代码，修改index.html 即可。


#####简单使用
本质是js，支持html语法。
使用时，在 `<div class="slides"> </div>`标签内添加内容即可。 

#####使用markdown
在使用`<section> `标签时，添加`data-markdown` 属性即可。
例如：
`<section data-markdown> </section>`

#####层次划分
一个`<section> </section>`为一横级。
同一个`<section> </section>`下的内容为一纵级。

#####背景颜色
`<section data-background="十六进制颜色码"></section>`
只支持16进制颜色码。

#####视频背景
`<section data-background-video="视频地址"></section>`