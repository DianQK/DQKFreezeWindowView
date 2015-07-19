//
//  DQKSectionViewCell.h
//  DQKFreezeWindowView
//
//  Created by 宋宋 on 15/7/15.
//  Copyright © 2015年 dianqk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DQKSectionViewCellStyle) {
    DQKSectionViewCellStyleDefault,
    DQKSectionViewCellStyleCustom
};

typedef NS_ENUM(NSInteger, DQKSectionViewCellSeparatorStyle) {
    DQKSectionViewCellSeparatorStyleSingleLine,
    DQKSectionViewCellSeparatorStyleNone
};

@interface DQKSectionViewCell : UIView

- (instancetype)initWithStyle:(DQKSectionViewCellStyle) style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, readonly, copy) NSString *reuseIdentifier;
@property (readonly, assign, nonatomic) DQKSectionViewCellStyle style;
@property (assign, nonatomic) DQKSectionViewCellSeparatorStyle separatorStyle;
@property (strong, nonatomic) NSString *title;

@end
