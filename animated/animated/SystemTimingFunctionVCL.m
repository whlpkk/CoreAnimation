//
//  SystemTimingFunctionVCL.m
//  animated
//
//  Created by YaoZhiKun on 2016/12/12.
//  Copyright © 2016年 YaoZhiKun. All rights reserved.
//


/*
 系统缓冲函数：
 kCAMediaTimingFunctionLinear            匀速
 kCAMediaTimingFunctionEaseIn            先慢后快
 kCAMediaTimingFunctionEaseOut           先快后慢
 kCAMediaTimingFunctionEaseInEaseOut     先慢中间快后慢
 
 自定义缓冲函数：
 + (instancetype)functionWithControlPoints:(float)c1x :(float)c1y :(float)c2x :(float)c2y
     自定义缓冲函数，三次贝塞尔曲线，初始点为(0,0)，结束点位(1,1),第一个控制点是(c1x,c1y)，第二个控制点是(c2x,c2y)
 eg:CAMediaTimingFunction *function = [CAMediaTimingFunction functionWithControlPoints:0 :0.75 :1 :0];
     控制点分别为(0,0.75)，(1,0)
 */


#import "SystemTimingFunctionVCL.h"

@interface SystemTimingFunctionVCL () <CAAnimationDelegate>
@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UIButton *startButton;
@property (nonatomic, weak) IBOutlet UIView *layerView;

@property (nonatomic, strong) CALayer *shipLayer1;
@property (nonatomic, strong) CALayer *shipLayer2;
@property (nonatomic, strong) CALayer *shipLayer3;
@property (nonatomic, strong) CALayer *shipLayer4;
@end

@implementation SystemTimingFunctionVCL

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    {
        self.shipLayer1 = [CALayer layer];
        self.shipLayer1.frame = CGRectMake(0, 0, 32, 32);
        self.shipLayer1.position = CGPointMake(20, 50);
        self.shipLayer1.contents = (__bridge id)[UIImage imageNamed:@"alarm_on_64.png"].CGImage;
        [self.containerView.layer addSublayer:self.shipLayer1];
    }
    {
        self.shipLayer2 = [CALayer layer];
        self.shipLayer2.frame = CGRectMake(0, 0, 32, 32);
        self.shipLayer2.position = CGPointMake(20, 140);
        self.shipLayer2.contents = (__bridge id)[UIImage imageNamed:@"alarm_on_64.png"].CGImage;
        [self.containerView.layer addSublayer:self.shipLayer2];
    }
    {
        self.shipLayer3 = [CALayer layer];
        self.shipLayer3.frame = CGRectMake(0, 0, 32, 32);
        self.shipLayer3.position = CGPointMake(20, 230);
        self.shipLayer3.contents = (__bridge id)[UIImage imageNamed:@"alarm_on_64.png"].CGImage;
        [self.containerView.layer addSublayer:self.shipLayer3];
    }
    {
        self.shipLayer4 = [CALayer layer];
        self.shipLayer4.frame = CGRectMake(0, 0, 32, 32);
        self.shipLayer4.position = CGPointMake(20, 320);
        self.shipLayer4.contents = (__bridge id)[UIImage imageNamed:@"alarm_on_64.png"].CGImage;
        [self.containerView.layer addSublayer:self.shipLayer4];
    }
    
    //create timing function
    NSInteger i=0;
    NSArray *colors = @[[UIColor redColor],[UIColor blueColor],[UIColor orangeColor],[UIColor purpleColor]];
    for (NSString *functionName in @[kCAMediaTimingFunctionLinear,kCAMediaTimingFunctionEaseIn,kCAMediaTimingFunctionEaseOut,kCAMediaTimingFunctionEaseInEaseOut]) {
        CAMediaTimingFunction *function = [CAMediaTimingFunction functionWithName: functionName];
        //get control points
        float controlPoint1[2]={0,0},controlPoint2[2]={0,0};
        [function getControlPointAtIndex:1 values:controlPoint1];
        [function getControlPointAtIndex:2 values:controlPoint2];
        
        //create curve
        UIBezierPath *path = [[UIBezierPath alloc] init];
        [path moveToPoint:CGPointZero];
        [path addCurveToPoint:CGPointMake(1, 1)
                controlPoint1:CGPointMake(controlPoint1[0], controlPoint1[1])
                controlPoint2:CGPointMake(controlPoint2[0], controlPoint2[1])];
        
        //scale the path up to a reasonable size for display
        [path applyTransform:CGAffineTransformMakeScale(253, 253)];
        
        //create shape layer
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
        shapeLayer.strokeColor = ((UIColor *)colors[i]).CGColor;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.lineWidth = 2.0f;
        shapeLayer.path = path.CGPath;
        [self.layerView.layer addSublayer:shapeLayer];
        
        //flip geometry so that 0,0 is in the bottom-left
        self.layerView.layer.geometryFlipped = YES;
        i++;
    }
    self.layerView.layer.borderWidth = 1.0;
}


- (IBAction)start
{
    //disable controls
    [self setControlsEnabled:NO];
    
    for (int i=0; i<4; i++) {
        CABasicAnimation *animation = [CABasicAnimation animation];
        animation.keyPath = @"position.x";
        animation.duration = 10;
        animation.repeatCount = 1;
        animation.byValue = @(300);
        animation.delegate = self;
        
        if (i==0) {
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            [self.shipLayer1 addAnimation:animation forKey:@"rotateAnimation"];
        }else if (i==1) {
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            [self.shipLayer2 addAnimation:animation forKey:@"rotateAnimation"];
        }else if (i==2) {
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            [self.shipLayer3 addAnimation:animation forKey:@"rotateAnimation"];
        }else if (i==3) {
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [self.shipLayer4 addAnimation:animation forKey:@"rotateAnimation"];
        }
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //reenable controls
    [self setControlsEnabled:YES];
}

- (void)setControlsEnabled:(BOOL)enabled
{
    for (UIControl *control in @[self.startButton]) {
        control.enabled = enabled;
        control.alpha = enabled? 1.0f: 0.25f;
    }
}

@end
