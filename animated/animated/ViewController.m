//
//  ViewController.m
//  animated
//
//  Created by YaoZhiKun on 2016/11/15.
//  Copyright © 2016年 YaoZhiKun. All rights reserved.
//

#import "ViewController.h"
#import "DurationTimeViewController.h"
#import "PresentationLayerVCL.h"
#import "SpeedViewController.h"

@interface ViewController ()

@property (nonatomic, strong) CALayer *colorLayer;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (IBAction)presentationLayerClicked:(id)sender {
    PresentationLayerVCL *vc = [[PresentationLayerVCL alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)timeLayerClicked:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:[NSBundle mainBundle]];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DurationTimeViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)speedLayerClicked:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:[NSBundle mainBundle]];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SpeedViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)systemTimingFuctionClicked:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:[NSBundle mainBundle]];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SystemTimingFunctionVCL"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)customTimingFuctionClicked:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:[NSBundle mainBundle]];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"CustomTimingFunctionVCL"];
    [self.navigationController pushViewController:vc animated:YES];
}




@end
