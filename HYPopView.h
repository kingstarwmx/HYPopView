//
//  HYPopView.h
//  Example
//
//  Created by kingstar on 16/3/14.
//  Copyright © 2016年 xjimi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "HYImageAndButtonView.h"

typedef void (^MBProgressHUDManagerCompletionBlock)();

@interface HYPopView : NSObject<MBProgressHUDDelegate>

@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) HYImageAndButtonView *imageAndButtonView;

@property (copy) MBProgressHUDCompletionBlock completionBlock;

/**
 *  初始化方法
 *  @param view 要添加到的view
 */
- (id)initWithView:(UIView *)view;


/**
 *  显示一个文本,会一直显示，不会消失
 *  @param message 文本内容
 */
- (void)showMessage:(NSString *)message;
/**
 *  显示一个文本,一段时间后消失
 *  @param message 文本内容
 *  @param duration 显示的持续时间
 */
- (void)showMessage:(NSString *)message duration:(NSTimeInterval)duration;
/**
 *  显示一个文本,一段时间后消失
 *
 *  @param message    文本内容
 *  @param duration   显示的持续时间
 *  @param completion 显示完后的回调
 */
- (void)showMessage:(NSString *)message duration:(NSTimeInterval)duration complection:(MBProgressHUDCompletionBlock)completion;


/**
 *  显示内容上面是小菊花下面是文字
 */
- (void)showIndeterminateWithMessage:(NSString *)message;
- (void)showIndeterminateWithMessage:(NSString *)message duration:(NSTimeInterval)duration;
- (void)showIndeterminateWithMessage:(NSString *)message duration:(NSTimeInterval)duration complection:(MBProgressHUDCompletionBlock)completion;

/**
 *  显示内容上面是成功的符号下面是文字
 */
- (void)showSuccessWithMessage:(NSString *)message;
- (void)showSuccessWithMessage:(NSString *)message duration:(NSTimeInterval)duration;
- (void)showSuccessWithMessage:(NSString *)message duration:(NSTimeInterval)duration complection:(MBProgressHUDCompletionBlock)completion;

/**
 *  显示内容上面是错误的符号下面是文字
 */
- (void)showErrorWithMessage:(NSString *)message;
- (void)showErrorWithMessage:(NSString *)message duration:(NSTimeInterval)duration;
- (void)showErrorWithMessage:(NSString *)message duration:(NSTimeInterval)duration complection:(MBProgressHUDCompletionBlock)completion;

/**
 *  显示内容是自定义的视图
 *  @param message    一个文本
 *  @param customView 自定义传入一个UIView
 */
- (void)showMessage:(NSString *)message customView:(UIView *)customView;
- (void)showMessage:(NSString *)message customView:(UIView *)customView duration:(NSTimeInterval)duration;
- (void)showMessage:(NSString *)message customView:(UIView *)customView duration:(NSTimeInterval)duration complection:(MBProgressHUDCompletionBlock)completion;

/**
 *  自定义显示的模式
 *  @param message    一个文本
 *  @param mode
 /// 小菊花转动
 MBProgressHUDModeIndeterminate,
 /// 用来显示进度的环状指示图，由内外两层圆环构成
 MBProgressHUDModeDeterminate,
 /// 水平进度条
 MBProgressHUDModeDeterminateHorizontalBar,
 /// 用来显示进度的环状指示图，只有一个圆环构成
 MBProgressHUDModeAnnularDeterminate,
 /// 自定义显示的视图
 MBProgressHUDModeCustomView,
 /// 只显示文字
 MBProgressHUDModeText
 *  @param duration    持续时间
 */
- (void)showMessage:(NSString *)message mode:(MBProgressHUDMode)mode;
- (void)showMessage:(NSString *)message mode:(MBProgressHUDMode)mode duration:(NSTimeInterval)duration;
- (void)showMessage:(NSString *)message mode:(MBProgressHUDMode)mode duration:(NSTimeInterval)duration complection:(MBProgressHUDCompletionBlock)completion;

- (void)showProgress:(float)progress;


/**
 *  隐藏视图
 */
- (void)hide;


/**
 *  在一段时间后隐藏视图
 *
 *  @param duration   时间间隔
 *  @param completion 隐藏以后的回调
 */
- (void)hideWithAfterDuration:(NSTimeInterval)duration completion:(MBProgressHUDCompletionBlock)completion;


- (void)showCustomView:(UIView *)customView andButtons:(NSArray<__kindof UIButton *> *)buttonsArray;

@end
