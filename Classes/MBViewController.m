//
//  MBViewController.m
//  HudDemo
//
//  Created by kingstar on 16/3/9.
//  Copyright © 2016年 Matej Bukovinski. All rights reserved.
//

#import "MBViewController.h"
#import "HYCustomPopView.h"

@interface MBViewController ()

@end

@implementation MBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IMG_0504"]];
    NSArray *array = @[@"了解更多", @"我知道了"];
    HYCustomPopView *hyView = [[HYCustomPopView alloc] initWithCustomView:imageView buttonNamesArray:array aboveView:self.view];
//    hyView.frame = CGRectMake(200, 200, 100, 100);
//    [self.view addSubview:hyView];
    [hyView show];
    
//    UIWindow *keyWindow = [[UIApplication sharedApplication].delegate window];
//    keyWindow.backgroundColor = [UIColor redColor];
    self.view.backgroundColor = [UIColor grayColor];
}



@end
