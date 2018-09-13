//
//  ViewController.m
//  LRPageScrollVIew
//
//  Created by Gavin on 2018/9/13.
//  Copyright © 2018年 LRanger. All rights reserved.
//

#import "ViewController.h"

static NSInteger const kPageCount = 20;

@interface ViewController () <UIScrollViewDelegate>

@property(nonatomic, strong) UIScrollView *mainScrollView;
@property(nonatomic, strong) UIScrollView *innerScrollView;
@property(nonatomic, assign) CGFloat pageSize;

@property(nonatomic, strong) NSMutableArray *cells;
@property(nonatomic, strong) NSMutableArray *innerCells;

@property(nonatomic, strong) UISlider *sliderView;

@property(nonatomic, strong) UILabel *pageSizeLabel;
@property(nonatomic, strong) UIButton *doneButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _mainScrollView = [UIScrollView new];
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    _mainScrollView.frame = CGRectMake(50, 50, self.view.frame.size.width - 100, 200);
    _mainScrollView.layer.shadowColor = [UIColor blackColor].CGColor;
    _mainScrollView.layer.shadowRadius = 3;
    _mainScrollView.layer.shadowOffset = CGSizeMake(0, -1);
    _mainScrollView.layer.shadowOpacity = 0.2;
    _mainScrollView.layer.masksToBounds = NO;
    _mainScrollView.delegate = self;
    _mainScrollView.scrollEnabled = NO;
    [self.view addSubview:_mainScrollView];
    
    _innerScrollView = [UIScrollView new];
    _innerScrollView.backgroundColor = [UIColor whiteColor];
    _innerScrollView.frame = CGRectMake(100, CGRectGetMaxY(_mainScrollView.frame) + 50, self.view.frame.size.width - 200, 100);
    _innerScrollView.layer.shadowColor = [UIColor blackColor].CGColor;
    _innerScrollView.layer.shadowRadius = 3;
    _innerScrollView.layer.shadowOffset = CGSizeMake(0, -1);
    _innerScrollView.layer.shadowOpacity = 0.2;
    _innerScrollView.layer.masksToBounds = NO;
    _innerScrollView.delegate = self;
    _innerScrollView.pagingEnabled = YES;
    [self.view addSubview:_innerScrollView];
    
    _sliderView = [UISlider new];
    _sliderView.maximumTrackTintColor = [UIColor lightGrayColor];
    _sliderView.minimumTrackTintColor = [UIColor colorWithRed:25.0 / 25 green:202.2 / 255 blue:173.0 / 255 alpha:1];
    _sliderView.minimumValue = 0.2;
    _sliderView.maximumValue = 2;
    _sliderView.value = 1;
    _sliderView.frame = CGRectMake(50, CGRectGetMaxY(_innerScrollView.frame) + 50, 300, 5);
    [_sliderView addTarget:self action:@selector(sliderAction) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_sliderView];
    
    _pageSizeLabel = [UILabel new];
    _pageSizeLabel.frame = CGRectMake(50, CGRectGetMaxY(_sliderView.frame) + 30, 130, 50);
    _pageSizeLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.65];
    _pageSizeLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_pageSizeLabel];

    _doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _doneButton.frame = CGRectMake(CGRectGetMaxX(_pageSizeLabel.frame) + 10, _pageSizeLabel.frame.origin.y, 60, 50);
    [_doneButton setTitle:@"确定" forState:UIControlStateNormal];
    [_doneButton addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_doneButton];

    
    [_mainScrollView addGestureRecognizer:_innerScrollView.panGestureRecognizer];
    
    _pageSize = _mainScrollView.frame.size.width * _sliderView.value;
    
    _cells = [NSMutableArray new];
    _innerCells = [NSMutableArray new];
    
    [self reloadScrollView:_mainScrollView cells:_cells pageSize:_pageSize];
    [self reloadScrollView:_innerScrollView cells:_innerCells pageSize:_innerScrollView.frame.size.width];

    [self resetPageSizeTitle];
}

#pragma mark -
#pragma mark -- -- -- -- -- - Action - -- -- -- -- --
- (void)reloadScrollView:(UIScrollView *)scrollVie cells:(NSMutableArray *)cells pageSize:(CGFloat)pageSize {
    [cells makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [cells removeAllObjects];
    for (NSInteger i = 0; i < kPageCount; i++) {
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:30];
        label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.65];
        label.text = [NSString stringWithFormat:@"%ld", i];
        label.frame = CGRectMake(i * (pageSize), 0, pageSize, scrollVie.frame.size.height);
        [scrollVie addSubview:label];
        
        UIView *line = [UIView new];
        line.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        line.frame = CGRectMake(label.frame.size.width - 1, 10, 1, label.frame.size.height - 20);
        [label addSubview:line];
        
        [cells addObject:label];
    }
    
    scrollVie.contentSize = CGSizeMake(pageSize * cells.count, scrollVie.frame.size.height);
}

- (void)resetPageSizeTitle {
    _pageSizeLabel.text = [NSString stringWithFormat:@"page size: %.2f 倍", _sliderView.value];
}

#pragma mark -
#pragma mark -- -- -- -- -- - UIScrolView Delegate - -- -- -- -- --

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _innerScrollView) {
        CGFloat page = _innerScrollView.contentOffset.x / _innerScrollView.frame.size.width;
        _mainScrollView.contentOffset = CGPointMake(page * _pageSize, 0);
    }
}


#pragma mark -
#pragma mark -- -- -- -- -- - Event - -- -- -- -- --
- (void)sliderAction {
    [self resetPageSizeTitle];
}

- (void)doneAction {
    _mainScrollView.contentOffset = CGPointZero;
    _innerScrollView.contentOffset = CGPointZero;
    
    _pageSize = _mainScrollView.frame.size.width * _sliderView.value;
    
    [self reloadScrollView:_mainScrollView cells:_cells pageSize:_pageSize];
    [self reloadScrollView:_innerScrollView cells:_innerCells pageSize:_innerScrollView.frame.size.width];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
