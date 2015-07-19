//
//  DQKFreezeWindowView.m
//  DQKFreezeWindowView
//
//  Created by 宋宋 on 15/7/16.
//  Copyright © 2015年 dianqk. All rights reserved.
//

#import "DQKFreezeWindowView.h"

@interface DQKFreezeWindowView () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *mainScrollView;
@property (strong, nonatomic) UIScrollView *sectionScrollView;
@property (strong, nonatomic) UIScrollView *rowScrollView;
@property (strong, nonatomic) DQKSignView *signView;

@property (assign, nonatomic) CGSize cellViewSize;
@property (assign, nonatomic) CGPoint freezePoint;

@property (strong, nonatomic) NSMutableDictionary *cellIdentifier;

@end

@implementation DQKFreezeWindowView

@synthesize dataSource;
@synthesize delegate;
@synthesize style;
@synthesize bounceStyle;
@synthesize tapToTop;
@synthesize tapToLeft;
@synthesize showsHorizontalScrollIndicator;
@synthesize showsVerticalScrollIndicator;

- (instancetype)initWithFrame:(CGRect)frame FreezePoint: (CGPoint) freezePoint cellViewSize: (CGSize) cellViewSize {
    self = [super initWithFrame:frame];
    if (self) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(freezePoint.x, freezePoint.y, frame.size.width - freezePoint.x, frame.size.height - freezePoint.y)];
        _sectionScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(freezePoint.x, 0, frame.size.width - freezePoint.x, freezePoint.y)];
        _rowScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, freezePoint.y, freezePoint.x, frame.size.height - freezePoint.y)];
        _signView = [[DQKSignView alloc] initWithFrame:CGRectMake(0, 0, freezePoint.x, freezePoint.y)];
        [self addSubview:_mainScrollView];
        [self addSubview:_sectionScrollView];
        [self addSubview:_rowScrollView];
        [self addSubview:_signView];
        self.mainScrollView.delegate = self;
        self.sectionScrollView.delegate = self;
        self.rowScrollView.delegate = self;
        _mainScrollView.bounces = NO;
        _sectionScrollView.bounces = NO;
        _rowScrollView.bounces = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _sectionScrollView.showsHorizontalScrollIndicator = NO;
        _sectionScrollView.showsVerticalScrollIndicator = NO;
        _rowScrollView.showsHorizontalScrollIndicator = NO;
        _rowScrollView.showsVerticalScrollIndicator = NO;
        [self setContentSize];
        _freezePoint = freezePoint;
        _cellViewSize = cellViewSize;
        _cellIdentifier = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setSignViewWithContent:(NSString *)content {
    self.signView.content = content;
}

- (DQKMainViewCell *)dequeueReusableMainCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *mainCellsWithIndexPath = [self.cellIdentifier objectForKey:identifier];
    DQKMainViewCell *mainViewCell = [mainCellsWithIndexPath objectForKey:indexPath];
    return mainViewCell;
}

- (DQKSectionViewCell *)dequeueReusableSectionCellWithIdentifier:(NSString *)identifier forSection:(NSInteger)section {
    NSMutableDictionary *sectionCellsWithSection = [self.cellIdentifier objectForKey:identifier];
    DQKSectionViewCell *sectionViewCell = [sectionCellsWithSection objectForKey:[NSString stringWithFormat:@"%ld",(long)section]];
    return sectionViewCell;
}

- (DQKRowViewCell *)dequeueReusableRowCellWithIdentifier:(NSString *)identifier forRow:(NSInteger)row {
    NSMutableDictionary *rowCellsWithRow = [self.cellIdentifier objectForKey:identifier];
    DQKRowViewCell *rowViewCell = [rowCellsWithRow objectForKey:[NSString stringWithFormat:@"%ld",(long)row]];
    return rowViewCell;
}

- (void)setSignViewBackgroundColor:(UIColor *)color {
    self.signView.backgroundColor = color;
}

- (void)setMainViewBackgroundColor:(UIColor *)color {
    self.mainScrollView.backgroundColor = color;
}

