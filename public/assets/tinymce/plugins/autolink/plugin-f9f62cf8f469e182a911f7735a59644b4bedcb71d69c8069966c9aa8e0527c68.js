!function(){"use strict";var e=tinymce.util.Tools.resolve("tinymce.PluginManager"),n=tinymce.util.Tools.resolve("tinymce.Env"),m=function(e){return e.getParam("autolink_pattern",/^(https?:\/\/|ssh:\/\/|ftp:\/\/|file:\/|www\.|(?:mailto:)?[A-Z0-9._%+\-]+@)(.+)$/i)},y=function(e){return e.getParam("default_link_target","")},i=function(e,t){if(t<0&&(t=0),3===e.nodeType){var n=e.data.length;n<t&&(t=n)}return t},k=function(e,t,n){1!==t.nodeType||t.hasChildNodes()?e.setStart(t,i(t,n)):e.setStartBefore(t)},p=function(e,t,n){1!==t.nodeType||t.hasChildNodes()?e.setEnd(t,i(t,n)):e.setEndAfter(t)},o=function(e,t,n){var i,o,r,a,f,s,d,l,c,u,g=m(e),h=y(e);if("A"!==e.selection.getNode().tagName){if((i=e.selection.getRng(!0).cloneRange()).startOffset<5){if(!(l=i.endContainer.previousSibling)){if(!i.endContainer.firstChild||!i.endContainer.firstChild.nextSibling)return;l=i.endContainer.firstChild.nextSibling}if(c=l.length,k(i,l,c),p(i,l,c),i.endOffset<5)return;o=i.endOffset,a=l}else{if(3!==(a=i.endContainer).nodeType&&a.firstChild){for(;3!==a.nodeType&&a.firstChild;)a=a.firstChild;3===a.nodeType&&(k(i,a,0),p(i,a,a.nodeValue.length))}o=1===i.endOffset?2:i.endOffset-1-t}for(r=o;k(i,a,2<=o?o-2:0),p(i,a,1<=o?o-1:0),o-=1," "!==(u=i.toString())&&""!==u&&160!==u.charCodeAt(0)&&0<=o-2&&u!==n;);var C;(C=i.toString())===n||" "===C||160===C.charCodeAt(0)?(k(i,a,o),p(i,a,r),o+=1):(0===i.startOffset?k(i,a,0):k(i,a,o),p(i,a,r)),"."===(s=i.toString()).charAt(s.length-1)&&p(i,a,r-1),(d=(s=i.toString().trim()).match(g))&&("www."===d[1]?d[1]="http://www.":/@$/.test(d[1])&&!/^mailto:/.test(d[1])&&(d[1]="mailto:"+d[1]),f=e.selection.getBookmark(),e.selection.setRng(i),e.execCommand("createlink",!1,d[1]+d[2]),h&&e.dom.setAttrib(e.selection.getNode(),"target",h),e.selection.moveToBookmark(f),e.nodeChanged())}},t=function(t){var e;t.on("keydown",function(e){13!==e.keyCode||o(t,-1,"")}),n.ie?t.on("focus",function(){if(!e){e=!0;try{t.execCommand("AutoUrlDetect",!1,!0)}catch(n){}}}):(t.on("keypress",function(e){41!==e.keyCode||o(t,-1,"(")}),t.on("keyup",function(e){32!==e.keyCode||o(t,0,"")}))};e.add("autolink",function(e){t(e)})}();