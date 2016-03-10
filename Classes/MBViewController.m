//
//  MBViewController.m
//  HudDemo
//
//  Created by kingstar on 16/3/9.
//  Copyright © 2016年 Matej Bukovinski. All rights reserved.
//

#import "MBViewController.h"
#import "HYPopView.h"

@interface MBViewController ()
@property (nonatomic, strong) HYPopView *hyView;
@end

@implementation MBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor grayColor];
    
    
    
}

- (IBAction)btnClicked:(UIButton *)sender {
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IMG_0504"]];
    
    //创建按钮
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"我知道了" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setTitle:@"了解更多" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    
    NSArray *buttonsArray = @[btn1, btn2];
    
    
//    self.hyView = [[HYPopView alloc] initWithCustomView:imageView buttonsArray:buttonsArray];
//    
//    
//    [self.hyView showAboveView:self.view];
    
    self.hyView = [HYPopView showHUDAddedTo:self.view animated:YES];
    
    
}

- (IBAction)cancelBtnClicked:(UIButton *)sender {
    
    [self.hyView hideAnimated:YES];
}

@end