- (void)setSectionViewBackgroundColor:(UIColor *)color {
    self.sectionScrollView.backgroundColor = color;
}

- (void)setRowViewBackgroundColor:(UIColor *)color {
    self.rowScrollView.backgroundColor = color;
}

- (void)reloadData {
    [self.cellIdentifier removeAllObjects];
    [self reloadViews];
}

#pragma mark - private method
- (void)scrollViewDidScroll:(nonnull UIScrollView *)scrollView
{
    [self refreshViewWhenScroll];
    [self sectionCellInSectionScrollView];
    if ([scrollView isEqual:self.mainScrollView]) {
        // stop other scrollView scroll
        [self.sectionScrollView setContentOffset:self.sectionScrollView.contentOffset animated:NO];
        [self.rowScrollView setContentOffset:self.rowScrollView.contentOffset animated:NO];
        self.sectionScrollView.delegate = nil;
        self.rowScrollView.delegate = nil;
        if (self.bounceStyle == DQKFreezeWindowViewBounceStyleAll) {
            if (self.mainScrollView.contentOffset.y <= 0) {
                [self.sectionScrollView setFrame:CGRectMake(self.sectionScrollView.frame.origin.x, - self.mainScrollView.contentOffset.y, self.sectionScrollView.frame.size.width, self.sectionScrollView.frame.size.height)];
                [self.signView setFrame:CGRectMake(self.signView.frame.origin.x, - self.mainScrollView.contentOffset.y, self.signView.frame.size.width, self.signView.frame.size.height)];
            }
            if (self.mainScrollView.contentOffset.x <= 0) {
                [self.rowScrollView setFrame:CGRectMake(- self.mainScrollView.contentOffset.x, self.rowScrollView.frame.origin.y, self.rowScrollView.frame.size.width, self.rowScrollView.frame.size.height)];
                [self.signView setFrame:CGRectMake(- self.mainScrollView.contentOffset.x, self.signView.frame.origin.y, self.signView.frame.size.width, self.signView.frame.size.height)];
            }
        }
        // the follow code must writre at last
        [self.sectionScrollView setContentOffset:CGPointMake(self.mainScrollView.contentOffset.x, 0)];
        [self.rowScrollView setContentOffset:CGPointMake(0, self.mainScrollView.contentOffset.y)];
    } else if ([scrollView isEqual:self.sectionScrollView]) {
        [self.mainScrollView setContentOffset:self.mainScrollView.contentOffset animated:NO];
        [self.rowScrollView setContentOffset:self.rowScrollView.contentOffset animated:NO];
        self.mainScrollView.delegate = nil;
        self.rowScrollView.delegate = nil;
        if (self.bounceStyle == DQKFreezeWindowViewBounceStyleAll && self.sectionScrollView.contentOffset.x <= 0) {
            [self.rowScrollView setFrame:CGRectMake(- self.sectionScrollView.contentOffset.x, self.rowScrollView.frame.origin.y, self.rowScrollView.frame.size.width, self.rowScrollView.frame.size.height)];
            [self.signView setFrame:CGRectMake(- self.sectionScrollView.contentOffset.x, 0, self.signView.frame.size.width, self.signView.frame.size.height)];
        }
        [self.mainScrollView setContentOffset:CGPointMake(self.sectionScrollView.contentOffset.x, self.mainScrollView.contentOffset.y)];
    } else if ([scrollView isEqual:self.rowScrollView]) {
        [self.mainScrollView setContentOffset:self.mainScrollView.contentOffset animated:NO];
        [self.sectionScrollView setContentOffset:self.sectionScrollView.contentOffset animated:NO];
        self.mainScrollView.delegate = nil;
        self.sectionScrollView.delegate = nil;
        if (self.bounceStyle == DQKFreezeWindowViewBounceStyleAll && self.rowScrollView.contentOffset.y <= 0) {
            [self.sectionScrollView setFrame:CGRectMake(self.sectionScrollView.frame.origin.x, - self.rowScrollView.contentOffset.y, self.sectionScrollView.frame.size.width, self.sectionScrollView.frame.size.height)];
            [self.signView setFrame:CGRectMake(0, - self.rowScrollView.contentOffset.y, self.signView.frame.size.width, self.signView.frame.size.height)];
        }
        [self.mainScrollView setContentOffset:CGPointMake(self.mainScrollView.contentOffset.x, self.rowScrollView.contentOffset.y)];
    }
    self.mainScrollView.delegate = self;
    self.sectionScrollView.delegate = self;
    self.rowScrollView.delegate = self;
}

