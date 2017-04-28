//
//  SpeedViewController.m
//  animated
//
//  Created by YaoZhiKun on 2016/11/24.
//  Copyright © 2016年 YaoZhiKun. All rights reserved.
//

#import "SpeedViewController.h"


/*
 beginTime:  动画经过多长时间后开始，即延时多久开始。不影响duration，不受speed影响。
             这里的时间是相对时间，单位是秒。eg:延时t秒，表达式为 CACurrentMediaTime()+t 。
 timeOffset: 动画开始的偏移量，即动画从fromValue+t秒后的位置开始，不影响duration，不受speed影响。
             注意和beginTime的区别，这里的时间是绝对时间，单位是秒。
 speed:      动画的速度，默认是1。如果设置为2，则一个duration=2的动画，会在1秒内执行完。
             如果设置为0，则动画不会动。
 */

/*
 fillMode:   
 
 对于beginTime非0的一段动画来说，会出现一个当动画添加到图层上但什么也没发生的状态。类似的，removeOnCompletion被设置为NO的动画将会在动画结束的时候仍然保持之前的状态。这就产生了一个问题，当动画开始之前和动画结束之后，被设置动画的属性将会是什么值呢？
 1). 一种可能是属性和动画没被添加之前保持一致，也就是在模型图层定义的值。
 2). 另一种可能是保持动画开始之前那一帧，或者动画结束之后的那一帧。这就是所谓的填充，因为动画开始和结束的值用来填充开始之前和结束之后的时间。
 这种行为就交给开发者了，它可以被CAMediaTiming的fillMode来控制。fillMode是一个NSString类型，可以接受如下四种常量：
 kCAFillModeForwards  //向后填充动画状态，removeOnCompletion被设置为NO的动画将会在动画结束的时候仍然保持之前的状态。
 kCAFillModeBackwards //向前填充动画状态，即对于beginTime非0的一段动画来说，会立即变成动画将要执行的样子。
 kCAFillModeBoth      //即向前又向后去填充动画状态
 kCAFillModeRemoved   //默认为此值。 不填充，当动画不再播放的时候就显示图层模型指定的值
 默认是kCAFillModeRemoved，当动画不再播放的时候就显示图层模型指定的值剩下的三种类型向前，向后或者即向前又向后去填充动画状态，使得动画在开始前或者结束后仍然保持开始和结束那一刻的值。
 但是记住了，当用它来解决这个问题的时候，需要把removeOnCompletion设置为NO，另外需要给动画添加一个非空的键，于是可以在不需要动画的时候把它从图层上移除。
*/

@interface SpeedViewController ()

@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UILabel *speedLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeOffsetLabel;
@property (nonatomic, weak) IBOutlet UILabel *beginTimeLabel;
@property (nonatomic, weak) IBOutlet UISlider *speedSlider;
@property (nonatomic, weak) IBOutlet UISlider *timeOffsetSlider;
@property (nonatomic, weak) IBOutlet UISlider *beginTimeSlider;
@property (nonatomic, strong) UIBezierPath *bezierPath;
@property (nonatomic, strong) CALayer *shipLayer;

@end

@implementation SpeedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    //create a path
    self.bezierPath = [[UIBezierPath alloc] init];
    [self.bezierPath moveToPoint:CGPointMake(0, 150)];
    [self.bezierPath addCurveToPoint:CGPointMake(300, 150) controlPoint1:CGPointMake(75, 0) controlPoint2:CGPointMake(225, 300)];
    
    //draw the path using a CAShapeLayer
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = self.bezierPath.CGPath;
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.strokeColor = [UIColor redColor].CGColor;
    pathLayer.lineWidth = 3.0f;
    [self.containerView.layer addSublayer:pathLayer];
    
    //add the ship
    self.shipLayer = [CALayer layer];
    self.shipLayer.frame = CGRectMake(0, 0, 64, 64);
    self.shipLayer.position = CGPointMake(0, 150);
    self.shipLayer.contents = (__bridge id)[UIImage imageNamed: @"alarm_on_64.png"].CGImage;
    [self.containerView.layer addSublayer:self.shipLayer];
    
    //set initial values
    [self updateSliders];
}

- (IBAction)updateSliders
{
    CFTimeInterval timeOffset = self.timeOffsetSlider.value;
    self.timeOffsetLabel.text = [NSString stringWithFormat:@"%0.2f", timeOffset];
    float speed = self.speedSlider.value;
    self.speedLabel.text = [NSString stringWithFormat:@"%0.2f", speed];
    float beginTime = self.beginTimeSlider.value;
    self.beginTimeLabel.text = [NSString stringWithFormat:@"%0.2f", beginTime];
}

- (IBAction)play
{
    //create the keyframe animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.path = self.bezierPath.CGPath;
    animation.keyPath = @"position";
    animation.timeOffset = self.timeOffsetSlider.value;
    animation.speed = self.speedSlider.value;
    animation.beginTime = CACurrentMediaTime()+self.beginTimeSlider.value;
    animation.duration = 2.0;
    animation.fillMode = kCAFillModeBackwards;
    //fillMode如果要生效，必须 removedOnCompletion 设置成NO。否则动画被移除，则不起作用。
    animation.removedOnCompletion = NO;
    [self.shipLayer addAnimation:animation forKey:@"slide"];
}

- (IBAction)stop
{
    [self.shipLayer removeAnimationForKey:@"slide"];
}

@end
