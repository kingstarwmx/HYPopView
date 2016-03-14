//
//  HYImageAndButtonView.m
//  HudDemo
//
//  Created by MrZhangKe on 16/3/14.
//  Copyright © 2016年 Matej Bukovinski. All rights reserved.
//

#import "HYImageAndButtonView.h"
#import "HYWithButtonView.h"


@interface HYImageAndButtonView ()

@property (nonatomic, strong) UIView *containerView;//容器视图

@property (nonatomic, strong) UIView *indicator;//悬浮的视图

@property (nonatomic, strong) NSDate *showStarted;

@property (nonatomic, assign) BOOL useAnimation;

@property (nonatomic, assign, getter=isFinished) BOOL finished;

@end

@implementation HYImageAndButtonView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self updateIndicators];
        [self setupFrames];
    }
    return self;
}

- (instancetype)initWithView:(UIView *)view{
    return [self initWithFrame:view.bounds];
}


- (instancetype)initWithCustomView:(UIView *)customView buttonsArray:(NSArray<__kindof UIButton *> *)buttonsArray{
    
    
    _customView = customView;
    _buttonsArray = buttonsArray;
    
    
    return [self initWithFrame:[UIScreen mainScreen].bounds];
}

+ (instancetype)showHUDAddedTo:(UIView *)view animated:(BOOL)animated{
    HYImageAndButtonView *popView = [[self alloc] initWithView:view];
    //[popView removeFromSuperview];
    [view addSubview:popView];
    [popView showAnimated:animated];
    return popView;
}


- (void)setupViews{
    
    //设置默认属性
    _animationType = HYPopViewAnimationZoom;
    _removeFromSuperViewOnHide = YES;
    self.backgroundColor = [UIColor clearColor];
    // Make it invisible for now
    self.alpha = 0.0f;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.layer.allowsGroupOpacity = NO;
    
    //设置背景视图
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    NSLog(@"-------------%@", backgroundView.backgroundColor);
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    backgroundView.alpha = 0.f;
    [self addSubview:backgroundView];
    _backgroundView = backgroundView;
    
    UIView *containerView = [UIView new];
    containerView.layer.cornerRadius = 5.f;
    containerView.clipsToBounds = YES;
    containerView.alpha = 0.f;
    [self addSubview:containerView];
    _containerView = containerView;
    
}


//更新指示器视图
- (void)updateIndicators {
    
    UIView *indicator = self.indicator;
    [indicator removeFromSuperview];
    HYWithButtonView *btnView = [[HYWithButtonView alloc] initWithCustomView:self.customView buttonsArray:self.buttonsArray];
    indicator = btnView;
    
    [self.containerView addSubview:indicator];
    self.indicator = indicator;
    [self setupFrames];
}

- (void)setupFrames{
    
    self.containerView.bounds = self.indicator.bounds;
    self.containerView.center = self.center;
    
    [self setNeedsDisplay];
    
}


- (void)showAnimated:(BOOL)animated {
    //    MBMainThreadAssert();
    self.useAnimation = animated;
    self.finished = NO;
    [self showUsingAnimation:self.useAnimation];
}

- (void)showUsingAnimation:(BOOL)animated {
    // Cancel any scheduled hideDelayed: calls
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    self.showStarted = [NSDate date];
    self.alpha = 1.f;
    
    if (animated) {
        [self animateIn:YES withType:self.animationType completion:NULL];
    } else {
        
        self.containerView.alpha = 1.f;
        self.backgroundView.alpha = 1.f;
    }
}

- (void)hide:(BOOL)animated {
    [self hideAnimated:animated];
}

- (void)hideAnimated:(BOOL)animated {
    self.useAnimation = animated;
    self.finished = YES;
    
    [self hideUsingAnimation:self.useAnimation];
}

- (void)hideUsingAnimation:(BOOL)animated {
    if (animated && self.showStarted) {
        [self animateIn:NO withType:self.animationType completion:^(BOOL finished) {
            [self done];
        }];
    } else {
        self.containerView.alpha = 0.f;
        self.backgroundView.alpha = 1.f;
        [self done];
    }
    self.showStarted = nil;
}

- (void)handleMinShowTimer:(NSTimer *)theTimer {
    [self hideUsingAnimation:self.useAnimation];
}

- (void)done {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.alpha = 0.0f;
    if (self.removeFromSuperViewOnHide) {
        [self removeFromSuperview];
    }
    
    id<HYImageAndButtonViewDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(hudWasHidden:)]) {
        [delegate hudWasHidden:self];
    }
    
}

//动画
- (void)animateIn:(BOOL)animatingIn withType:(HYPopViewAnimationType)type completion:(void(^)(BOOL finished))completion {
    // Automatically determine the correct
    if (type == HYPopViewAnimationZoom) {
        type = animatingIn ? HYPopViewAnimationZoomIn : HYPopViewAnimationZoomOut;
    }
    
    CGAffineTransform small = CGAffineTransformMakeScale(0.5f, 0.5f);
    CGAffineTransform large = CGAffineTransformMakeScale(1.5f, 1.5f);
    
    
    
    // 设置开始动画时的状态
    UIView *containerView = self.containerView;
    NSLog(@"opacity:%f", containerView.alpha);
    if (animatingIn && containerView.alpha == 0.f && type == HYPopViewAnimationZoomIn) {
        containerView.transform = small;
    } else if (animatingIn && containerView.alpha == 0.f && type == HYPopViewAnimationZoomOut) {
        containerView.transform = large;
    }
    
    // Perform animations
    dispatch_block_t animations = ^{
        if (animatingIn) {
            containerView.transform = CGAffineTransformIdentity;
        } else if (!animatingIn && type == HYPopViewAnimationZoomIn) {
            containerView.transform = large;
        } else if (!animatingIn && type == HYPopViewAnimationZoomOut) {
            containerView.transform = small;
        }
        
        containerView.alpha = animatingIn ? 1.f : 0.f;
        self.backgroundView.alpha = animatingIn ? 1.f : 0.f;
    };
    
    // Spring动画只能应用在iOS7及以上的设备
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0) {
        [UIView animateWithDuration:0.3 delay:0.f usingSpringWithDamping:1.f initialSpringVelocity:0.f options:UIViewAnimationOptionBeginFromCurrentState animations:animations completion:completion];
        
        return;
    }
#endif
    [UIView animateWithDuration:0.3 delay:0. options:UIViewAnimationOptionBeginFromCurrentState animations:animations completion:completion];
}

#pragma mark -- properties

- (void)setCustomView:(UIView *)customView {
    if (customView != _customView) {
        _customView = customView;
        [self updateIndicators];
        
        
    }
}

- (void)setButtonsArray:(NSArray *)buttonsArray{
    if (buttonsArray != _buttonsArray) {
        _buttonsArray = buttonsArray;
        [self updateIndicators];
    }
}
@end


