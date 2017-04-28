//
//  PresentationLayerVCL.m
//  animated
//
//  Created by YaoZhiKun on 2016/11/23.
//  Copyright © 2016年 YaoZhiKun. All rights reserved.
//

#import "PresentationLayerVCL.h"

/*
 presentationLayer:
     每个图层属性的显示值都被存储在一个叫做呈现图层的独立图层当中，他可以通过-presentationLayer方法来访问。
     这个呈现图层实际上是模型图层的复制，但是它的属性值代表了在任何指定时刻当前外观效果。
     换句话说，你可以通过呈现图层的值来获取当前屏幕上真正显示出来的值。
     注意呈现图层仅仅当图层首次被提交（就是首次第一次在屏幕上显示）的时候创建，所以在那之前调用-presentationLayer将会返回nil。
 
 modelLayer:
     在呈现图层上调用–modelLayer将会返回它正在呈现所依赖的CALayer。
     通常在一个图层上调用-modelLayer会返回–self（实际上我们已经创建的原始图层就是一种数据模型）。
 
 self.colorLayer.presentationLayer.modelLayer == self.colorLayer == self.colorLayer.modelLayer
 */


@interface PresentationLayerVCL ()

@property (nonatomic, strong) CALayer *colorLayer;

@end

@implementation PresentationLayerVCL

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(0, 0, 100, 100);
    self.colorLayer.position = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
    self.colorLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:self.colorLayer];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //get the touch point
    CGPoint point = [[touches anyObject] locationInView:self.view];
    //check if we've tapped the moving layer
    
    NSLog(@"\n%@\n%@\n%@\n%@\n",self.colorLayer,self.colorLayer.presentationLayer,self.colorLayer.modelLayer,self.colorLayer.presentationLayer.modelLayer);
    
    //注意下面这两种写法的差别
    if ([self.colorLayer.presentationLayer hitTest:point]) {
        //    if ([self.colorLayer hitTest:point]) {
        //randomize the layer background color
        CGFloat red = arc4random() % 256 /255.0;
        CGFloat green = arc4random() % 256 /255.0;
        CGFloat blue = arc4random() % 256 /255.0;
        self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    } else {
        //otherwise (slowly) move the layer to new position
        [CATransaction begin];
        [CATransaction setAnimationDuration:4.0];
        self.colorLayer.position = point;
        [CATransaction commit];
    }
}

@end
