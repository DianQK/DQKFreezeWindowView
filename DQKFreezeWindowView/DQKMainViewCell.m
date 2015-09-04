//
//  DQKMainViewCell.m
//  DQKFreezeWindowView
//
//  Created by 宋宋 on 15/7/15.
//  Copyright © 2015年 dianqk. All rights reserved.
//

#import "DQKMainViewCell.h"

@interface DQKMainViewCell ()

@property (strong, nonatomic) UIView *leftLine;
@property (strong, nonatomic) UIView *rightLine;
@property (strong, nonatomic) UIView *topLine;
@property (strong, nonatomic) UIView *bottomLine;

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation DQKMainViewCell

- (instancetype)initWithStyle:(DQKMainViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super init];
    if (self) {
        _reuseIdentifier = reuseIdentifier;
        _rowNumber = 1;
        _sectionNumber = 1;
        [self addLine];
        switch (style) {
            case DQKMainViewCellStyleDefault:
            {
                _style = style;
                _titleLabel = [[UILabel alloc] init];
                _titleLabel.textAlignment = NSTextAlignmentCenter;
                [self addSubview:_titleLabel];
            }
                break;
            case DQKMainViewCellStyleCustom:
            {
                _style = style;
            }
                break;
            default:
                break;
        }
    }
    return self;
}


- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setSeparatorStyle:(DQKMainViewCellSeparatorStyle)separatorStyle {
    _separatorStyle = separatorStyle;
    if (separatorStyle == DQKMainViewCellSeparatorStyleNone) {
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
    _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
    _topLine.backgroundColor = lineGrayColor;
    [self addSubview:_topLine];
    _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0.5)];
    _bottomLine.backgroundColor = lineGrayColor;
    [self addSubview:_bottomLine];
}

- (void)removeLine {
    [self.leftLine removeFromSuperview];
    [self.rightLine removeFromSuperview];
    [self.topLine removeFromSuperview];
    [self.bottomLine removeFromSuperview];
}

- (void)setLine {
    [self.leftLine setFrame:CGRectMake(0, 0, 0.5, self.frame.size.height)];
    [self.rightLine setFrame:CGRectMake(self.frame.size.width, 0, 0.5, self.frame.size.height)];
    [self.topLine setFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
    [self.bottomLine setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0.5)];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.style == DQKMainViewCellStyleDefault) {
        [self.titleLabel setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    if (self.separatorStyle == DQKMainViewCellSeparatorStyleSingleLine) {
        [self setLine];
    }
}

@end
