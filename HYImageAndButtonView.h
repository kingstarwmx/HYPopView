//
//  HYImageAndButtonView.h
//  HudDemo
//
//  Created by MrZhangKe on 16/3/14.
//  Copyright © 2016年 Matej Bukovinski. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYImageAndButtonView;

@protocol HYImageAndButtonViewDelegate<NSObject>

@optional

/**
 * 弹框消失后移除
 */
- (void)hudWasHidden:(HYImageAndButtonView *)hud;

@end

//static const CGFloat HYDefaultPadding = 4.f;
//static const CGFloat HYDefaultLabelFontSize = 16.f;
//static const CGFloat HYDefaultDetailsLabelFontSize = 12.f;


typedef NS_ENUM(NSInteger, HYPopViewAnimationType) {
    /// 只有透明度淡入淡出
    HYPopViewAnimationFade,
    /// 既有透明度动画也有大小改变的动画(入画的时候变大，出画的时候变小)
    HYPopViewAnimationZoom,
    /// 既有透明度动画也有大小改变的动画(入画的时候变大，出画的时候变大)
    HYPopViewAnimationZoomOut,
    /// 既有透明度动画也有大小改变的动画(入画的时候变小，出画的时候变小)
    HYPopViewAnimationZoomIn
};

@interface HYImageAndButtonView : UIView


@property (nullable, nonatomic, strong) NSArray *buttonsArray;

//在HYPopViewModeCustomView下可以自定义视图
@property (nullable, nonatomic, strong) UIView *customView;

/**
 *  让背景变暗的视图,起到屏蔽作用跟突出前景作用,默认颜色是RGBA(0，0，0，0.4),可以设置此backgroundView的属性
 */
@property (nullable, nonatomic, strong, readonly) UIView *backgroundView;

@property (nonatomic, assign) HYPopViewAnimationType animationType;

@property (weak, nonatomic) id<HYImageAndButtonViewDelegate> delegate;

@property (assign, nonatomic) CGPoint offset;

/**
 * 隐藏了就从父视图移除，默认是YES
 */
@property (assign, nonatomic) BOOL removeFromSuperViewOnHide;

- (nonnull instancetype)initWithView:(nonnull UIView *)view;


- (nonnull instancetype)initWithCustomView:(nullable UIView *)customView buttonsArray:(nullable NSArray<__kindof UIButton *> *)buttonsArray;

+ (nonnull instancetype)showHUDAddedTo:(nullable UIView *)view animated:(BOOL)animated;

- (void)showAnimated:(BOOL)animated;

- (void)hideAnimated:(BOOL)animated;


@end
