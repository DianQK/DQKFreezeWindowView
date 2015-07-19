# DQKFreezeWindowView
A freeze window effect view for iOS.   
Just like office excel.   
Use `DQKFreezeWindowView` just like `UITableView`,it's similar.
You can use it for:   

* Calendar
* Show Data
* Syllabus   
* To Do Lists
* ...

## Why You Should Use DQKFreezeWindowView   
Look follow this picture:
![](https://raw.githubusercontent.com/DianQK/DQKFreezeWindowView/master/Screenshots/DemoScreenshot.png)![](https://raw.githubusercontent.com/DianQK/DQKFreezeWindowView/master/Screenshots/AppleScreenshot.png)   
The right picture is Apple Calendar App. Also when you use Calendar, you can't scroll view to horizontal direction after scrolling view to vertical direction instantly, which like a bug.    
Support **Delegate** and **DataSource** !!!   
Here is a gif to show    
*If you find it delay, don't worry, just because it's a bit large (3.7 MB)*    
![](https://raw.githubusercontent.com/DianQK/DQKFreezeWindowView/master/Screenshots/DemoVideo.gif)   
Also can use for many datas to show   
![](https://raw.githubusercontent.com/DianQK/DQKFreezeWindowView/master/Screenshots/ExampleVideo.gif)   

## Usage   
###  Install   
Just add `pod DQKFreezeWindowView` to your Podfile.    
### Use   

```Objective-C  
#import "DQKFreezeWindowView.h" 


DQKFreezeWindowView *freezeWindowView = [[DQKFreezeWindowView alloc] initWithFrame:frame];
    [self.view addSubview:freezeWindowView];
    freezeWindowView.dataSource = self;
    freezeWindowView.delegate = self;
```
dataSource implementation:   

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
    }
    return mainCell;
}

- (DQKSectionViewCell *)freezeWindowView:(DQKFreezeWindowView *)freezeWindowView cellAtSection:(NSInteger)section {
    static NSString *sectionCell = @"sectionCell";
    DQKSectionViewCell *sectionCell = [freezeWindowView dequeueReusableSectionCellWithIdentifier:dayCell forSection:section];
    if (sectionCell == nil) {
        sectionCell = [[DQKSectionViewCell alloc] initWithStyle:DQKSectionViewCellStyleDefault reuseIdentifier:dayCell];
        sectionCell.title = sectionCellContent;
    }
    return sectionCell;
}

- (DQKRowViewCell *)freezeWindowView:(DQKFreezeWindowView *)freezeWindowView cellAtRow:(NSInteger)row {
    static NSString *rowCell = @"rowCell";
    DQKRowViewCell *rowCell = [freezeWindowView dequeueReusableRowCellWithIdentifier:timeCell forRow:row];
    if (rowCell == nil) {
        rowCell = [[DQKRowViewCell alloc] initWithStyle:DQKRowViewCellStyleDefault reuseIdentifier:timeCell];
        rowCell.title = rowCellContent;
    }
    return rowCell;
}
```   
delegate implementation:   

```Objective-C
- (void)freezeWindowView:(DQKFreezeWindowView *)freezeWindowView didSelectIndexPath:(NSIndexPath *)indexPath {
    NSString *message = [NSString stringWithFormat:@"Click at section: %ld row: %ld",(long)indexPath.section,(long)indexPath.row];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"You did a click!" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}
```   
> Note:   
**sectionCell** at the top, **rowCell** at the left.   
For more information, you can see the example and the demo.   

## Other  
You can set `DQKFreezeWindowView.bounceStyle`.   
![](https://raw.githubusercontent.com/DianQK/DQKFreezeWindowView/master/Screenshots/DQKFreezeWindowViewBounceStyleMain.png)![](https://raw.githubusercontent.com/DianQK/DQKFreezeWindowView/master/Screenshots/DQKFreezeWindowViewBounceStyleMainAll.png)    
### Beta   
* Tap Section to Top / Tap Row to Left
* Detect A Cell Position
* A Delegate -- When A Cell at A Key Position

## To Do    
* Fix some cell miss when you scroll fast
* Fix **Beta** some bug
* Add more style   

## Talk    
If you have some advice or problem, please put issues or chat with Weibo [@靛青K](http://weibo.com/u/2314535081/). I need you help ^_^.

## License   
This code is distributed under the terms and conditions of the [MIT license](https://github.com/DianQK/DQKFreezeWindowView/blob/master/LICENSE).