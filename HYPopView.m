//
//  HYPopView.m
//  HudDemo
//
//  Created by MrZhangKe on 16/3/9.
//  Copyright © 2016年 Matej Bukovinski. All rights reserved.
//

#import "HYPopView.h"

@interface HYPopView ()

@property (nonatomic, strong) UIView *containerView;//容器视图

@property (nonatomic, strong) NSDate *showStarted;

@property (nonatomic, assign) BOOL useAnimation;

@property (nonatomic, assign, getter=isFinished) BOOL finished;

@property (nonatomic, strong) NSTimer *graceTimer;

@property (nonatomic, strong) NSTimer *minShowTimer;

@property (nonatomic, strong) NSMutableArray *lineViewArray;

@property (nonatomic, weak) UIView *belowView;

@end

@implementation HYPopView

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


- (instancetype)initWithCustomView:(UIView *)customView buttonsArray:(NSArray<__kindof UIButton *> *)buttonsArray{
    
    _customView = customView;
    _buttonsArray = buttonsArray;
    return [self initWithFrame:[UIScreen mainScreen].bounds];
}

- (void)showAboveView:(UIView *)view{
    
    //    UIWindow *keyWindow = [[UIApplication sharedApplication].delegate window];
    //    keyWindow.backgroundColor = [UIColor redColor];
    [view addSubview:self];
    [self showAnimated:YES];
    
    //self.containerView.center = keyWindow.center;
}

- (void)setupViews{
    
    //self.buttonsArray = [NSMutableArray array];
    self.lineViewArray = [NSMutableArray array];
    
    //设置默认属性
    _margin = 0.f;
    _animationType = HYPopViewAnimationFade;
    self.backgroundColor = [UIColor clearColor];
    // Make it invisible for now
    self.alpha = 0.0f;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.layer.allowsGroupOpacity = NO;
    
    //创建能装下所有自定义视图和按钮的容器视图
    UIView *containerView = [[UIView alloc] init];
    containerView.layer.cornerRadius = 7.f;
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.clipsToBounds = YES;
    containerView.alpha = 0;
    [self addSubview:containerView];
    self.containerView = containerView;
    
    [containerView addSubview:self.customView];
    
    for (int i = 0; i < self.buttonsArray.count; i ++) {
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
        [self.containerView addSubview:btn];
        
    }else if (self.lineViewArray.count == 2){
        
        UIView *line2 = self.lineViewArray[1];
        line2.frame = CGRectMake((containerWidth - lineWidth) / 2 , customViewHeight + _margin + lineWidth, lineWidth, buttonWidth);
        
        UIButton *btn1 = self.buttonsArray[0];
        btn1.frame = CGRectMake(0, CGRectGetMaxY(line1.frame), (containerWidth - lineWidth) / 2 , buttonWidth);
        [self.containerView addSubview:btn1];
        
        UIButton *btn2 = self.buttonsArray[1];
        btn2.frame = CGRectMake(CGRectGetMaxX(line2.frame), CGRectGetMaxY(line1.frame), (containerWidth - lineWidth) / 2 , buttonWidth);
        [self.containerView addSubview:btn2];
        
    }
    
    self.containerView.bounds = CGRectMake(0, 0, containerWidth, _margin + customViewHeight + lineWidth + buttonWidth);
    self.containerView.center = self.center;
}

- (void)showAnimated:(BOOL)animated {
    //    MBMainThreadAssert();
    self.useAnimation = animated;
    self.finished = NO;
    // If the grace time is set postpone the HUD display
    if (self.graceTime > 0.0) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:self.graceTime target:self selector:@selector(handleGraceTimer:) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        self.graceTimer = timer;
    }
    // ... otherwise show the HUD imediately
    else {
        [self showUsingAnimation:self.useAnimation];
    }
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
    // If the minShow time is set, calculate how long the hud was shown,
    // and pospone the hiding operation if necessary
    if (self.minShowTime > 0.0 && self.showStarted) {
        NSTimeInterval interv = [[NSDate date] timeIntervalSinceDate:self.showStarted];
        if (interv < self.minShowTime) {
            NSTimer *timer = [NSTimer timerWithTimeInterval:(self.minShowTime - interv) target:self selector:@selector(handleMinShowTimer:) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
            self.minShowTimer = timer;
            return;
        }
    }
    // ... otherwise hide the HUD immediately
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
    //    if (self.completionBlock) {
    //        self.completionBlock();
    //        self.completionBlock = NULL;
    //    }
    
    id<HYPopViewDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(hudWasHidden:)]) {
        [delegate performSelector:@selector(hudWasHidden:) withObject:self];
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
    
    
    
    // Set starting state
    UIView *containerView = self.containerView;
    
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
    
    // Spring动画只能应用在iOS7以上的设备
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0) {
        [UIView animateWithDuration:0.3 delay:0.f usingSpringWithDamping:1.f initialSpringVelocity:0.f options:UIViewAnimationOptionBeginFromCurrentState animations:animations completion:completion];
        
        return;
    }
#endif
    [UIView animateWithDuration:0.3 delay:0. options:UIViewAnimationOptionBeginFromCurrentState animations:animations completion:completion];
}

- (void)handleGraceTimer:(NSTimer *)theTimer {
    // Show the HUD only if the task is still running
    if (!self.isFinished) {
        [self showUsingAnimation:self.useAnimation];
    }
}

@end