- (void)scrollViewDidEndDecelerating:(nonnull UIScrollView *)scrollView {
    [self reloadViews];
}

- (void)sectionCellInSectionScrollView {
    if (delegate) {
        if (self.keyIndexPath != nil) {
            DQKSectionViewCell *sectionViewCell = [delegate sectionCellPointInfreezeWindowView:self];
            if ([sectionViewCell superview]) {
                NSInteger cellAtSection = (sectionViewCell.frame.origin.x - self.mainScrollView.contentOffset.x) / self.cellViewSize.width;
                if (cellAtSection == self.keyIndexPath.section) {
                    NSInteger section = sectionViewCell.frame.origin.x / self.cellViewSize.width;
                    [delegate sectionCellReachKey:sectionViewCell withSection:section];
                }
            }
        }
    }
}

- (void)tapMainViewCell:(UITapGestureRecognizer *) tapGestureRecognizer {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tapGestureRecognizer.view.frame.origin.y / self.cellViewSize.height inSection:tapGestureRecognizer.view.frame.origin.x / self.cellViewSize.width];
    [delegate freezeWindowView:self didSelectIndexPath:indexPath];
}

- (void)tapSectionToTop:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self.rowScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self reloadViews];
}

- (void)tapRowToLeft:(UITapGestureRecognizer *)tapFestureRecognizer {
    [self.sectionScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self reloadViews];
}

- (void)setDataSource:(id<DQKFreezeWindowViewDataSource> __nullable)dataSource_ {
    if (dataSource != dataSource_) {
        dataSource = dataSource_;
        [self setContentSize];
    }
}

- (void)setDelegate:(id<DQKFreezeWindowViewDelegate> __nullable)delegate_ {
    if (delegate != delegate_) {
        delegate = delegate_;
    }
}

- (void)setStyle:(DQKFreezeWindowViewStyle)style_ {
    style = style_;
}

- (void)setBounceStyle:(DQKFreezeWindowViewBounceStyle)bounceStyle_ {
    bounceStyle = bounceStyle_;
    switch (bounceStyle) {
        case DQKFreezeWindowViewBounceStyleNone:
        {
            self.mainScrollView.bounces = NO;
            self.sectionScrollView.bounces = NO;
            self.rowScrollView.bounces = NO;
        }
            break;
        case DQKFreezeWindowViewBounceStyleMain:
        {
            self.mainScrollView.bounces = YES;
            self.sectionScrollView.bounces = YES;
            self.rowScrollView.bounces = YES;
        }
        case DQKFreezeWindowViewBounceStyleAll:
        {
            self.mainScrollView.bounces = YES;
            self.sectionScrollView.bounces = YES;
            self.rowScrollView.bounces = YES;
            [self.sectionScrollView setContentSize:CGSizeMake(self.sectionScrollView.contentSize.width, self.sectionScrollView.contentSize.height * 2)];
        }
        default:
            break;
    }
}

- (void)setTapToTop:(BOOL)tapToTop_ {
    tapToTop = tapToTop_;
    if (tapToTop) {
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSectionToTop:)];
        [self.sectionScrollView addGestureRecognizer:tapGestureRecognizer];
    }
}

- (void)setTapToLeft:(BOOL)tapToLeft_ {
    tapToLeft = tapToLeft_;
    if (tapToLeft) {
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRowToLeft:)];
        [self.rowScrollView addGestureRecognizer:tapGestureRecognizer];
    }
}

