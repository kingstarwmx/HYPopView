//
//  HYCustomPopView.m
//  HudDemo
//
//  Created by MrZhangKe on 16/3/8.
//  Copyright © 2016年 Matej Bukovinski. All rights reserved.
//

#import "HYCustomPopView.h"


@interface HYCustomPopView ()

@property (nonatomic, strong) UIView *containerView;//容器视图

@property (nonatomic, strong) UIView *backgroundView;//让背景变暗的视图,起到屏蔽作用跟突出前景作用

@property (nonatomic, strong) NSMutableArray *buttonsArray;

@property (nonatomic, strong) NSMutableArray *lineViewArray;

@end

@implementation HYCustomPopView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self setupFrames];
    }
    return self;
}

- (instancetype)initWithView:(UIView *)view{
    _customView = view;
    return [self initWithFrame:[UIScreen mainScreen].bounds];
}


- (instancetype)initWithView:(UIView *)view buttonNamesArray:(NSArray<__kindof NSString *> *)buttonNamesArray{
    
    _customView = view;
    _buttonNamesArray = buttonNamesArray;
    return [self initWithFrame:[UIScreen mainScreen].bounds];
}

- (void)show{
    
}

- (void)setupViews{
    
    //设置默认属性
    _buttonBackgroundColor = [UIColor whiteColor];
    _buttonBackgroundColor = [UIColor blueColor];
    _margin = 5.f;
    
    //创建能装下所有自定义视图和按钮的容器视图
    UIView *containerView = [[UIView alloc] init];
    containerView.layer.cornerRadius = 5.f;
    [self addSubview:containerView];
    self.containerView = containerView;
    
    [containerView addSubview:self.customView];
    
    [self.buttonNamesArray enumerateObjectsUsingBlock:^(NSString *buttonName, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //创建按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:buttonName forState:UIControlStateNormal];
        [btn setTitleColor:self.buttonTextColor forState:UIControlStateNormal];
        [btn setBackgroundColor:self.buttonBackgroundColor];
        
        [containerView addSubview:btn];
        [self.buttonsArray addObject:btn];
        
        //创建只有一个像素宽的分割线
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [UIColor grayColor];
        [self.containerView addSubview:lineView];
        [self.lineViewArray addObject:lineView];
    }];
    
}

- (void)setupFrames{
    
    CGSize customViewSize = self.customView.bounds.size;
    
    CGFloat customViewWidth = customViewSize.width;
    CGFloat customViewHeight = customViewSize.height;
    
    CGFloat containerWidth = customViewWidth + 2 * _margin;
    
    self.customView.frame = CGRectMake(_margin, _margin, customViewWidth, customViewHeight);
    
    if (self.lineViewArray.count == 1) {
        UIView *line1 = self.lineViewArray[0];
        line1.frame = CGRectMake(0, customViewHeight + _margin, containerWidth, 1);
        
        
    }
    
}

@end
