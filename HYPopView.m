//
//  HYPopView.m
//  HudDemo
//
//  Created by MrZhangKe on 16/3/9.
//  Copyright © 2016年 Matej Bukovinski. All rights reserved.
//

#import "HYPopView.h"
#import "HYWithButtonView.h"
#import "HYRoundProgressView.h"

@interface HYPopView ()

@property (nonatomic, strong) HYBackgroundView *containerView;//容器视图

@property (nonatomic, strong) UIView *indicator;

@property (nonatomic, strong) NSDate *showStarted;

@property (nonatomic, assign) BOOL useAnimation;

@property (nonatomic, assign, getter=isFinished) BOOL finished;

@property (nonatomic, strong) NSTimer *graceTimer;

@property (nonatomic, strong) NSTimer *minShowTimer;

@property (nonatomic, strong) NSMutableArray *lineViewArray;

@property (nonatomic, weak) UIView *belowView;

@property (strong, nonatomic, readonly) UILabel *label;

@property (strong, nonatomic, readonly) UILabel *detailsLabel;

@end

@implementation HYPopView

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
    _customView = view;
    return [self initWithFrame:view.bounds];
}


- (instancetype)initWithCustomView:(UIView *)customView buttonsArray:(NSArray<__kindof UIButton *> *)buttonsArray{
    
    _customView = customView;
    _buttonsArray = buttonsArray;
    return [self initWithFrame:[UIScreen mainScreen].bounds];
}

+ (instancetype)showHUDAddedTo:(UIView *)view animated:(BOOL)animated{
    HYPopView *popView = [[self alloc] initWithView:view];
    [popView removeFromSuperview];
    [view addSubview:popView];
    [popView showAnimated:animated];
    return popView;
}

+ (HYPopView *)HUDForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (HYPopView *)subview;
        }
    }
    return nil;
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
    _margin = 20.f;
    _animationType = HYPopViewAnimationZoom;
    _mode = HYPopViewModeIndeterminate;
    self.backgroundColor = [UIColor clearColor];
    // Make it invisible for now
    self.alpha = 0.0f;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.layer.allowsGroupOpacity = NO;
    
    //设置背景视图
    HYBackgroundView *backgroundView = [[HYBackgroundView alloc] initWithFrame:self.bounds];
    backgroundView.style = HYBackgroundStyleSolidColor;
    backgroundView.backgroundColor = [UIColor clearColor];
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    backgroundView.alpha = 0.f;
    [self addSubview:backgroundView];
    _backgroundView = backgroundView;
    
    
    
    //创建能装下所有自定义视图和按钮的容器视图
    HYBackgroundView *containerView = [[HYBackgroundView alloc] init];
    containerView.layer.cornerRadius = 5.f;
    containerView.backgroundColor = [UIColor blackColor];
    containerView.clipsToBounds = YES;
    containerView.alpha = 0;
    [self addSubview:containerView];
    self.containerView = containerView;
    
    UILabel *label = [UILabel new];
    label.adjustsFontSizeToFitWidth = NO;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = self.contentColor;
    label.font = [UIFont boldSystemFontOfSize:HYDefaultLabelFontSize];
    [self.containerView addSubview:label];
    _label = label;
    
    
    UILabel *detailsLabel = [UILabel new];
    detailsLabel.adjustsFontSizeToFitWidth = NO;
    detailsLabel.textAlignment = NSTextAlignmentCenter;
    detailsLabel.textColor = self.contentColor;
    detailsLabel.numberOfLines = 0;
    detailsLabel.font = [UIFont boldSystemFontOfSize:HYDefaultDetailsLabelFontSize];
    [self.containerView addSubview:detailsLabel];
    _detailsLabel = detailsLabel;
    
//    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    [(UIActivityIndicatorView *)self.indicator startAnimating];
//    self.indicator.backgroundColor = [UIColor redColor];
//    [self.containerView addSubview:self.indicator];
    
}

//更新指示器视图
- (void)updateIndicators {
    UIView *indicator = self.indicator;
    BOOL isActivityIndicator = [indicator isKindOfClass:[UIActivityIndicatorView class]];
    BOOL isRoundIndicator = [indicator isKindOfClass:[HYRoundProgressView class]];
    
    HYPopViewMode mode = self.mode;
    if (mode == HYPopViewModeIndeterminate) {
        if (!isActivityIndicator) {
            // Update to indeterminate indicator
            [indicator removeFromSuperview];
            indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [(UIActivityIndicatorView *)indicator startAnimating];
            [self.containerView addSubview:indicator];
        }
    }
    else if (mode == HYPopViewModeAnnularDeterminate) {
        if (!isRoundIndicator) {
            // Update to determinante indicator
            [indicator removeFromSuperview];
            indicator = [[HYRoundProgressView alloc] init];
            [self.containerView addSubview:indicator];
        }

            [(HYRoundProgressView *)indicator setAnnular:YES];
        
    }
    else if (mode == HYPopViewModeCustomView && self.customView != indicator) {
        // Update custom view indicator
        [indicator removeFromSuperview];
        indicator = self.customView;
        NSLog(@"%@\n%@\n---------\n%@\n%@",self,self.subviews,indicator,indicator.subviews);
        [self.containerView addSubview:indicator];
        
//        [indicator removeFromSuperview];
//        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//        [(UIActivityIndicatorView *)indicator startAnimating];
//        [self.containerView addSubview:indicator];
        
    }
    else if (mode == HYPopViewModeText) {
        [indicator removeFromSuperview];
        indicator = nil;
    }else if (mode == HYPopViewModePictureAndButton){
        [indicator removeFromSuperview];
        indicator = [[HYWithButtonView alloc] initWithCustomView:self.customView buttonsArray:self.buttonsArray];
        [self.containerView addSubview:indicator];
    }
    //indicator.translatesAutoresizingMaskIntoConstraints = NO;
    self.indicator = indicator;
    
    if ([indicator respondsToSelector:@selector(setProgress:)]) {
        [(id)indicator setValue:@(self.progress) forKey:@"progress"];
    }
    
    
    [self updateViewsForColor:self.contentColor];
    [self setupFrames];
}