- (void)setShowsHorizontalScrollIndicator:(BOOL)showsHorizontalScrollIndicator_ {
    showsHorizontalScrollIndicator = showsHorizontalScrollIndicator_;
    if (showsHorizontalScrollIndicator) {
        self.mainScrollView.showsHorizontalScrollIndicator = YES;
    } else {
        self.mainScrollView.showsHorizontalScrollIndicator = NO;
    }
}

- (void)setShowsVerticalScrollIndicator:(BOOL)showsVerticalScrollIndicator_ {
    showsVerticalScrollIndicator = showsVerticalScrollIndicator_;
    if (showsVerticalScrollIndicator) {
        self.mainScrollView.showsVerticalScrollIndicator = YES;
    } else {
        self.mainScrollView.showsVerticalScrollIndicator = NO;
    }
}

- (void)setContentSize {
    NSInteger sectionNumber = [dataSource numberOfSectionsInFreezeWindowView:self];
    NSInteger rowNumber = [dataSource numberOfRowsInFreezeWindowView:self];
    [self.mainScrollView setContentSize:CGSizeMake(self.cellViewSize.width * sectionNumber, self.cellViewSize.height * rowNumber)];
    [self.sectionScrollView setContentSize:CGSizeMake(self.cellViewSize.width * sectionNumber, 0)];
    [self.rowScrollView setContentSize:CGSizeMake(0, self.cellViewSize.height * rowNumber)];
}


- (void)refreshViewWhenScroll {
    NSInteger section = ((NSInteger)(self.mainScrollView.contentOffset.x - 0.5) / self.cellViewSize.width - 1) < 0 ? 0 : ((NSInteger)(self.mainScrollView.contentOffset.x - 0.5) / self.cellViewSize.width - 1);
    NSInteger row = ((NSInteger)(self.mainScrollView.contentOffset.y - 0.5) / self.cellViewSize.height - 1) < 0 ? 0 : ((NSInteger)(self.mainScrollView.contentOffset.y - 0.5) / self.cellViewSize.height - 1);
    NSInteger sectionMax = (self.mainScrollView.contentOffset.x - 0.5) / self.cellViewSize.width + self.mainScrollView.frame.size.width / self.cellViewSize.width + 2;
    if (sectionMax >= [dataSource numberOfSectionsInFreezeWindowView:self]) {
        sectionMax = [dataSource numberOfSectionsInFreezeWindowView:self] - 1;
    }
    NSInteger rowMax = (self.mainScrollView.contentOffset.y - 0.5) / self.cellViewSize.height + self.mainScrollView.frame.size.height / self.cellViewSize.height + 2;
    if (rowMax >= [dataSource numberOfRowsInFreezeWindowView:self]) {
        rowMax = [dataSource numberOfRowsInFreezeWindowView:self] - 1;
    }
    for (NSInteger sectionNext = section < 0 ? 0 : section; sectionNext <= sectionMax; sectionNext++) {
        [self addMainViewCellWithIndexPath:[NSIndexPath indexPathForRow:row inSection:sectionNext]];
        [self addMainViewCellWithIndexPath:[NSIndexPath indexPathForRow:rowMax inSection:sectionNext]];
        [self removeMainViewCellWithIndexPath:[NSIndexPath indexPathForRow:row - 1 inSection:sectionNext]];
        [self removeMainViewCellWithIndexPath:[NSIndexPath indexPathForRow:rowMax + 1 inSection:sectionNext]];
    }
    for (NSInteger rowNext = row < 0 ? 0 : row; rowNext <= rowMax; rowNext++) {
        [self addMainViewCellWithIndexPath:[NSIndexPath indexPathForRow:rowNext inSection:section]];
        [self addMainViewCellWithIndexPath:[NSIndexPath indexPathForRow:rowNext inSection:sectionMax]];
        [self removeMainViewCellWithIndexPath:[NSIndexPath indexPathForRow:rowNext inSection:section - 1]];
        [self removeMainViewCellWithIndexPath:[NSIndexPath indexPathForRow:rowNext inSection:sectionMax + 1]];

    }
    [self addSectionViewCellWithSection:section];
    [self addSectionViewCellWithSection:sectionMax];
    [self addRowViewCellWithRow:row];
    [self addRowViewCellWithRow:rowMax];
    [self removeSectionViewCellWithSection:section - 1];
    [self removeSectionViewCellWithSection:sectionMax + 1];
    [self removeRowViewCellWithRow:row - 1];
    [self removeRowViewCellWithRow:rowMax + 1];
}

