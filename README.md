# DQKFreezeWindowView    
![](https://img.shields.io/cocoapods/v/DQKFreezeWindowView.svg?style=flat) 
![](https://img.shields.io/cocoapods/l/DQKFreezeWindowView.svg?style=flat) 
![](https://img.shields.io/cocoapods/p/DQKFreezeWindowView.svg?style=flat) 
   
A freeze window effect view for iOS.   
Just like Office Excel.   

<center>
![Demo](https://raw.githubusercontent.com/DianQK/DQKFreezeWindowView/master/Screenshots/DemoVideo.gif)
</center>   

> Note:   
> If this GIF(3.7 MB) looks not well, please [refresh](https://github.com/DianQK/DQKFreezeWindowView).     

## Usage   
###  Install   
Just add `pod 'DQKFreezeWindowView', '~> 0.9.1'` to your Podfile and `pod install`.    

### Use   
> Use `DQKFreezeWindowView` just like `UITableView`,it's similar but also powerful.   


`#import "DQKFreezeWindowView.h"` anywhere you want to use.   
Initialize the freezeWindowView:   

```Objective-C  
DQKFreezeWindowView *freezeWindowView = [[DQKFreezeWindowView alloc] initWithFrame:frame];
    [self.view addSubview:freezeWindowView];
    freezeWindowView.dataSource = self;
    freezeWindowView.delegate = self;
```    

> Note:   
> **sectionCell** at the top, **rowCell** at the left.    
> <center>![](https://raw.githubusercontent.com/DianQK/DQKFreezeWindowView/master/Screenshots/ScrollViewPosition.png)</center>   

Incomplete implementation (dataSource):   

```Objective-C
- (NSInteger)numberOfSectionsInFreezeWindowView:(DQKFreezeWindowView *)freezeWindowView {
    return 100;
}

- (NSInteger)numberOfRowsInFreezeWindowView:(DQKFreezeWindowView *)freezeWindowView {
    return 100;
}

- (DQKMainViewCell *)freezeWindowView:(DQKFreezeWindowView *)freezeWindowView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *mainCell = @"mainCell";
    DQKMainViewCell *mainCell = [freezeWindowView dequeueReusableMainCellWithIdentifier:mainCell forIndexPath:indexPath];
    if (mainCell == nil) {
        mainCell = [[DQKMainViewCell alloc] initWithStyle:DQKMainViewCellStyleDefault reuseIdentifier:calendarCell];
        mainCell.title = @"mainCell";
    }
    return mainCell;
}

- (DQKSectionViewCell *)freezeWindowView:(DQKFreezeWindowView *)freezeWindowView cellAtSection:(NSInteger)section {
    static NSString *sectionCell = @"sectionCell";
    DQKSectionViewCell *sectionCell = [freezeWindowView dequeueReusableSectionCellWithIdentifier:dayCell forSection:section];
    if (sectionCell == nil) {
        sectionCell = [[DQKSectionViewCell alloc] initWithStyle:DQKSectionViewCellStyleDefault reuseIdentifier:dayCell];
        sectionCell.title = @"sectionCell";
    }
    return sectionCell;
}

- (DQKRowViewCell *)freezeWindowView:(DQKFreezeWindowView *)freezeWindowView cellAtRow:(NSInteger)row {
    static NSString *rowCell = @"rowCell";
    DQKRowViewCell *rowCell = [freezeWindowView dequeueReusableRowCellWithIdentifier:timeCell forRow:row];
    if (rowCell == nil) {
        rowCell = [[DQKRowViewCell alloc] initWithStyle:DQKRowViewCellStyleDefault reuseIdentifier:timeCell];
        rowCell.title = @"rowCell";
    }
    return rowCell;
}
```   
Incomplete implementation (delegate):   

```Objective-C
- (void)freezeWindowView:(DQKFreezeWindowView *)freezeWindowView didSelectIndexPath:(NSIndexPath *)indexPath {
    NSString *message = [NSString stringWithFormat:@"Click at section: %ld row: %ld",(long)indexPath.section,(long)indexPath.row];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"You did a click!" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}
```   

> Note:
> For more information, you can see **DQKFreezeWindowViewExample** and **DQKFreezeWindowViewDemo**. I prefer to **DQKFreezeWindowViewDemo**, it's interesting.   





## Other    

### When You Should Use DQKFreezeWindowView   
You can use it for:   

* Calendar
* Show Data
* Syllabus   
* To Do Lists
* ...    

### Why You should Try DQKFreezeWindowView   
1. **Physical**   
Look follow this picture:   
<div>
<img src="https://raw.githubusercontent.com/DianQK/DQKFreezeWindowView/master/Screenshots/AppleScreenshot.png" width="50%" height="50%" align="left"></img>
<img src="https://raw.githubusercontent.com/DianQK/DQKFreezeWindowView/master/Screenshots/DemoScreenshot.png" width="50%" height="50%" align="right"></img>
</div>
  
The right picture is **Calendar** screenshot. When you use Calendar, you can't scroll view to horizontal direction after scrolling view to vertical direction instantly, which like a bug.    

2. **Powerful**   
Also can use for many datas to show   
![](https://raw.githubusercontent.com/DianQK/DQKFreezeWindowView/master/Screenshots/ExampleVideo.gif)   

3. **Multiplex**   
You can set `DQKFreezeWindowView.bounceStyle`.   

<div>
<img src="https://raw.githubusercontent.com/DianQK/DQKFreezeWindowView/master/Screenshots/DQKFreezeWindowViewBounceStyleMain.png" width="50%" height="50%" align="left"></img>
<img src="https://raw.githubusercontent.com/DianQK/DQKFreezeWindowView/master/Screenshots/DQKFreezeWindowViewBounceStyleAll.png" width="50%" height="50%" align="right"></img>
</div>    
    
> More style you can see the project *.h file.

### Beta Function   

* Tap Section to Top / Tap Row to Left
* Detect A Cell Position
* A Delegate -- When A Cell at A Key Position     

### Implementation    
If you are interesting my project, you can see **OtherSource** . I put a part of Implementation.    
> An Article in Chinese. 

## To Do    

* Expand cell function
* Fix some cell miss when you scroll fast
* Fix **Beta** some bug
* Add more style   

## Talk    
If you have some advice or problem, please put issues or chat with Weibo [@靛青K](http://weibo.com/u/2314535081/). I need you help ^_^.

## License   
This code is distributed under the terms and conditions of the [MIT license](https://github.com/DianQK/DQKFreezeWindowView/blob/master/LICENSE).