//
//  MBViewController.m
//  HudDemo
//
//  Created by kingstar on 16/3/9.
//  Copyright © 2016年 Matej Bukovinski. All rights reserved.
//

#import "MBViewController.h"
//#import "HYPopView.h"
#import "HYWithButtonView.h"
#import "ShowHud.h"
#import "HYImageAndButtonView.h"
#import "HYPopView.h"

@interface MBViewController ()
@property (nonatomic, assign) BOOL canceled;
@property (nonatomic, strong) HYPopView *hyView;
@end

@implementation MBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor grayColor];
    
    HYPopView *hyView = [[HYPopView alloc] initWithView:self.view];
    self.hyView = hyView;
}

//- (void)hudWasHidden:(HYPopView *)hud{
//    [hud removeFromSuperview];
//    hud = nil;
//}

- (IBAction)btnClicked:(UIButton *)sender {
    
    
    
    //[self setCustom];
    
    //[self setButtonAndCustomView];
//    [self.hyVi];
}


- (void)setButtonAndCustomView{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IMG_0504"]];
    
    //创建按钮
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"我知道了" forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    btn1.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn2 setTitle:@"了解更多" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn3 setTitle:@"谢谢再见" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn3.backgroundColor = [UIColor whiteColor];
    
    NSArray *buttonsArray = @[btn1, btn2, btn3];
    
    
//    HYPopView *hyView = [[HYPopView alloc] initWithCustomView:imageView buttonsArray:buttonsArray];
//    hyView.mode = HYPopViewModePictureAndButton;
//    [self.view addSubview:hyView];
//    [hyView showAnimated:YES];
    
    
//    HYImageAndButtonView *hyView = [HYImageAndButtonView showHUDAddedTo:self.view animated:YES];
//    hyView.buttonsArray = buttonsArray;
//    hyView.customView = imageView;
    
    [self.hyView showCustomView:imageView andButtons:buttonsArray];
//    hyView.backgroundView.backgroundColor = [UIColor greenColor];
//    hyView.delegate = self;
    
    

}

//- (void)setAnnular{
//    HYPopView *hyView = [HYPopView showHUDAddedTo:self.view animated:YES];
//    hyView.mode = HYPopViewModeAnnularDeterminate;
//    hyView.labelText = @"ABCD";
//    hyView.contentColor = [UIColor whiteColor];
//    
//    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
//        // Do something useful in the background and update the HUD periodically.
//        [self doSomeWorkWithProgress];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [hyView hideAnimated:YES];
//        });
//    });
//}

- (IBAction)cancelBtnClicked:(UIButton *)sender {
    
    NSLog(@"------");
    [self.hyView hide];
}



@end
