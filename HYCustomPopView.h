//
//  HYCustomPopView.h
//  HudDemo
//
//  Created by MrZhangKe on 16/3/8.
//  Copyright © 2016年 Matej Bukovinski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYCustomPopView : UIView

@property (nonatomic, strong) NSArray *buttonNamesArray;

@property (nonatomic, strong) UIView *customView;

@property (nonatomic, strong) UIColor *buttonBackgroundColor;

@property (nonatomic, strong) UIColor *buttonTextColor;

@property (nonatomic, assign) CGFloat margin;

- (instancetype)initWithView:(UIView *)view;


- (instancetype)initWithCustomView:(UIView *)view buttonNamesArray:(NSArray<__kindof NSString *> *)buttonNamesArray aboveView:(UIView *)view;


- (void)show;


@end
