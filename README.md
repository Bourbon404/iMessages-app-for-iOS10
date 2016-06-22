# iMessages-app-for-iOS10
iMessages-app-for-iOS10

**iMessage**

在iOS中新增了两种iMessage的方式，1.内置表情包,2.iMessage应用

***1.内置表情包(Sticker Packs)***

可以通过在Xcode中新建Sticker Pack Application来创建。这种方式可以简单地通过添加图片来在iMessage中添加表情包。添加的贴纸需要满足一下条件

1. 图片类型必须是 _png、apng、gif或者jpeg_
2. 文件大小必须 _小于500K_
3. 图片大小必须在 _100*100 到 206*206_ 之间

>需要注意的是：必须要永远提供 _@3x_ 大小的图片(即 _300*300 到 618*618_)。系统可以根据当前设备通过 runtime 自动调整图片来呈现 @2x 和 @1x

系统能够自适应的展示贴纸，所以为了更好的展示贴纸，最好提供的贴纸是以下三种大小的类型

1. 小型 100*100
2. 中型 136*136
3. 大型 206*206

添加方法也很简单，方式直接如下图

![表情包](http://www.bourbonz.cn/wp-content/uploads/2016/06/stickerpack.png)

***2.iMessage应用***

iMessage app使用完整的框架和Message app进行交互。使用iMessage app能够

1. 在消息应用内呈现一个自定义的用户交互界面。 使用 _MSMessagesAppViewController_
2. 创建一个自定义或者动态的表情包浏览器。使用 _MSStickerBrowserViewController_
3. 添加文本、表情、或者媒体文件到消息应用的文本输入框。使用 _MSConversation_
4. 创建带有特定的应用数据交互的消息。使用 _MSMessage_
5. 更新可以相互影响的消息(例如，创建游戏或者可以合作的应用)。使用 _MSSession_

我们可以通过iMessage完成以上五种事情，下面分别来说：

1. 新建一个空白应用后，会有一个MessagesViewController，继承自MSMessagesAppViewController，这个是我们看到啊的主页，在这里进行自定义界面的创建。
同时还有几个方法

```
//当拓展从不活动进入到活动状态时会被调用，这个会发生在呈现UI的时候。使用这个方法来配置拓展和恢复之前的状态。
-(void)willResignActiveWithConversation:(MSConversation *)conversation 
//当拓展从活动进入到不活动时会被调用。这个会发生在界面消失、改变会话或者退出Message应用时。使用这个方法来释放共有的资源、存储用户数据、注销timer和存贮足够的状态信息来当它崩溃时可以来恢复你的拓展的状态.
-(void)didBecomeActiveWithConversation:(MSConversation *)conversation

```
---
```
//这个方法当接收到一个从对方发送并且是通过此拓展发送的消息时会被调用。用这个方法来触发UI更新来相应这个消息.
-(void)didReceiveMessage:(MSMessage *)message conversation:(MSConversation *)conversation 
//点击发送按钮时会被调用
-(void)didStartSendingMessage:(MSMessage *)message conversation:(MSConversation *)conversation 
//当用户删除而不发送消息时调用.使用这个方法来清理相关删除消息状态。
-(void)didCancelSendingMessage:(MSMessage *)message conversation:(MSConversation *)conversation 
```
---
```
//在拓展从一个过渡到一个新的外观状态前会被调用.使用这个方法来为改变外观状态做准备
-(void)willTransitionToPresentationStyle:(MSMessagesAppPresentationStyle)presentationStyle 
//在拓展已经过度到新的外观状态后会被调用。使用这个方法来完成与外观风格变化有关的任何行为.
-(void)didTransitionToPresentationStyle:(MSMessagesAppPresentationStyle)presentationStyle 

```
---

2. MSStickerBrowserViewController自带拖动添加、长按预览、点击添加。使用这个类来自定义表情浏览器的话，可定制性会更高，她可以根据data source来动态改变数据，也可以自定义每个贴纸的大小。创建后需要实现它的两个代理 _numberOfStickersInStickerBrowserView: 和 stickerBrowserView:stickerAtIndex:_ 来返回相应的内容。
>需要注意的是1.内容要是本地图片 2.表情的大小是可以调整的，但是还是只支持是三种样式

3. MSConversation
如果想要发送其他内容可以使用MSConversation来进行操作.
当前MessagesViewController中包含了一个当前的conversation->activeConversation

发送消息时可以通过如下方法
```
//文件
-insertAttachment:withAlternateFilename:completionHandler:
//消息
-insertMessage:localizedChangeDescription:completionHandler:
//表情
-insertSticker:completionHandler:
//文本
-insetText:completionHandler:
```
这些方法在发送相应内容的时候进行调用，需要注意的是，这里进行的不是发送消息，而是将消息添加到文本框，用户还需要自己点击发送按钮进行发送.

除了文本和贴纸外，还要说下MSMessage对象，他可以包含特有的数据、持有一个会话、让参与者更新消息，但是这个对象的呈现需要layout属性.
其中有一个URL属性，这个属性要求是一个HTTP(S)链接或者是一个数据URL。要是一个有效的链接，如果是一个网址，那么会在浏览器中加载。
layout属性必须是MSMessTemplateLay，并且你不能在创建子类或者新建MSMessageLayout。消息模板包含消息扩展的图标，图像，视频或音频文件，以及一些文本元素（标题，副标题，标题，subcaption，尾随标题和尾随subcaption）。如下图

![消息模板](http://www.bourbonz.cn/wp-content/uploads/2016/06/MSMessageTemplateLayout.png)

需要注意的是，发送的内容必须是本地内容，而且MSMessageTempLayout的mediaFileURL属性会在设置image属性后被忽略.

_selectedMessage_
想要实现具备特殊交互的，除了发送类型是MSMessage消息外，还需要处理点击事件.
*. 如果用户点击了拓展消息中的一个，这个属性会被设置成当前消息，否则会被设置成nil。
*. 如果你的拓展因用户点击消息而启动，那么这个属性会被设置成拓展启动时的消息。可以在 _didBecomeActiveWithConversation_ 中监听
*. 如果用户在你的拓展运行时点击消息，这个属性的值会改变。 可以在 _willTransitionToPresentationStyle_ 中监听
*. 页使用KVO来监听这个属性来响应相应的变化. (其实说实话，这个我没能实现)

应用的数据可以在message的url属性来解析。

如果消息与会话关联，你可以使用用一个会话实力一个新的消息来更新消息。使用conversation的 _insertMessage:localizedChangeDescription:completionHandler:_ 方法来发送新消息。当用户发送消息时，系统将其移动到底部，并更新其内容。

你还可以保存相应内容.

最后是我的demo。可能有点乱
[点我跳转](https://github.com/zhwe130205/iMessages-app-for-iOS10)

