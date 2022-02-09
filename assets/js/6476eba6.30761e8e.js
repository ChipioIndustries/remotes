"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[827],{3905:function(e,t,n){n.d(t,{Zo:function(){return u},kt:function(){return p}});var r=n(7294);function a(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function o(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function i(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?o(Object(n),!0).forEach((function(t){a(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):o(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function l(e,t){if(null==e)return{};var n,r,a=function(e,t){if(null==e)return{};var n,r,a={},o=Object.keys(e);for(r=0;r<o.length;r++)n=o[r],t.indexOf(n)>=0||(a[n]=e[n]);return a}(e,t);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(e);for(r=0;r<o.length;r++)n=o[r],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(a[n]=e[n])}return a}var c=r.createContext({}),s=function(e){var t=r.useContext(c),n=t;return e&&(n="function"==typeof e?e(t):i(i({},t),e)),n},u=function(e){var t=s(e.components);return r.createElement(c.Provider,{value:t},e.children)},d={inlineCode:"code",wrapper:function(e){var t=e.children;return r.createElement(r.Fragment,{},t)}},m=r.forwardRef((function(e,t){var n=e.components,a=e.mdxType,o=e.originalType,c=e.parentName,u=l(e,["components","mdxType","originalType","parentName"]),m=s(n),p=a,f=m["".concat(c,".").concat(p)]||m[p]||d[p]||o;return n?r.createElement(f,i(i({ref:t},u),{},{components:n})):r.createElement(f,i({ref:t},u))}));function p(e,t){var n=arguments,a=t&&t.mdxType;if("string"==typeof e||a){var o=n.length,i=new Array(o);i[0]=m;var l={};for(var c in t)hasOwnProperty.call(t,c)&&(l[c]=t[c]);l.originalType=e,l.mdxType="string"==typeof e?e:a,i[1]=l;for(var s=2;s<o;s++)i[s]=n[s];return r.createElement.apply(null,i)}return r.createElement.apply(null,n)}m.displayName="MDXCreateElement"},2175:function(e,t,n){n.r(t),n.d(t,{frontMatter:function(){return l},contentTitle:function(){return c},metadata:function(){return s},toc:function(){return u},default:function(){return m}});var r=n(7462),a=n(3366),o=(n(7294),n(3905)),i=["components"],l={sidebar_position:2},c="Usage",s={unversionedId:"usage",id:"usage",title:"Usage",description:"Begin by requiring the module.",source:"@site/docs/usage.md",sourceDirName:".",slug:"/usage",permalink:"/remotes/docs/usage",tags:[],version:"current",sidebarPosition:2,frontMatter:{sidebar_position:2},sidebar:"tutorialSidebar",previous:{title:"Installation",permalink:"/remotes/docs/installation"},next:{title:"Remotes",permalink:"/remotes/docs/api-reference/remotes"}},u=[{value:"Getting a Remote",id:"getting-a-remote",children:[],level:2},{value:"Adding Middleware",id:"adding-middleware",children:[],level:2}],d={toc:u};function m(e){var t=e.components,n=(0,a.Z)(e,i);return(0,o.kt)("wrapper",(0,r.Z)({},d,n,{components:t,mdxType:"MDXLayout"}),(0,o.kt)("h1",{id:"usage"},"Usage"),(0,o.kt)("p",null,"Begin by requiring the module."),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-lua"},'local ReplicatedStorage = game:GetService("ReplicatedStorage")\n\nlocal Remotes = require(ReplicatedStorage.Packages.Remotes)\n')),(0,o.kt)("p",null,"The Remotes module does not have a constructor - it behaves like a service once required. This enables middleware functionality that affects every remote in the game."),(0,o.kt)("h2",{id:"getting-a-remote"},"Getting a Remote"),(0,o.kt)("p",null,"Depending on the desired remote type, call ",(0,o.kt)("inlineCode",{parentName:"p"},"getEventAsync")," or ",(0,o.kt)("inlineCode",{parentName:"p"},"getFunctionAsync"),"."),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-lua"},'local myRemoteEvent = Remotes:getEventAsync("MyRemoteEvent")\nlocal myRemoteFunction = Remotes:getFunctionAsync("MyRemoteFunction")\n')),(0,o.kt)("p",null,"If these functions are called on the server, they will create a remote instance if one does not exist. If they are called on the client, they will yield until one is created by the server. If a remote is gotten by the client but not the server, the client will yield forever."),(0,o.kt)("h2",{id:"adding-middleware"},"Adding Middleware"),(0,o.kt)("p",null,"Middleware are functions that run on the server when an invocation is received from the client, but before the invocation is forwarded to the connected function(s). This allows the middleware to mutate the client arguments or drop the call entirely. This enables features such as analytics and exploit detection."),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-lua"},'local function myMiddleware(arguments, metadata)\n    local player = arguments[1] --1st argument is always a player\n    if metadata.remoteName == "BuyItems" then\n        if arguments[2] > 10 then\n            -- player shouldn\'t be able to buy more than 10 items at once\n            return true\n        end\n    end\n    return false, arguments\nend\n\nRemotes:registerMiddleware(myMiddleware)\n')))}m.isMDXComponent=!0}}]);