- (void)reloadViews {
    NSInteger sectionNumber = [dataSource numberOfSectionsInFreezeWindowView:self];
    NSInteger rowNumber = [dataSource numberOfRowsInFreezeWindowView:self];
    NSInteger sectionInScreen = self.mainScrollView.contentOffset.x / self.cellViewSize.width + self.mainScrollView.frame.size.width / self.cellViewSize.width + 3;
    NSInteger rowInScreen = self.mainScrollView.contentOffset.y / self.cellViewSize.height + self.mainScrollView.frame.size.height / self.cellViewSize.height + 3;
    for (NSInteger row = self.mainScrollView.contentOffset.y / self.cellViewSize.height < 0 ? 0 : self.mainScrollView.contentOffset.y / self.cellViewSize.height; (row < rowNumber && row < rowInScreen); row++) {
        for (NSInteger section = self.mainScrollView.contentOffset.x / self.cellViewSize.width < 0 ? 0 : self.mainScrollView.contentOffset.x / self.cellViewSize.width; (section < sectionNumber && section < sectionInScreen); section++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            [self addMainViewCellWithIndexPath:indexPath];
            [self addSectionViewCellWithSection:indexPath.section];
            [self addRowViewCellWithRow:indexPath.row];
        }
    }
}


#pragma mark - remove a cell
- (void)removeMainViewCellWithIndexPath:(NSIndexPath *)indexPath {
    DQKMainViewCell *mainViewCell = [dataSource freezeWindowView:self cellForRowAtIndexPath:indexPath];
    CGRect intersectionRect = CGRectIntersection(mainViewCell.frame, CGRectMake(self.mainScrollView.contentOffset.x, self.mainScrollView.contentOffset.y, self.mainScrollView.frame.size.width, self.mainScrollView.frame.size.height));
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        [mainViewCell removeFromSuperview];
    }
}

- (void)removeSectionViewCellWithSection:(NSInteger)section {
    DQKSectionViewCell *sectionViewCell = [dataSource freezeWindowView:self cellAtSection:section];
    CGRect intersectionRect = CGRectIntersection(sectionViewCell.frame, CGRectMake(self.sectionScrollView.contentOffset.x, self.sectionScrollView.contentOffset.y, self.sectionScrollView.frame.size.width, self.sectionScrollView.frame.size.height));
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        [sectionViewCell removeFromSuperview];
    }
}

- (void)removeRowViewCellWithRow:(NSInteger)row {
    DQKRowViewCell *rowViewCell = [dataSource freezeWindowView:self cellAtRow:row];
    CGRect intersectionRect = CGRectIntersection(rowViewCell.frame, CGRectMake(self.rowScrollView.contentOffset.x, self.rowScrollView.contentOffset.y, self.rowScrollView.frame.size.width, self.rowScrollView.frame.size.height));
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        [rowViewCell removeFromSuperview];
    }
}