- (void)updateViewsForColor:(UIColor *)color {
    if (!color) return;
    
    self.label.textColor = color;
    self.detailsLabel.textColor = color;
    
    
    UIView *indicator = self.indicator;
    if ([indicator isKindOfClass:[UIActivityIndicatorView class]]) {
        ((UIActivityIndicatorView *)indicator).color = color;
    } else if ([indicator isKindOfClass:[HYRoundProgressView class]]) {
        ((HYRoundProgressView *)indicator).progressTintColor = color;
        ((HYRoundProgressView *)indicator).backgroundTintColor = [color colorWithAlphaComponent:0.1];
    } else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        if ([indicator respondsToSelector:@selector(setTintColor:)]) {
            [indicator setTintColor:color];
        }
#endif
    }
}


- (void)setupFrames{
    
    CGFloat indicatorWidth = 0;
    CGFloat indicatorHeight = 0;
    
    CGSize labelSize = CGSizeZero;
    CGSize detailLabelSize = CGSizeZero;
    
    if (self.indicator) {
        indicatorWidth = self.indicator.bounds.size.width;
        indicatorHeight = self.indicator.bounds.size.width;
    }
    
    NSValue *sizeValue = [NSValue valueWithCGSize:CGSizeMake(self.bounds.size.width * 0.8, MAXFLOAT)];
    if (self.labelText) {
        labelSize = [self.labelText sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:HYDefaultLabelFontSize]}];
//        , NSViewSizeDocumentAttribute:sizeValue
    }
    if (self.detailsLabelText) {
        detailLabelSize = [self.labelText sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:HYDefaultDetailsLabelFontSize], NSViewSizeDocumentAttribute:sizeValue}];
    }
    
    
    CGFloat containerWidth = MAX(MAX(indicatorWidth, labelSize.width), detailLabelSize.width) + 2 * self.margin;
    CGFloat padding1 = self.labelText ? HYDefaultPadding:0;
    CGFloat padding2 = self.detailsLabelText ? HYDefaultPadding:0;
    CGFloat containerHeight = indicatorHeight + labelSize.height + detailLabelSize.height + padding1 + padding2 + 2 * self.margin;
    
    //设置containerView的中心，根据传入的offset偏移
    self.containerView.bounds = CGRectMake(0, 0, containerWidth, containerHeight);
    self.containerView.center = CGPointMake(self.center.x + self.offset.x, self.center.y + self.offset.y);
    
    CGFloat indicatorX = (containerWidth - indicatorWidth) / 2;
    CGFloat indicatorY = self.margin;
    self.indicator.frame = CGRectMake(indicatorX, indicatorY, indicatorWidth, indicatorHeight);
    
    CGFloat LabelX = (containerWidth - labelSize.width) / 2;
    CGFloat LabelY = CGRectGetMaxY(self.indicator.frame) + padding1;
    self.label.frame = CGRectMake(LabelX, LabelY, labelSize.width, labelSize.height);
    
    CGFloat detailsLabelX = (containerWidth - detailLabelSize.width) / 2;
    CGFloat detailsLabelY = CGRectGetMaxY(self.label.frame) + padding2;
    self.detailsLabel.frame = CGRectMake(detailsLabelX, detailsLabelY, detailLabelSize.width, detailLabelSize.height);
    
    [self setNeedsDisplay];
    
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

#pragma mark -- properties

- (void)setCustomView:(UIView *)customView {
    if (customView != _customView) {
        _customView = customView;
        if (self.mode == HYPopViewModeCustomView) {
            [self updateIndicators];
        }
        
    }
}


- (void)setButtonsArray:(NSArray *)buttonsArray{
    if (buttonsArray != _buttonsArray) {
        _buttonsArray = buttonsArray;
        [self updateIndicators];
        //[self setupFrames];
    }
}

- (void) setLabelText:(NSString *)labelText {
    if (labelText != _labelText) {
        _labelText = labelText;
        self.label.text = self.labelText;
        [self.label setFont:[UIFont systemFontOfSize:HYDefaultLabelFontSize]];
        [self setupFrames];
    }
}

- (void) setDetailsLabelText:(NSString *)detailsLabelText {
    if (detailsLabelText != _detailsLabelText) {
        _detailsLabelText = detailsLabelText;
        self.detailsLabel.text = self.detailsLabelText;
        [self.label setFont:[UIFont systemFontOfSize:HYDefaultDetailsLabelFontSize]];
        [self setupFrames];
    }
}

- (void)setProgress:(float)progress {
    if (progress != _progress) {
        _progress = progress;
        UIView *indicator = self.indicator;
        if ([indicator respondsToSelector:@selector(setProgress:)]) {
            [(id)indicator setValue:@(self.progress) forKey:@"progress"];
        }
    }
}

- (void)setContentColor:(UIColor *)contentColor {
    if (contentColor != _contentColor && ![contentColor isEqual:_contentColor]) {
        _contentColor = contentColor;
        [self updateViewsForColor:contentColor];
    }
}

- (void)setMode:(HYPopViewMode)mode {
    if (mode != _mode) {
        _mode = mode;
        [self updateIndicators];
        [self setupFrames];
    }
}

@end
