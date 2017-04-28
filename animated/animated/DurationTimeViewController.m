//
//  TimeViewController.m
//  animated
//
//  Created by YaoZhiKun on 2016/11/23.
//  Copyright © 2016年 YaoZhiKun. All rights reserved.
//

#import "DurationTimeViewController.h"


/*
 duration:       一次动画的周期。
 autoreverses:   是否自动回放。
 repeatCount:    重复次数。
 
 上面3个参数互不影响， 例如 duration:3,autoreverses:YES,repeatCount:2，则这个动画一个周期是3秒。因为自动回放，又3秒。
     然后重复2此，所以又6秒(3秒正常，3秒回放)。所以动画总时长为 3(duration) * 2(autoreverses) * 2(repeatCount)
 */


@interface DurationTimeViewController () <CAAnimationDelegate>

@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UITextField *durationField;
@property (nonatomic, weak) IBOutlet UITextField *repeatField;
@property (nonatomic, weak) IBOutlet UIButton *startButton;
@property (nonatomic, strong) CALayer *shipLayer;

@end

@implementation DurationTimeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    //add the ship
    self.shipLayer = [CALayer layer];
    self.shipLayer.frame = CGRectMake(0, 0, 128, 128);
    self.shipLayer.position = CGPointMake(150, 150);
    self.shipLayer.contents = (__bridge id)[UIImage imageNamed:@"alarm_on_64.png"].CGImage;
    [self.containerView.layer addSublayer:self.shipLayer];
}

- (IBAction)hideKeyboard
{
    [self.durationField resignFirstResponder];
    [self.repeatField resignFirstResponder];
}

- (IBAction)start
{
    CFTimeInterval duration = [self.durationField.text doubleValue];
    float repeatCount = [self.repeatField.text floatValue];
    //animate the ship rotation
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation";
    animation.duration = duration;
    animation.repeatCount = repeatCount;
    animation.byValue = @(M_PI * 2);
    animation.delegate = self;
    animation.autoreverses = YES;
    [self.shipLayer addAnimation:animation forKey:@"rotateAnimation"];
    //disable controls
    [self setControlsEnabled:NO];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //reenable controls
    [self setControlsEnabled:YES];
}

- (void)setControlsEnabled:(BOOL)enabled
{
    for (UIControl *control in @[self.durationField, self.repeatField, self.startButton]) {
        control.enabled = enabled;
        control.alpha = enabled? 1.0f: 0.25f;
    }
}

@end