#pragma mark - add a cell
- (void)addMainViewCellWithIndexPath:(NSIndexPath *)indexPath {
    DQKMainViewCell *mainViewCell = [dataSource freezeWindowView:self cellForRowAtIndexPath:indexPath];
    if (mainViewCell != nil && [mainViewCell superview] == nil) {
        NSString *mainReuseIdentifier = mainViewCell.reuseIdentifier;
        [self.mainScrollView addSubview:mainViewCell];
        if ([self dequeueReusableMainCellWithIdentifier:mainReuseIdentifier forIndexPath:indexPath] == nil) {
            if (delegate) {
                UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMainViewCell:)];
                [mainViewCell addGestureRecognizer:gestureRecognizer];
            }
            [mainViewCell setFrame:CGRectMake(indexPath.section * self.cellViewSize.width, indexPath.row * self.cellViewSize.height, self.cellViewSize.width, self.cellViewSize.height)];
            NSMutableDictionary *mainCellsWithIndexPath = [self.cellIdentifier objectForKey:mainReuseIdentifier];
            if (mainCellsWithIndexPath == nil) {
                mainCellsWithIndexPath = [[NSMutableDictionary alloc] init];
                [mainCellsWithIndexPath setObject:mainViewCell forKey:indexPath];
                [self.cellIdentifier setObject:mainCellsWithIndexPath forKey:mainReuseIdentifier];
            } else {
                [mainCellsWithIndexPath setObject:mainViewCell forKey:indexPath];
            }
        }
    }
}

- (void)addSectionViewCellWithSection:(NSInteger)section {
    DQKSectionViewCell *sectionViewCell = [dataSource freezeWindowView:self cellAtSection:section];
    if (sectionViewCell != nil && [sectionViewCell superview] == nil) {
        NSString *sectionReuseIdentifier = sectionViewCell.reuseIdentifier;
        [self.sectionScrollView addSubview:sectionViewCell];
        if ([self dequeueReusableSectionCellWithIdentifier:sectionReuseIdentifier forSection:section] == nil) {
            [sectionViewCell setFrame:CGRectMake(section * self.cellViewSize.width, 0, self.cellViewSize.width, self.freezePoint.y)];
            NSMutableDictionary *sectionCellsWithSection = [self.cellIdentifier objectForKey:sectionReuseIdentifier];
            if (sectionCellsWithSection == nil) {
                sectionCellsWithSection = [[NSMutableDictionary alloc] init];
                [sectionCellsWithSection setObject:sectionViewCell forKey:[NSString stringWithFormat:@"%ld",(long)section]];
                [self.cellIdentifier setObject:sectionCellsWithSection forKey:sectionReuseIdentifier];
            } else {
                [sectionCellsWithSection setObject:sectionViewCell forKey:[NSString stringWithFormat:@"%ld",(long)section]];
            }
        }
    }
}

- (void)addRowViewCellWithRow:(NSInteger)row {
    DQKRowViewCell *rowViewCell = [dataSource freezeWindowView:self cellAtRow:row];
    if (rowViewCell != nil && [rowViewCell superview] == nil) {
        NSString *rowReuseIdentifier = rowViewCell.reuseIdentifier;
        [self.rowScrollView addSubview:rowViewCell];
        if ([self dequeueReusableRowCellWithIdentifier:rowReuseIdentifier forRow:row] == nil) {
            switch (style) {
                case DQKFreezeWindowViewStyleDefault:
                    [rowViewCell setFrame:CGRectMake(0, self.cellViewSize.height * row, self.freezePoint.x, self.cellViewSize.height)];
                    break;
                case DQKFreezeWindowViewStyleRowOnLine:
                    [rowViewCell setFrame:CGRectMake(0, self.cellViewSize.height * row + self.cellViewSize.height / 2, self.freezePoint.x, self.cellViewSize.height)];
                    rowViewCell.separatorStyle = DQKRowViewCellSeparatorStyleNone;
                default:
                    break;
            }
            NSMutableDictionary *rowCellsWithRow = [self.cellIdentifier objectForKey:rowReuseIdentifier];
            if (rowCellsWithRow == nil) {
                rowCellsWithRow = [[NSMutableDictionary alloc] init];
                [rowCellsWithRow setObject:rowViewCell forKey:[NSString stringWithFormat:@"%ld",(long)row]];
                [self.cellIdentifier setObject:rowCellsWithRow forKey:rowReuseIdentifier];
            } else {
                [rowCellsWithRow setObject:rowViewCell forKey:[NSString stringWithFormat:@"%ld",(long)row]];
            }
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self reloadViews];
}

@end