//
//  DQKFreezeWindowView.h
//  DQKFreezeWindowView
//
//  Created by 宋宋 on 15/7/16.
//  Copyright © 2015年 dianqk. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DQKMainViewCell.h"
#import "DQKSectionViewCell.h"
#import "DQKRowViewCell.h"
#import "DQKSignView.h"

@protocol DQKFreezeWindowViewDataSource;
@protocol DQKFreezeWindowViewDelegate;


typedef NS_ENUM(NSInteger, DQKFreezeWindowViewStyle) {
    DQKFreezeWindowViewStyleDefault,
    DQKFreezeWindowViewStyleRowOnLine
};

typedef NS_ENUM(NSInteger, DQKFreezeWindowViewBounceStyle) {
    DQKFreezeWindowViewBounceStyleNone,
    DQKFreezeWindowViewBounceStyleMain,
    DQKFreezeWindowViewBounceStyleAll
};

@interface DQKFreezeWindowView : UIView

@property (weak, nonatomic) id<DQKFreezeWindowViewDataSource> dataSource;
@property (weak, nonatomic) id<DQKFreezeWindowViewDelegate> delegate;
@property (assign, nonatomic) DQKFreezeWindowViewStyle style;
@property (assign, nonatomic) DQKFreezeWindowViewBounceStyle bounceStyle;

- (instancetype)initWithFrame:(CGRect)frame FreezePoint: (CGPoint) freezePoint cellViewSize: (CGSize) cellViewSize;

- (void)setSignViewWithContent:(NSString *)content;

- (DQKMainViewCell *)dequeueReusableMainCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;
- (DQKSectionViewCell *)dequeueReusableSectionCellWithIdentifier:(NSString *)identifier forSection:(NSInteger)section;
- (DQKRowViewCell *)dequeueReusableRowCellWithIdentifier:(NSString *)identifier forRow:(NSInteger)row;

- (void)setSignViewBackgroundColor:(UIColor *)color;
- (void)setMainViewBackgroundColor:(UIColor *)color;
- (void)setSectionViewBackgroundColor:(UIColor *)color;
- (void)setRowViewBackgroundColor:(UIColor *)color;

- (void)reloadData;

@end

@protocol DQKFreezeWindowViewDataSource <NSObject>

@required
- (DQKMainViewCell *)freezeWindowView:(DQKFreezeWindowView *)freezeWindowView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (DQKSectionViewCell *)freezeWindowView:(DQKFreezeWindowView *)freezeWindowView cellAtSection:(NSInteger)section;
- (DQKRowViewCell *)freezeWindowView:(DQKFreezeWindowView *)freezeWindowView cellAtRow:(NSInteger)row;

- (NSInteger)numberOfSectionsInFreezeWindowView:(DQKFreezeWindowView *)freezeWindowView;
- (NSInteger)numberOfRowsInFreezeWindowView:(DQKFreezeWindowView *)freezeWindowView;

@optional
- (DQKSignView *)signViewInFreezeWindowView:(DQKFreezeWindowView *)freezeWindowView;

@end

@protocol DQKFreezeWindowViewDelegate <NSObject>

@optional
- (void)freezeWindowView:(DQKFreezeWindowView *)freezeWindowView didSelectIndexPath:(NSIndexPath *)indexPath;

@end