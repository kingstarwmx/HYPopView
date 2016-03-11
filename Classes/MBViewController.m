//
//  MBViewController.m
//  HudDemo
//
//  Created by kingstar on 16/3/9.
//  Copyright © 2016年 Matej Bukovinski. All rights reserved.
//

#import "MBViewController.h"
#import "HYPopView.h"
#import "HYWithButtonView.h"

@interface MBViewController ()
@property (nonatomic, strong) HYPopView *hyView;
@property (nonatomic, assign) BOOL canceled;
@property (nonatomic, strong) HYWithButtonView *btnView;
@end

@implementation MBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor grayColor];
    
    
    
}

- (IBAction)btnClicked:(UIButton *)sender {
    
    
    
    //[self setCustom];
    
    [self setButtonAndCustomView];
    
}

- (void)setCustom{
    self.hyView = [HYPopView showHUDAddedTo:self.view animated:YES];
    self.hyView.mode = HYPopViewModeCustomView;
//    self.hyView.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_follow"]];
//    UIView *aview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    UIImageView *imagev = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_follow"]];
    self.hyView.customView = imagev;
    
}

- (void)setButtonAndCustomView{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IMG_0504"]];
    
    //创建按钮
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"我知道了" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    btn1.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setTitle:@"了解更多" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor whiteColor];
    
    NSArray *buttonsArray = @[btn1, btn2];
    
    
    HYPopView *hyView = [HYPopView showHUDAddedTo:self.view animated:YES];
    self.hyView = hyView;
    hyView.mode = HYPopViewModePictureAndButton;
    hyView.buttonsArray = buttonsArray;
    hyView.customView = imageView;
    
    
//    HYWithButtonView *btnView = [[HYWithButtonView alloc] initWithCustomView:imageView buttonsArray:buttonsArray];
//    btnView.center = self.view.center;
//    [self.view addSubview:btnView];
    
}

- (void)setAnnular{
    self.hyView = [HYPopView showHUDAddedTo:self.view animated:YES];
    self.hyView.mode = HYPopViewModeAnnularDeterminate;
    self.hyView.labelText = @"ABCD";
    self.hyView.contentColor = [UIColor whiteColor];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // Do something useful in the background and update the HUD periodically.
        [self doSomeWorkWithProgress];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.hyView hideAnimated:YES];
        });
    });
}

- (IBAction)cancelBtnClicked:(UIButton *)sender {
    
    [self.hyView hideAnimated:YES];
}

- (void)doSomeWorkWithProgress {
    self.canceled = NO;
    // This just increases the progress indicator in a loop.
    float progress = 0.0f;
    while (progress < 1.0f) {
        if (self.canceled) break;
        progress += 0.01f;
        dispatch_async(dispatch_get_main_queue(), ^{
            // Instead we could have also passed a reference to the HUD
            // to the HUD to myProgressTask as a method parameter.
            [HYPopView HUDForView:self.view].progress = progress;
        });
        usleep(50000);
    }
}

@end
