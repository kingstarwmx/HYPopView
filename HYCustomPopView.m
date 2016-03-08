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

@property (nonatomic, weak) UIView *belowView;

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


- (instancetype)initWithCustomView:(UIView *)customView buttonNamesArray:(NSArray<__kindof NSString *> *)buttonNamesArray aboveView:(UIView *)view{
    
    _customView = customView;
    _buttonNamesArray = buttonNamesArray;
    _belowView = view;
    return [self initWithFrame:[UIScreen mainScreen].bounds];
}

- (void)show{
    
//    UIWindow *keyWindow = [[UIApplication sharedApplication].delegate window];
//    keyWindow.backgroundColor = [UIColor redColor];
    [self.belowView addSubview:self];
    
    //self.containerView.center = keyWindow.center;
}

- (void)setupViews{
    
    self.buttonsArray = [NSMutableArray array];
    self.lineViewArray = [NSMutableArray array];
    
    //设置默认属性
    _buttonBackgroundColor = [UIColor whiteColor];
    _buttonTextColor = [UIColor blueColor];
    _margin = 0.f;
    
    //创建能装下所有自定义视图和按钮的容器视图
    UIView *containerView = [[UIView alloc] init];
    containerView.layer.cornerRadius = 7.f;
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.clipsToBounds = YES;
    [self addSubview:containerView];
    self.containerView = containerView;
    
    [containerView addSubview:self.customView];
    
    
    for (NSString *buttonName in self.buttonNamesArray) {
        //创建按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:buttonName forState:UIControlStateNormal];
        [btn setTitleColor:self.buttonTextColor forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        
        [btn setBackgroundColor:self.buttonBackgroundColor];
        
        [containerView addSubview:btn];
        [self.buttonsArray addObject:btn];
        
        //创建只有一个像素宽的分割线
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [containerView addSubview:lineView];
        [self.lineViewArray addObject:lineView];
    }
    
}

- (void)setupFrames{
    
    CGSize customViewSize = self.customView.bounds.size;
    
    CGFloat customViewWidth = customViewSize.width;
    CGFloat customViewHeight = customViewSize.height;
    CGFloat buttonWidth = 44.f;
    CGFloat lineWidth = 0.5f;
    
    CGFloat containerWidth = customViewWidth + 2 * _margin;
    
    self.customView.frame = CGRectMake(_margin, _margin, customViewWidth, customViewHeight);
    
    NSLog(@"%lu", self.lineViewArray.count);
    UIView *line1 = [self.lineViewArray objectAtIndex:0];
    line1.frame = CGRectMake(0, customViewHeight + _margin, containerWidth, lineWidth);
    
    if (self.lineViewArray.count == 1) {
        
        UIButton *btn = self.buttonsArray[0];
        btn.frame = CGRectMake(0, CGRectGetMaxY(line1.frame), containerWidth, buttonWidth);
        
    }else if (self.lineViewArray.count == 2){
        
        UIView *line2 = self.lineViewArray[1];
        line2.frame = CGRectMake((containerWidth - lineWidth) / 2 , customViewHeight + _margin + lineWidth, lineWidth, buttonWidth);
        
        UIButton *btn1 = self.buttonsArray[0];
        btn1.frame = CGRectMake(0, CGRectGetMaxY(line1.frame), (containerWidth - lineWidth) / 2 , buttonWidth);
        
        UIButton *btn2 = self.buttonsArray[1];
        btn2.frame = CGRectMake(CGRectGetMaxX(line2.frame), CGRectGetMaxY(line1.frame), (containerWidth - lineWidth) / 2 , buttonWidth);
        
    }
    
    self.containerView.bounds = CGRectMake(0, 0, containerWidth, _margin + customViewHeight + lineWidth + buttonWidth);
    self.containerView.center = self.center;
}

@end
