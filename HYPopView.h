//
//  HYPopView.h
//  HudDemo
//
//  Created by MrZhangKe on 16/3/9.
//  Copyright © 2016年 Matej Bukovinski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBackgroundView.h"




@protocol HYPopViewDelegate;

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

//@property (nonatomic, strong) NSArray *buttonNamesArray;
@property (nonatomic, strong) NSArray *buttonsArray;

@property (nonatomic, strong) UIView *customView;

@property (nonatomic, strong) HYBackgroundView *backgroundView;//让背景变暗的视图,起到屏蔽作用跟突出前景作用

@property (nonatomic, assign) HYPopViewAnimationType animationType;


@property (nonatomic, assign) CGFloat margin;

/**
 *  在这个graceTime(宽限时间)之内如果点击相应了将不会弹出视图，默认是0
 */
@property (assign, nonatomic) NSTimeInterval graceTime;

@property (assign, nonatomic) NSTimeInterval minShowTime;

/**
 * Removes the HUD from its parent view when hidden.
 * Defaults to NO.
 */
@property (assign, nonatomic) BOOL removeFromSuperViewOnHide;

@property (weak, nonatomic) id<HYPopViewDelegate> delegate;

- (instancetype)initWithView:(UIView *)view;


- (instancetype)initWithCustomView:(UIView *)view buttonsArray:(NSArray<__kindof UIButton *> *)buttonsArray;


- (void)showAboveView:(UIView *)view;

- (void)hideAnimated:(BOOL)animated;

@end


@protocol HYPopViewDelegate <NSObject>

@optional

/**
 * Called after the HUD was fully hidden from the screen.
 */
- (void)hudWasHidden:(HYPopView *)hud;

@end
