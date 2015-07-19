//
//  ViewController.m
//  DQKFreezeWindowViewExample
//
//  Created by 宋宋 on 15/7/19.
//  Copyright © 2015年 dianqk. All rights reserved.
//

#import "ViewController.h"
#import "DQKFreezeWindowView.h"


@interface ViewController () <DQKFreezeWindowViewDataSource, DQKFreezeWindowViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DQKFreezeWindowView *freezeWindowView = [[DQKFreezeWindowView alloc] initWithFrame:self.view.frame FreezePoint:CGPointMake(54, 64) cellViewSize:CGSizeMake(103, 44)];
    [self.view addSubview:freezeWindowView];
    freezeWindowView.dataSource = self;
    freezeWindowView.delegate = self;
    [freezeWindowView setSignViewWithContent:@"DQK"];
    [freezeWindowView setSignViewBackgroundColor:[UIColor colorWithRed:245./255. green:245./255. blue:245./255. alpha:1.]];
    freezeWindowView.style = DQKFreezeWindowViewStyleRowOnLine;
}

- (NSInteger)numberOfSectionsInFreezeWindowView:(DQKFreezeWindowView *)freezeWindowView {
    return 100;
}

- (NSInteger)numberOfRowsInFreezeWindowView:(DQKFreezeWindowView *)freezeWindowView {
    return 100;
}

- (DQKMainViewCell *)freezeWindowView:(DQKFreezeWindowView *)freezeWindowView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *calendarCell = @"calendarCell";
    DQKMainViewCell *mainCell = [freezeWindowView dequeueReusableMainCellWithIdentifier:calendarCell forIndexPath:indexPath];
    NSString *mainCellContent = [NSString stringWithFormat:@"%ld %ld",(long)indexPath.section,(long)indexPath.row];
    if (mainCell == nil) {
        mainCell = [[DQKMainViewCell alloc] initWithStyle:DQKMainViewCellStyleDefault reuseIdentifier:calendarCell];
        mainCell.title = mainCellContent;
    }
    return mainCell;
}

- (DQKSectionViewCell *)freezeWindowView:(DQKFreezeWindowView *)freezeWindowView cellAtSection:(NSInteger)section {
    static NSString *dayCell = @"dayCell";
    DQKSectionViewCell *sectionCell = [freezeWindowView dequeueReusableSectionCellWithIdentifier:dayCell forSection:section];
    sectionCell.backgroundColor = [UIColor colorWithRed:245./255. green:245./255. blue:245./255. alpha:1.];
    NSString *sectionCellContent = [NSString stringWithFormat:@"%ld",(long)section];
    if (sectionCell == nil) {
        sectionCell = [[DQKSectionViewCell alloc] initWithStyle:DQKSectionViewCellStyleDefault reuseIdentifier:dayCell];
        sectionCell.title = sectionCellContent;
    }
    return sectionCell;
}

- (DQKRowViewCell *)freezeWindowView:(DQKFreezeWindowView *)freezeWindowView cellAtRow:(NSInteger)row {
    static NSString *timeCell = @"timeCell";
    DQKRowViewCell *rowCell = [freezeWindowView dequeueReusableRowCellWithIdentifier:timeCell forRow:row];
    NSString *rowCellContent = [NSString stringWithFormat:@"%ld",(long)row];
    if (rowCell == nil) {
        rowCell = [[DQKRowViewCell alloc] initWithStyle:DQKRowViewCellStyleDefault reuseIdentifier:timeCell];
        rowCell.title = rowCellContent;
    }
    return rowCell;
}

- (void)freezeWindowView:(DQKFreezeWindowView *)freezeWindowView didSelectIndexPath:(NSIndexPath *)indexPath {
    NSString *message = [NSString stringWithFormat:@"Click at section: %ld row: %ld",(long)indexPath.section,(long)indexPath.row];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"You did a click!" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}
@end