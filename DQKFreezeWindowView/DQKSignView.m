//
//  DQKFreezeView.m
//  DQKFreezeWindowView
//
//  Created by 宋宋 on 15/7/15.
//  Copyright © 2015年 dianqk. All rights reserved.
//

#import "DQKSignView.h"

@interface DQKSignView ()

@property (strong, nonatomic) UILabel *contentLabel;

@end

@implementation DQKSignView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 0, frame.size.width - 7, frame.size.height / 2)];
        [self addSubview:_contentLabel];
    }
    return self;
}

- (void)setContent:(NSString *)content {
    _content = content;
    self.contentLabel.text = content;
}

@end
