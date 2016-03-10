//
//  HYRoundProgressView.h
//  HudDemo
//
//  Created by MrZhangKe on 16/3/10.
//  Copyright © 2016年 Matej Bukovinski. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * A progress view for showing definite progress by filling up a circle (pie chart).
 */
@interface HYRoundProgressView : UIView


/**
 * Progress (0.0 to 1.0)
 */
@property (nonatomic, assign) float progress;

/**
 * Indicator progress color.
 * Defaults to white [UIColor whiteColor]
 */
@property (nonatomic, strong) UIColor *progressTintColor;

/**
 * Indicator background (non-progress) color.
 * Only applicable on iOS version older than iOS 7.
 * Defaults to translucent white (alpha 0.1)
 */
@property (nonatomic, strong) UIColor *backgroundTintColor;

/*
 * Display mode - NO = round or YES = annular. De+faults to round.
 */
@property (nonatomic, assign, getter = isAnnular) BOOL annular;

@end
