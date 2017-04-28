//
//  CustomTimingFunctionVCL.m
//  animated
//
//  Created by YaoZhiKun on 2016/12/27.
//  Copyright © 2016年 YaoZhiKun. All rights reserved.
//

/*
 https://zsisme.gitbooks.io/ios-/content/chapter10/custom-easing-functions.html
 这章原理比较复杂，这里不直接写，详情见网页
 */


#import "CustomTimingFunctionVCL.h"

@interface CustomTimingFunctionVCL () <CAAnimationDelegate>
@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, strong) UIImageView *ballView1;
@property (nonatomic, strong) UIImageView *ballView3;
@end

@implementation CustomTimingFunctionVCL

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *ballImage = [UIImage imageNamed:@"gear_64.png"];
    self.ballView1 = [[UIImageView alloc] initWithImage:ballImage];
    self.ballView1.center = CGPointMake(75, 32);
    [self.containerView addSubview:self.ballView1];
    
    self.ballView3 = [[UIImageView alloc] initWithImage:ballImage];
    self.ballView3.center = CGPointMake(225, 32);
    [self.containerView addSubview:self.ballView3];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //replay animation on tap
    [self animate];
    [self animate3];
}

- (IBAction)animate
{
    //reset ball to top of screen
    self.ballView1.center = CGPointMake(75, 32);
    //create keyframe animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 1.0;
    animation.delegate = self;
    animation.values = @[
                         [NSValue valueWithCGPoint:CGPointMake(75, 32)],
                         [NSValue valueWithCGPoint:CGPointMake(75, 268)],
                         [NSValue valueWithCGPoint:CGPointMake(75, 140)],
                         [NSValue valueWithCGPoint:CGPointMake(75, 268)],
                         [NSValue valueWithCGPoint:CGPointMake(75, 220)],
                         [NSValue valueWithCGPoint:CGPointMake(75, 268)],
                         [NSValue valueWithCGPoint:CGPointMake(75, 250)],
                         [NSValue valueWithCGPoint:CGPointMake(75, 268)]
                         ];
    
    animation.timingFunctions = @[
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn]
                                  ];
    
    animation.keyTimes = @[@0.0, @0.3, @0.5, @0.7, @0.8, @0.9, @0.95, @1.0];
    //apply animation
    self.ballView1.layer.position = CGPointMake(75, 268);
    [self.ballView1.layer addAnimation:animation forKey:nil];
}

#pragma mark - 第二种方法 用关键帧实现自定义的缓冲函数

float interpolate(float from, float to, float time)
{
    return (to - from) * time + from;
}

- (id)interpolateFromValue:(id)fromValue toValue:(id)toValue time:(float)time
{
    if ([fromValue isKindOfClass:[NSValue class]]) {
        //get type
        const char *type = [fromValue objCType];
        if (strcmp(type, @encode(CGPoint)) == 0) {
            CGPoint from = [fromValue CGPointValue];
            CGPoint to = [toValue CGPointValue];
            CGPoint result = CGPointMake(interpolate(from.x, to.x, time), interpolate(from.y, to.y, time));
            return [NSValue valueWithCGPoint:result];
        }
    }
    //provide safe default implementation
    return (time < 0.5)? fromValue: toValue;
}

float bounceEaseOut(float t)  //缓冲函数
{
    if (t < 4/11.0) {
        return (121 * t * t)/16.0;
    } else if (t < 8/11.0) {
        return (363/40.0 * t * t) - (99/10.0 * t) + 17/5.0;
    } else if (t < 9/10.0) {
        return (4356/361.0 * t * t) - (35442/1805.0 * t) + 16061/1805.0;
    }
    return (54/5.0 * t * t) - (513/25.0 * t) + 268/25.0;
}

- (IBAction)animate3
{
    //reset ball to top of screen
    self.ballView3.center = CGPointMake(225, 32);
    //set up animation parameters
    NSValue *fromValue = [NSValue valueWithCGPoint:CGPointMake(225, 32)];
    NSValue *toValue = [NSValue valueWithCGPoint:CGPointMake(225, 268)];
    CFTimeInterval duration = 1.0;
    //generate keyframes
    NSInteger numFrames = duration * 60;
    NSMutableArray *frames = [NSMutableArray array];
    for (int i = 0; i < numFrames; i++) {
        float time = 1 / (float)numFrames * i;
        time = bounceEaseOut(time); //重要
        [frames addObject:[self interpolateFromValue:fromValue toValue:toValue time:time]];
    }
    //create keyframe animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 1.0;
    animation.delegate = self;
    animation.values = frames;
    
    //apply animation
    self.ballView3.layer.position = CGPointMake(225, 268);
    [self.ballView3.layer addAnimation:animation forKey:nil];
}

@end
