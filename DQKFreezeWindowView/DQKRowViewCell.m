//
//  DQKRowViewCell.m
//  DQKFreezeWindowView
//
//  Created by 宋宋 on 15/7/15.
//  Copyright © 2015年 dianqk. All rights reserved.
//

#import "DQKRowViewCell.h"


@interface DQKRowViewCell ()
@property (strong, nonatomic) UIView *topLine;
@property (strong, nonatomic) UIView *bottomLine;
@property (strong, nonatomic) UILabel *titleLabel;
@end

@implementation DQKRowViewCell

@synthesize title;
@synthesize separatorStyle;

- (instancetype)initWithStyle:(DQKRowViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super init];
    if (self) {
        _reuseIdentifier = reuseIdentifier;
        [self addLine];
        switch (style) {
            case DQKRowViewCellStyleDefault:
            {
                _style = style;
                _titleLabel = [[UILabel alloc] init];
                _titleLabel.textAlignment = NSTextAlignmentCenter;
                [self addSubview:_titleLabel];
            }
                break;
            case DQKRowViewCellStyleCustom:
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

- (void)setTitle:(NSString *)title_ {
    title = title_;
    self.titleLabel.text = title;
}

- (void)setSeparatorStyle:(DQKRowViewCellSeparatorStyle)separatorStyle_ {
    separatorStyle = separatorStyle_;
    if (separatorStyle == DQKRowViewCellSeparatorStyleNone) {
        [self removeLine];
    }
}

- (void)addLine {
    UIColor *lineGrayColor = [UIColor colorWithRed:205./255. green:205./255. blue:205./255. alpha:1];
    _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
    _topLine.backgroundColor = lineGrayColor;
    [self addSubview:_topLine];
    _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0.5)];
    _bottomLine.backgroundColor = lineGrayColor;
    [self addSubview:_bottomLine];
}

- (void)removeLine {
    [self.topLine removeFromSuperview];
    [self.bottomLine removeFromSuperview];
}

- (void)setLine {
    [self.topLine setFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
    [self.bottomLine setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0.5)];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.style == DQKRowViewCellStyleDefault) {
        [self.titleLabel setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    if (self.separatorStyle == DQKRowViewCellSeparatorStyleSingleLine) {
        [self setLine];
    }
}

@end
