//
//  HYPopView.m
//  Example
//
//  Created by kingstar on 16/3/14.
//  Copyright © 2016年 xjimi. All rights reserved.
//

#import "HYPopView.h"

@interface HYPopView ()
@property (nonatomic, weak) UIView *baseView;
@end

@implementation HYPopView

- (id)initWithView:(UIView *)view
{
    self = [super init];
    if (self)
    {
        self.baseView = view;
    }
    return self;
}

- (void)createHUD
{
    if (!self.HUD)
    {
        self.HUD = [[MBProgressHUD alloc] initWithView:self.baseView];
        self.HUD.mode = MBProgressHUDModeText;
        self.HUD.delegate = self;
        [self.baseView addSubview:self.HUD];
    }
}


//显示文字

- (void)showMessage:(NSString *)message
{
    [self showMessage:message duration:-1];
}

- (void)showMessage:(NSString *)message duration:(NSTimeInterval)duration
{
    [self showMessage:message duration:duration complection:nil];
}

- (void)showMessage:(NSString *)message duration:(NSTimeInterval)duration complection:(void (^)())completion
{
    [self showMessage:message mode:MBProgressHUDModeText duration:duration complection:completion];
}

//显示小菊花

- (void)showIndeterminateWithMessage:(NSString *)message
{
    [self showIndeterminateWithMessage:message duration:-1];
}

- (void)showIndeterminateWithMessage:(NSString *)message duration:(NSTimeInterval)duration
{
    [self showIndeterminateWithMessage:message duration:duration complection:nil];
}

- (void)showIndeterminateWithMessage:(NSString *)message duration:(NSTimeInterval)duration complection:(void (^)())completion
{
    [self showMessage:message mode:MBProgressHUDModeIndeterminate duration:duration complection:completion];
}

//显示成功

- (void)showSuccessWithMessage:(NSString *)message
{
    [self showSuccessWithMessage:message duration:1];
}

- (void)showSuccessWithMessage:(NSString *)message duration:(NSTimeInterval)duration
{
    [self showSuccessWithMessage:message duration:duration complection:nil];
}

- (void)showSuccessWithMessage:(NSString *)message duration:(NSTimeInterval)duration complection:(void (^)())completion
{
    UIImageView *customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    [self showMessage:message customView:customView duration:duration complection:completion];
}

//显示错误

- (void)showErrorWithMessage:(NSString *)message
{
    [self showSuccessWithMessage:message duration:1];
}

- (void)showErrorWithMessage:(NSString *)message duration:(NSTimeInterval)duration
{
    [self showErrorWithMessage:message duration:duration complection:nil];
}

- (void)showErrorWithMessage:(NSString *)message duration:(NSTimeInterval)duration complection:(void (^)())completion
{
    UIImageView *customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Error.png"]];
    [self showMessage:message customView:customView duration:duration complection:completion];
}

//自定义视图

- (void)showMessage:(NSString *)message customView:(UIView *)customView
{
    [self showMessage:message customView:customView duration:-1 complection:nil];
}

- (void)showMessage:(NSString *)message customView:(UIView *)customView duration:(NSTimeInterval)duration
{
    [self showMessage:message customView:customView duration:duration complection:nil];
}

- (void)showMessage:(NSString *)message customView:(UIView *)customView duration:(NSTimeInterval)duration complection:(MBProgressHUDCompletionBlock)completion
{
    [self createHUD];
    
    self.HUD.customView = customView;
    [self showMessage:message mode:MBProgressHUDModeCustomView duration:duration complection:completion];
}

//自定义模式

- (void)showMessage:(NSString *)message mode:(MBProgressHUDMode)mode
{
    [self showMessage:message mode:mode duration:-1 complection:nil];
}

- (void)showMessage:(NSString *)message mode:(MBProgressHUDMode)mode duration:(NSTimeInterval)duration
{
    [self showMessage:message mode:mode duration:duration complection:nil];
}

- (void)showMessage:(NSString *)message mode:(MBProgressHUDMode)mode duration:(NSTimeInterval)duration complection:(void (^)())completion
{
    [self createHUD];
    self.HUD.mode = mode;
    self.HUD.label.text = message;
    [self.HUD showAnimated:YES];
    if (completion)
    {
        [self hideWithAfterDuration:duration completion:completion];
        
    }
    else
    {
        self.completionBlock = NULL;
        if (duration >= 0)
            [self.HUD hideAnimated:YES afterDelay:duration];
    }
}

//显示进度

- (void)showProgress:(float)progress
{
    if (self.HUD)
        self.HUD.progress = progress;
}

//隐藏

- (void)hide
{
    if (self.HUD)
        [self.HUD hideAnimated:YES];
    if (self.imageAndButtonView)
        [self.imageAndButtonView hideAnimated:YES];
}

- (void)hideWithAfterDuration:(NSTimeInterval)duration completion:(MBProgressHUDCompletionBlock)completion
{
    self.completionBlock = completion;
    if (!self.HUD)
    {
        if (self.completionBlock) {
            self.completionBlock();
            self.completionBlock = NULL;
        }
        return;
    }
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [self.HUD showAnimated:YES whileExecutingBlock:^{
        
        sleep(duration);
        
    } completionBlock:^{
        
    }];
    
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    self.HUD.delegate = nil;
    [self.HUD removeFromSuperview];
    self.HUD = nil;
    
    if (self.completionBlock) {
        self.completionBlock();
    }
}


- (void)showCustomView:(UIView *)customView andButtons:(NSArray<__kindof UIButton *> *)buttonsArray{
    if (!self.imageAndButtonView) {
        self.imageAndButtonView = [HYImageAndButtonView showHUDAddedTo:self.baseView animated:YES];
        self.imageAndButtonView.buttonsArray = buttonsArray;
        self.imageAndButtonView.customView = customView;
    }    
}

@end
