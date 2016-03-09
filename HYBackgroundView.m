//
//  HYBackgroundView.m
//  HudDemo
//
//  Created by MrZhangKe on 16/3/9.
//  Copyright © 2016年 Matej Bukovinski. All rights reserved.
//

#import "HYBackgroundView.h"

@interface HYBackgroundView ()

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
@property UIVisualEffectView *effectView;
#endif
@property UIToolbar *toolbar;

@end

@implementation HYBackgroundView

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0) {
            _style = HYBackgroundStyleBlur;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
            _color = [UIColor colorWithWhite:0.8f alpha:0.6f];
#else
            _color = [UIColor colorWithWhite:0.95f alpha:0.6f];
#endif
        } else {
            _style = HYBackgroundStyleSolidColor;
            _color = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        }
        
        self.clipsToBounds = YES;
        
        [self updateForBackgroundStyle];
    }
    return self;
}

#pragma mark - Layout

- (CGSize)intrinsicContentSize {
    // Smallest size possible. Content pushes against this.
    return CGSizeZero;
}

#pragma mark - Appearance

- (void)setStyle:(HYBackgroundStyle)style {
    if (style == HYBackgroundStyleBlur && kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_7_0) {
        style = HYBackgroundStyleSolidColor;
    }
    if (_style != style) {
        _style = style;
        [self updateForBackgroundStyle];
    }
}

- (void)setColor:(UIColor *)color {
    NSAssert(color, @"The color should not be nil.");
    if (color != _color && ![color isEqual:_color]) {
        _color = color;
        [self updateViewsForColor:color];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Views

- (void)updateForBackgroundStyle {
    HYBackgroundStyle style = self.style;
    if (style == HYBackgroundStyleBlur) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        [self addSubview:effectView];
        effectView.frame = self.bounds;
        effectView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = self.color;
        self.layer.allowsGroupOpacity = NO;
        self.effectView = effectView;
#else
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectInset(self.bounds, -100.f, -100.f)];
        toolbar.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        toolbar.barTintColor = self.color;
        toolbar.translucent = YES;
        toolbar.barTintColor = color;
        [self addSubview:toolbar];
        self.toolbar = toolbar;
#endif
    } else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
        [self.effectView removeFromSuperview];
        self.effectView = nil;
#else
        [self.toolbar removeFromSuperview];
        self.toolbar = nil;
#endif
        self.backgroundColor = self.color;
    }
}

- (void)updateViewsForColor:(UIColor *)color {
    if (self.style == HYBackgroundStyleBlur) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
        self.backgroundColor = self.color;
#else
        self.toolbar.barTintColor = color;
#endif
    } else {
        self.backgroundColor = self.color;
    }
}

@end
