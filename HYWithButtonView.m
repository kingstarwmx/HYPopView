//
//  HYWithButtonView.m
//  HudDemo
//
//  Created by MrZhangKe on 16/3/10.
//  Copyright © 2016年 Matej Bukovinski. All rights reserved.
//

#import "HYWithButtonView.h"

@interface HYWithButtonView ()

@property (nullable, nonatomic, strong) NSArray *buttonsArray;

@property (nullable, nonatomic, strong) UIView *customView;

@property (nonatomic, assign) CGFloat margin;

@property (nonatomic, assign) NSInteger buttonCount;

@property (nonatomic, strong) NSMutableArray *lineViewArray;

@end

@implementation HYWithButtonView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self setupFrames];
        self.layer.cornerRadius = 5.f;
        self.clipsToBounds = YES;
        
    }
    return self;
}

- (instancetype)initWithCustomView:(nullable UIView *)customView buttonsArray:(nullable NSArray<__kindof UIButton *> *)buttonsArray{
    _customView = customView;
    _buttonsArray = buttonsArray;
    
    CGRect rect = [self setupFrames];
    return [self initWithFrame:rect];
    
}

- (void)setupViews{
    
    
    self.backgroundColor = [UIColor whiteColor];
    self.lineViewArray = [NSMutableArray array];
    
    //设置默认属性
    _margin = 0.f;
    self.backgroundColor = [UIColor whiteColor];
    
    
    //添加按钮
    for (UIView *button in self.buttonsArray) {
        //创建只有一个像素宽的分割线并添加到视图
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [UIColor colorWithRed:.3 green:.3 blue:.3 alpha:.3];
        [self addSubview:lineView];
        [self.lineViewArray addObject:lineView];
        
        //把传过来的Button添加到视图
        [self addSubview:button];
    }
    
    [self addSubview:self.customView];
    
}

- (CGRect)setupFrames{
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    //CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    CGSize customViewSize = self.customView.bounds.size;
    
    if ((customViewSize.width / screenWidth * 0.8) > 1) {
        
    }
    
    BOOL isOverSize = (customViewSize.width / screenWidth * 0.8) > 1;
    CGFloat customViewWidth = isOverSize ? screenWidth * 0.8:customViewSize.width;
    CGFloat customViewHeight = isOverSize ? customViewSize.height * screenWidth * 0.8 /  customViewSize.width: customViewSize.height;
    
    CGFloat buttonHeight = 44.f;
    CGFloat lineHeight = 0.5f;
    
    CGFloat containerWidth = customViewWidth + 2 * _margin;
    CGFloat containerHeight = 0.f;
    
    self.customView.frame = CGRectMake(_margin, _margin, customViewWidth, customViewHeight);
    
    NSLog(@"%lu", self.lineViewArray.count);
    
    
    if (self.buttonsArray.count == 2) {
        UIView *line1 = [self.lineViewArray objectAtIndex:0];
        line1.frame = CGRectMake(0, customViewHeight + _margin, containerWidth, lineHeight);
        
        UIView *line2 = self.lineViewArray[1];
        line2.frame = CGRectMake((containerWidth - lineHeight) / 2 , customViewHeight + _margin + lineHeight, lineHeight, buttonHeight);
        
        UIButton *btn1 = self.buttonsArray[0];
        btn1.frame = CGRectMake(0, CGRectGetMaxY(line1.frame), (containerWidth - lineHeight) / 2 , buttonHeight);
        
        UIButton *btn2 = self.buttonsArray[1];
        btn2.frame = CGRectMake(CGRectGetMaxX(line2.frame), CGRectGetMaxY(line1.frame), (containerWidth - lineHeight) / 2 , buttonHeight);
        
        containerHeight =  _margin + customViewHeight + lineHeight + buttonHeight;
        
    }else {
        for (int i = 0; i < self.lineViewArray.count; i ++) {
            UIButton *btn = self.buttonsArray[i];
            btn.frame = CGRectMake(0, customViewHeight + _margin + lineHeight + (buttonHeight + lineHeight) * i, containerWidth, buttonHeight);
            
            UIView *line = self.lineViewArray[i];
            line.frame = CGRectMake(0, customViewHeight + _margin + (buttonHeight + lineHeight) * i, containerWidth, lineHeight);
        }
        containerHeight =  _margin + customViewHeight + (lineHeight + buttonHeight) * self.lineViewArray.count;
        
    }
    
    
    
    CGRect selfFrame = CGRectMake(0, 0, containerWidth, containerHeight);
    
    return selfFrame;
}

@end
