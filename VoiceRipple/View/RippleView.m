//
//  RippleView.m
//  VoiceRipple
//
//  Created by 魏唯隆 on 2018/9/10.
//  Copyright © 2018年 魏唯隆. All rights reserved.
//

/**
 使用三角函数绘制波纹。
 三角函数公式： y = Asin（ωx+φ）+ C
 A：振幅，波纹在Y轴的高度，成正比，越大Y轴峰值越大。
 ω：和周期有关，越大周期越短。
 φ：横向偏移量，控制波纹的移动。
 C：整个波纹的Y轴偏移量。
 */

#define KRippleWidth self.bounds.size.width
#define KRippleHeight self.bounds.size.height

#import "RippleView.h"

static const float rippleCycle = 1/30.0f;   // 代表ω周期
static const float rippleYOffset = 100.0f;   // 代表C Y轴偏移量
static const float rippleSpeed = 0.3f; // 波纹相同时间平移的距离，表速度

@interface RippleView()

@property(nonatomic,weak)CAShapeLayer *rippleLayer; // 波纹
@property(nonatomic,weak)CADisplayLink *displayLink;    // 定时器
@property(nonatomic,assign)CGFloat rippleOffset;  // 控制平移

@end

@implementation RippleView

#pragma mark 波纹
- (CAShapeLayer *)rippleLayer{
    if (_rippleLayer == nil) {
        CAShapeLayer * shapeLayer = [CAShapeLayer layer];
        shapeLayer.fillColor = [UIColor colorWithRed:145/255.0f green:186/255.0f blue:248/255.0f alpha:1].CGColor;
        shapeLayer.lineWidth = 2.0f;
        shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:shapeLayer];
        _rippleLayer = shapeLayer;
    }
    return _rippleLayer;
}
#pragma mark 定时器
- (CADisplayLink *)displayLink{
    if (_displayLink == nil) {
        CADisplayLink * displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeRipple)];
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        _displayLink = displayLink;
    }
    return _displayLink;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self drawRippleLayer];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.rippleLayer.frame = self.bounds;
}

#pragma mark 绘制波纹层
- (void)drawRippleLayer{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, rippleYOffset);
    for (int i = 0; i <= KRippleWidth ; i++) {
        CGFloat y = _kRippleYMax * sin(rippleCycle*i+self.rippleOffset) + rippleYOffset;
        CGPathAddLineToPoint(path, NULL, i, y);
    }
    self.rippleLayer.path = path;
    CGPathRelease(path);
}

#pragma mark 定时器刷新页面
- (void)changeRipple{
    self.rippleOffset += rippleSpeed;
    [self setNeedsDisplay];
}

#pragma mark 开始动画
- (void)startAnimation {
    self.displayLink.paused = NO;
}
#pragma mark 结束动画
- (void)stopAnimation {
    self.displayLink.paused = YES;
}

- (void)dealloc {
    [self.displayLink invalidate];
}

@end
