//
//  HYPopView.h
//  HudDemo
//
//  Created by MrZhangKe on 16/3/9.
//  Copyright © 2016年 Matej Bukovinski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBackgroundView.h"


static const CGFloat HYDefaultPadding = 4.f;
static const CGFloat HYDefaultLabelFontSize = 16.f;
static const CGFloat HYDefaultDetailsLabelFontSize = 12.f;

@protocol HYPopViewDelegate;

typedef NS_ENUM(NSInteger, HYPopViewMode) {
    /// 可显示文字，提示动画是系统的UIActivityIndicatorView
    HYPopViewModeIndeterminate,
    /// 可显示文字，提示动画是圆环
    HYPopViewModeAnnularDeterminate,
    /// 可显示文字，并且可以自定义图像来代替自带的提示动画，
    HYPopViewModeCustomView,
    /// 只显示文字
    HYPopViewModeText,
    /// 可显示图片和按钮
    HYPopViewModePictureAndButton
};

typedef NS_ENUM(NSInteger, HYPopViewAnimationType) {
    /// Opacity animation
    HYPopViewAnimationFade,
    /// Opacity + scale animation (zoom in when appearing zoom out when disappearing)
    HYPopViewAnimationZoom,
    /// Opacity + scale animation (zoom out style)
    HYPopViewAnimationZoomOut,
    /// Opacity + scale animation (zoom in style)
    HYPopViewAnimationZoomIn
};

@interface HYPopView : UIView


@property (nonatomic, strong) NSArray *buttonsArray;

//在HYPopViewModeCustomView下可以自定义视图
@property (nonatomic, strong) UIView *customView;

@property (copy, nonatomic) NSString *labelText;

@property (copy, nonatomic) NSString *detailsLabelText;

@property (strong, nonatomic, nullable) UIColor *contentColor;//控制视图上显示内容的颜色

@property (nonatomic, strong) HYBackgroundView *backgroundView;//让背景变暗的视图,起到屏蔽作用跟突出前景作用

@property (nonatomic, assign) HYPopViewAnimationType animationType;

@property (assign, nonatomic) HYPopViewMode mode;

@property (nonatomic, assign) CGFloat margin;

/**
 * The progress of the progress indicator, from 0.0 to 1.0. Defaults to 0.0.
 */
@property (assign, nonatomic) float progress;
/**
 *  在这个graceTime(宽限时间)之内如果点击相应了将不会弹出视图，默认是0
 */
@property (assign, nonatomic) NSTimeInterval graceTime;

@property (assign, nonatomic) NSTimeInterval minShowTime;

@property (assign, nonatomic) CGPoint offset;

/**
 * Removes the HUD from its parent view when hidden.
 * Defaults to NO.
 */
@property (assign, nonatomic) BOOL removeFromSuperViewOnHide;

@property (weak, nonatomic) id<HYPopViewDelegate> delegate;

- (nonnull instancetype)initWithView:(nonnull UIView *)view;

+ (nullable HYPopView *)HUDForView:(nonnull UIView *)view;

- (instancetype)initWithCustomView:(nullable UIView *)customView buttonsArray:(nullable NSArray<__kindof UIButton *> *)buttonsArray;

+ (instancetype)showHUDAddedTo:(UIView *)view animated:(BOOL)animated;



- (void)showAnimated:(BOOL)animated;

- (void)hideAnimated:(BOOL)animated;

@end


@protocol HYPopViewDelegate <NSObject>

@optional

/**
 * Called after the HUD was fully hidden from the screen.
 */
- (void)hudWasHidden:(HYPopView *)hud;

@end
