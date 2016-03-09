//
//  HYBackgroundView.h
//  HudDemo
//
//  Created by MrZhangKe on 16/3/9.
//  Copyright © 2016年 Matej Bukovinski. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HYBackgroundStyle) {
    /// Solid color background
    HYBackgroundStyleSolidColor,
    /// UIVisualEffectView or UIToolbar.layer background view
    HYBackgroundStyleBlur
};

@interface HYBackgroundView : UIView

@property (nonatomic) HYBackgroundStyle style;

/**
 * The background color or the blur tint color.
 * @note Due to iOS 7 not supporting UIVisualEffectView the blur effect differs slightly between iOS 7 and later versions.
 */
@property (nonatomic, strong) UIColor *color;

@end
