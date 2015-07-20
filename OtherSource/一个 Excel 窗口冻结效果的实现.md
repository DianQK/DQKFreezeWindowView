# 一个 Excel 窗口冻结效果的实现    
本文地址：[http://www.dianqk.com/dqkfreezewindowview.html](http://www.dianqk.com/dqkfreezewindowview.html)    
作者：[靛青K](http://weibo.com/u/2314535081)   

最近做了一个轮子 **[DQKFreezeWindowView](https://github.com/DianQK/DQKFreezeWindowView)** ，这里我们一起探讨一下这个轮子中冻结效果的简单实现思路，也就是我的思考过程。   
不废话，直接开始～   

## 初步分析   
既然是一个冻结的效果，那至少要用一个`UIScrollView`来做主要显示的部分。还是先来看几张已经实现了的：
<center>
![Calendar](http://ww2.sinaimg.cn/mw690/89f500a9jw1eu8byi3njaj20vk0hsmy0.jpg)    
<div>
<img src="http://ww3.sinaimg.cn/mw690/89f500a9jw1eu8byigm9hj20hs0vktj6.jpg" width="50%" height="50%" align="left"></img>
<img src="http://ww2.sinaimg.cn/mw690/89f500a9jw1eu8byiuxi1j20hs0vkq4y.jpg" width="50%" height="50%" align="right"></img>
</div>    
</center>    

在三者的使用当中，个人认为体验最好就是 MS 的 Excel 了，流畅、各方向都可以滑动。这里先用 Reveal 查看一下三者的布局，使用的 View 都是什么。   

<center>
![ClassBox](http://ww1.sinaimg.cn/mw690/89f500a9jw1eu99jvp93kj20be0elwg8.jpg)
</center>    

可以看到某课程表 App 是选择了一个 UIScrollView 加两个 Bar (`UIView`)实现该功能。简单实用，显示少量视图尚可。       

<center>
![Excel](http://ww4.sinaimg.cn/mw690/89f500a9jw1eu99jvzboej20ak0dl757.jpg)
</center>
为了显示更多数据/视图， Excel 就采用了三个`UIScrollView`。
这里有一些奇怪的现象引起了我的注意，为什么三者左边都不支持滑动？明明边栏视图都是在`UIScrollView`里，怎么想都是一个不合理的情况。所以我们的目标是这样的几个功能实现：   

* 主要视图支持多方位滚动   
* 边栏视图一样支持滚动
* bounces效果实现
* 像 Excel 一样支持更多数据显示    

既然需要实现边缘的滑动，就要三个`UIScrollView`。为什么一个不行，因为当你滑动的时候，顶栏和侧栏最好是留在边缘的。    
  
> 注意：   
> 这里我考虑过使用`UITableView`或者`UICollectionView`实现，因为它已经很好的解决了`delegate`和`dataSource`等众多问题。 [XCMultiSortTableView](https://github.com/kingiol/XCMultiSortTableView) 这个开源项目的方案是`UITableView`里面的`UITableViewCell`套一个`UITableView`，很好的实现边缘滚动问题。赞！但是并不能满足咱的要求，像 Excel 那样任意方向滚动。 博主没有想到用`UITableView`或者`UICollectionView`实现的方案所依如果你在这方面有什么好方案，快来和我交流。    
> 关于以上几款 App 的研究有兴趣可以学习逆向相关问题 class-dump 和 IDA ，这里不再赘述。    

## 开始实现    
我们需要三个`UIScrollView`，首要问题就是实现同步滚动，也是整个问题的关键部分：   
为了方便定位视图位置，先来自定义一个`UIView`，声明三个`UIScrollView`类，**mainScrollView** 、 **sectionScrollView** 、 **rowScrollView**。将该`UIVIew`添加到一个`UIViewController`中，三者在`UIView`位置如下图：    

<center>
![](http://ww1.sinaimg.cn/mw690/89f500a9jw1eu8cuuuj9nj20vk0hsadd.jpg) 
</center>

> 为什么这样起名字，因为像日历、课程表之类都是竖着一排在一天，（好吧、其实是想不到合适的了，如果你想到更好的，快来告诉我）。  

开始实现同步滚动问题：  
* 普通情况的滚动   
这个简单，使用`- (void)scrollViewDidScroll:(nonnull UIScrollView *)scrollView`加上`- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;`即可。比如 **mainScrollView** x 方向滚动多少， **sectionScrollView** x 方向滚动多少。   
* 滚动到边缘情况   
这个稍微复杂一些，这里先谈一个触摸边缘滚动的情况，并且没有`bounces`，这种情况不涉及滑动越过边界问题。滚动 **SectionScrollView** 时， **RowScrollView** 不动，反之亦然。当前代码如下：   

```Objective-C
- (void)scrollViewDidScroll:(nonnull UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.mainScrollView]) { //滚动 mainScrollView
        self.sectionScrollView.delegate = nil;
        self.rowScrollView.delegate = nil;
        [self.sectionScrollView setContentOffset:CGPointMake(self.mainScrollView.contentOffset.x, 0)];
        [self.rowScrollView setContentOffset:CGPointMake(0, self.mainScrollView.contentOffset.y)];
         self.sectionScrollView.delegate = self;
         self.rowScrollView.delegate = self;
    } else if ([scrollView isEqual:self.sectionScrollView]) {  // 滚动 sectionScrollView
        self.mainScrollView.delegate = nil;
        self.rowScrollView.delegate = nil;
        [self.mainScrollView setContentOffset:CGPointMake(self.sectionScrollView.contentOffset.x, self.mainScrollView.contentOffset.y)];
         self.mainScrollView.delegate = self;
         self.rowScrollView.delegate = self;
    } else if ([scrollView isEqual:self.rowScrollView]) {  // 滚动 rowScrollView
        self.mainScrollView.delegate = nil;
        self.sectionScrollView.delegate = nil;
        [self.mainScrollView setContentOffset:CGPointMake(self.mainScrollView.contentOffset.x, self.rowScrollView.contentOffset.y)];
         self.mainScrollView.delegate = self;
         self.sectionScrollView.delegate = self;
    }
}
```   
诶？为什么我们要设置其他 **scrollView** 的`delegate = nil`。如果不设置，当视图滚动时，再次滑动会出现视图卡顿、移动混乱情况。   
> 为什么？   
> 因为要实现三个 **scrollView** 都支持滚动，那就都要设置其`delegate`属性，那么滚动时，三个视图都会委托这个函数来执行，如果不分开他们的滚动情况讨论，并在情况里面设置其他 **scrollView** `delegate` 为 `nil`。   

其实到这里需要的功能已经实现了。但是我在使用的时候发现一个 Bug ，比如，我们现在滑动的是 **mainScrollView** ，视图停止滚动之前，去滑动 **sectionScrollView** 。诶！！！视图一下子就错位了，而且再滑动 **mainScrollView** 也不会同步了。这里我的理解是，`- (void)scrollViewDidScroll:(nonnull UIScrollView *)scrollView`，这个委托方法是在视图只要有滚动就会一直执行，那么其对应的`delegate`也是不停的在`nil`和`self`之间不停的切换，滚动 **mainScrollView** 时，又去滚动另一个 **scrollView** ，将会执行`self.mainScrollView.delegate = nil;`， 同时执行另一个`- (void)scrollViewDidScroll:(nonnull UIScrollView *)scrollView`，出现错位，如果不去滑动其他 **scrollView** ，`self.mainScrollView.delegate`就永远是`nil`了，没有了委托对象，自然不会继续同步。    
两步解决问题，以滚动 **mainScrollView** 举例，第一步，在情况开始添加：   

```Objective-C
[self.sectionScrollView setContentOffset:self.sectionScrollView.contentOffset animated:NO];
[self.rowScrollView setContentOffset:self.rowScrollView.contentOffset animated:NO];
```    

为什么这样做？理由很简单，立刻停止其他两个 **scrollView** 的滚动，其他情况的计算也就立即停止了。只计算一个滚动 **mainScrollView** 情况。   
第二步，在委托方法最后重新设置回三者的`delegate`对象。这样一定不会在某次执行完出现`nil`情况了。    
    
编译运行，Gut～随意滑动，三个位置任意滑动，随时切换滑动对象。   
那么`bounces`效果怎么办？没有这个效果，滚动到边缘就会出现立即停止的不自然感觉。这里想过几种方案，*不好的就不在这里谈了，浪费篇章*，只提现在想到的最佳方案。先来考虑 Excel 的效果实现，你这么聪明，其实早就发现根本不需要改代码，对，没错。那么现在只需要考虑`DQKFreezeWindowViewBounceStyleAll`情况，滚动到边缘时，看起来只是一个`UIScrollView`。这里需要考虑的就是 **sectionScrollView** 向下和 **rowScrollView** 向右移动的问题。当然这里也有多种方案：   

* 方案一：增加 View 的`frame.size`大小，这样视图就不会丢失了；
* 方案二：改变 View 的位置。   

采取方案二，方案一有视图重叠问题，不好不好。在原基础上增加代码，因为对于 **sectionScrollView** 视图水平滚动(`contentOffset`)已经完成，那么视图位置只需要垂直移动即可。还是滚动 **mainScrollView** 情况，直接贴代码：   

```Objective-C
if (self.bounceStyle == DQKFreezeWindowViewBounceStyleAll) {
    if (self.mainScrollView.contentOffset.y <= 0) {
        [self.sectionScrollView setFrame:CGRectMake(self.sectionScrollView.frame.origin.x, - self.mainScrollView.contentOffset.y, self.sectionScrollView.frame.size.width, self.sectionScrollView.frame.size.height)];
    }
    if (self.mainScrollView.contentOffset.x <= 0) {
        [self.rowScrollView setFrame:CGRectMake(- self.mainScrollView.contentOffset.x, self.rowScrollView.frame.origin.y, self.rowScrollView.frame.size.width, self.rowScrollView.frame.size.height)];
    }
}
```    
最初的方案是考虑四个情况的(>>,><,<>,<<)，同时还进行各种计算，现在发现，没有必要，**sectionScrollView** 的 **y** 坐标是 0 。那么滚动多少，移动多少就可以了。（取相反数，为什么？）    
你应该注意到我在相关实现文件里还加了一个 **signView** ，也就是左上角的小视图。至于这个如何跟随着移动，请参考源文件或者留着你来思考，类似 **sectionScrollView** 和 **rowScrollView** 。   
 
**视图滚动问题解决！**   

效果已经实现，接下来的问题就是：   

* **数据/视图加载问题**(也就是 Cell 的**重用机制**问题)   
为了支持更好的使用内存，支持更多的数据滚动显示，那么如何计算那些视图在什么时候移除，又在什么时候加载，什么时候释放成了一个关键的难题。   
* 类似 `UITableView` 的 `delegate` 和 `dateSource` 的实现。    
这里看过一些 GitHub 项目，发现其最终还是基于 `UITableView` 来实现的，失望ing    
这两个问题，笔者实现的并不好，甚至很烂，同时限于篇幅，不再赘述这些问题。如果你在这里有什么好的经验或者见解，希望来与我分享，非常感激。当然，如果你对我对这两个问题的解决方案感兴趣，可以查看源码，随时私信我。欢迎。我的微博: [@靛青K](http://weibo.com/u/2314535081/)    

### 最后写两个不相关的两件事以及一个相关的    
* 最近很想有个实习的机会来锻炼，如果你愿意帮我，非常感激，坐标北京；
* 如果你觉得我们水平差不多，希望可以一起学习（自己孤零零的泡图书馆很辛苦），坐标北京；    
* 接下来笔者可能尝试编写一个 tweak 使 Excel 支持边缘滚动，如果在这方面你有什么经验，欢迎来与我探讨。 