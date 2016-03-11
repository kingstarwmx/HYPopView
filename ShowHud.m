//
//  ShowHud.m
//  HudDemo
//
//  Created by MrZhangKe on 16/3/11.
//  Copyright © 2016年 Matej Bukovinski. All rights reserved.
//

#import "ShowHud.h"

#ifdef DEBUG
#define ShowHud_DLog(fmt, ...) NSLog((@"ShowHud.m:%s:%d" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define ShowHud_DLog(...)
#endif

@interface ShowHud ()<MBProgressHUDDelegate>

{
    MBProgressHUD   *_hud;
}

@end


@implementation ShowHud

- (instancetype)initWithView:(UIView *)view
{
    if (view == nil) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        _hud = [[MBProgressHUD alloc] initWithView:view];
        _hud.delegate                  = self;                       // 设置代理
        _hud.animationType             = MBProgressHUDAnimationZoom; // 默认动画样式
        _hud.removeFromSuperViewOnHide = YES;                        // 该视图隐藏后则自动从父视图移除掉
        
        [view addSubview:_hud];
    }
    return self;
}

- (void)hide:(BOOL)hide afterDelay:(NSTimeInterval)delay
{
    [_hud hideAnimated:hide afterDelay:delay];
}

- (void)hide
{
    [_hud hideAnimated:YES];
}

- (void)show:(BOOL)show
{
    // 根据属性判断是否要显示文本
    if (_text != nil && _text.length != 0) {
        _hud.label.text = _text;
    }
    
    // 设置文本字体
    if (_textFont) {
        _hud.label.font = _textFont;
    }
    
    // 如果设置这个属性,则只显示文本
    if (_showTextOnly == YES && _text != nil && _text.length != 0) {
        _hud.mode = MBProgressHUDModeText;
    }
    
    // 设置背景色
    if (_backgroundColor) {
        _hud.bezelView.backgroundColor = _backgroundColor;
    }
    
    // 文本颜色
    if (_labelColor) {
        _hud.label.textColor = _labelColor;
    }
    
    // 设置圆角
    if (_cornerRadius) {
        _hud.bezelView.layer.cornerRadius = _cornerRadius;
    }
    
    // 设置透明度
    if (_opacity) {
        _hud.bezelView.alpha = _opacity;
    }
    
    // 自定义view
    if (_customView) {
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = _customView;
    }
    
    // 边缘留白
    if (_margin > 0) {
        _hud.margin = _margin;
    }
    
    [_hud showAnimated:show];
}

#pragma mark - HUD代理方法
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [_hud removeFromSuperview];
    _hud = nil;
}

#pragma mark - 重写setter方法

- (void)setAnimationStyle:(HYPopViewAnimationTypeWMX)animateStyle
{
    _animateStyle    = animateStyle;
    
    _hud.animationType = (MBProgressHUDAnimation)_animateStyle;
}

- (HYPopViewAnimationTypeWMX)animationStyle
{
    return _animateStyle;
}

#pragma mark - 便利的方法
+ (void)showTextOnly:(NSString *)text
     configParameter:(ConfigShowHudBlock)config
            duration:(NSTimeInterval)sec
              inView:(UIView *)view
{
    ShowHud *hud     = [[ShowHud alloc] initWithView:view];
    hud.text         = text;
    hud.showTextOnly = YES;
    hud.margin       = 10.f;
    
    // 配置额外的参数
    config(hud);
    
    // 显示
    [hud show:YES];
    
    // 延迟sec后消失
    [hud hide:YES afterDelay:sec];
}

+ (void)showText:(NSString *)text
 configParameter:(ConfigShowHudBlock)config
        duration:(NSTimeInterval)sec
          inView:(UIView *)view
{
    ShowHud *hud     = [[ShowHud alloc] initWithView:view];
    hud.text         = text;
    hud.margin       = 10.f;
    
    // 配置额外的参数
    config(hud);
    
    // 显示
    [hud show:YES];
    
    // 延迟sec后消失
    [hud hide:YES afterDelay:sec];
}


+ (void)showCustomView:(ConfigShowHudCustomViewBlock)viewBlock
       configParameter:(ConfigShowHudBlock)config
              duration:(NSTimeInterval)sec
                inView:(UIView *)view
{
    ShowHud *hud     = [[ShowHud alloc] initWithView:view];
    hud.margin       = 10.f;
    
    // 配置额外的参数
    config(hud);
    
    // 自定义View
    hud.customView   = viewBlock();
    
    // 显示
    [hud show:YES];
    
    [hud hide:YES afterDelay:sec];
}


+ (instancetype)showTextOnly:(NSString *)text
             configParameter:(ConfigShowHudBlock)config
                      inView:(UIView *)view
{
    ShowHud *hud     = [[ShowHud alloc] initWithView:view];
    hud.text         = text;
    hud.showTextOnly = YES;
    hud.margin       = 10.f;
    
    // 配置额外的参数
    config(hud);
    
    // 显示
    [hud show:YES];
    
    return hud;
}

+ (instancetype)showText:(NSString *)text
         configParameter:(ConfigShowHudBlock)config
                  inView:(UIView *)view
{
    ShowHud *hud     = [[ShowHud alloc] initWithView:view];
    hud.text         = text;
    hud.margin       = 10.f;
    
    // 配置额外的参数
    config(hud);
    
    // 显示
    [hud show:YES];
    
    return hud;
}

+ (instancetype)showCustomView:(ConfigShowHudCustomViewBlock)viewBlock
               configParameter:(ConfigShowHudBlock)config
                        inView:(UIView *)view
{
    ShowHud *hud     = [[ShowHud alloc] initWithView:view];
    hud.margin       = 10.f;
    
    // 配置额外的参数
    config(hud);
    
    // 自定义View
    hud.customView   = viewBlock();
    
    // 显示
    [hud show:YES];
    
    return hud;
}

- (void)dealloc
{
    ShowHud_DLog(@"资源释放了,没有泄露^_^");
}


@end
