//
//  DQKSectionViewCell.m
//  DQKFreezeWindowView
//
//  Created by 宋宋 on 15/7/15.
//  Copyright © 2015年 dianqk. All rights reserved.
//

#import "DQKSectionViewCell.h"

@interface DQKSectionViewCell ()
@property (strong, nonatomic) UIView *leftLine;
@property (strong, nonatomic) UIView *rightLine;
@property (strong, nonatomic) UIView *bottomLine;
@property (strong, nonatomic) UILabel *titleLabel;
@end

@implementation DQKSectionViewCell

@synthesize title;
@synthesize separatorStyle;

- (instancetype)initWithStyle:(DQKSectionViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super init];
    if (self) {
        _reuseIdentifier = reuseIdentifier;
        [self addLine];
        switch (style) {
            case DQKSectionViewCellStyleDefault:
            {
                _style = style;
                _titleLabel = [[UILabel alloc] init];
                _titleLabel.textAlignment = NSTextAlignmentCenter;
                [self addSubview:_titleLabel];
            }
                break;
            case DQKSectionViewCellStyleCustom:
            {
                _style = style;
            }
            default:
                break;
        }
        
    }
    return self;
}

- (void)setTitle:(NSString *)title_ {
    title = title_;
    self.titleLabel.text = title;
}

- (void)setSeparatorStyle:(DQKSectionViewCellSeparatorStyle)separatorStyle_ {
    separatorStyle = separatorStyle_;
    if (separatorStyle == DQKSectionViewCellSeparatorStyleNone) {
        [self removeLine];
    }
}

- (void)addLine {
    UIColor *lineGrayColor = [UIColor colorWithRed:205./255. green:205./255. blue:205./255. alpha:1];
    _leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, self.frame.size.height)];
    _leftLine.backgroundColor = lineGrayColor;
    [self addSubview:_leftLine];
    _rightLine = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, 0.5, self.frame.size.height)];
    _rightLine.backgroundColor = lineGrayColor;
    [self addSubview:_rightLine];
    _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5)];
    _bottomLine.backgroundColor = [UIColor grayColor];
    [self addSubview:_bottomLine];
}

- (void)removeLine {
    [self.leftLine removeFromSuperview];
    [self.rightLine removeFromSuperview];
    [self.bottomLine removeFromSuperview];
}

- (void)setLine {
    [self.leftLine setFrame:CGRectMake(0, 0, 0.5, self.frame.size.height)];
    [self.rightLine setFrame:CGRectMake(self.frame.size.width, 0, 0.5, self.frame.size.height)];
    [self.bottomLine setFrame:CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5)];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.style == DQKSectionViewCellStyleDefault) {
        [self.titleLabel setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    if (self.separatorStyle == DQKSectionViewCellSeparatorStyleSingleLine) {
        [self setLine];
    }
}

@end
