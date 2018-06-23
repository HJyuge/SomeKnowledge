//
//  WaveView.m
//  SomeKnowledge
//
//  Created by HuangJin on 2018/6/13.
//  Copyright © 2018年 HuangJin. All rights reserved.
//

#import "WaveView.h"
/*
 y = Asin（ωx+φ）+C
 A叫做振幅；
 T=2π/w 叫做周期
 wx+φ叫做相位，φ叫做初相。由y =A sinωx+C 到y =Asin（ωx+φ）+C需要平移的单位数为φ/w而不是φ。我们可以φ这个变量来间接调整波浪的流动
 C表示波浪纵向的位置，也就是使用这个变量来调整波浪在屏幕中竖直的位置。
 */

@interface WaveView()
{
    CGFloat waveA;//第一个波浪图层的水纹振幅A
    CGFloat waveB;//第二个波浪图层的水纹振幅B
    CGFloat waveW ;//水纹周期
    CGFloat offsetXA; //第一个波浪图层的位移A φ
    CGFloat offsetXB;//第二个波浪图层的位移B φ
    CGFloat currentK; //当前波浪高度Y
    CGFloat waveSpeedA;//第一个波浪图层的水纹速度A
    CGFloat waveSpeedB;//第二个波浪图层的水纹速度B
    CGFloat waterWaveWidth; //水纹宽度 T=2π/w  w决定
    
}
@property (nonatomic, strong) CADisplayLink *waveDisplaylink;
@property (nonatomic, strong) CAShapeLayer *firstWaveLayer;
@property (nonatomic, strong) CAShapeLayer *secondWaveLayer;

@end
@implementation WaveView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

-(void)setUp
{
    //设置波浪的宽度
    waterWaveWidth = self.frame.size.width;
    //设置周期影响参数，2π/waveW是一个周期
    waveW = 1/30.0;
    //设置波浪纵向位置
    currentK = self.frame.size.height*0.5;//屏幕居中
    
    /*
     *初始化第一个波纹图层
     */
    _firstWaveLayer = [CAShapeLayer layer];
    //设置填充颜色
    _firstWaveLayer.fillColor = [UIColor colorWithRed:52/255.0 green:98/255.0 blue:176/255.0 alpha:1.0].CGColor;
    //添加到view的layer上
    [self.layer addSublayer:_firstWaveLayer];
    //设置波纹流动速度
    waveSpeedA = 0.3;
    //设置波纹振幅
    waveA = 10;
    //初始化偏移量影响参数，平移的单位为offsetXA/waveW,而不是offsetXA
    offsetXA = 0;
    
    /*
     *初始化第二个波纹图层
     */
    //初始化
    _secondWaveLayer = [CAShapeLayer layer];
    //设置填充颜色
    _secondWaveLayer.fillColor = [UIColor colorWithRed:32/255.0 green:78/255.0 blue:156/255.0 alpha:1.0].CGColor;
    //添加到view的layer上
    [self.layer addSublayer:_secondWaveLayer];
    //设置波纹流动速度
    waveSpeedB = 0.2;
    //设置波纹振幅
    waveB = 10;
    //初始化偏移量影响参数，平移的单位为offsetXB/waveW,而不是offsetXB
    offsetXB = 1;
    
    /*
     *启动定时器
     */
    _waveDisplaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave:)];
    _waveDisplaylink.frameInterval = 2;//设置定时器刷新的频率
    [_waveDisplaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];//添加到RunLoop中
}

#pragma mark 实现波纹动画
-(void)getCurrentWave:(CADisplayLink *)displayLink
{
    //实时的位移waveSpeedA/waveW
    offsetXA += waveSpeedA;
    offsetXB += waveSpeedB;
    [self setCurrentWaveLayerPath];
    
}

//重新绘制波浪图层
-(void)setCurrentWaveLayerPath
{
    CGMutablePathRef pathA = CGPathCreateMutable();
    CGFloat y = currentK;
    CGPathMoveToPoint(pathA, nil, 0, y);
    for (CGFloat x = 0; x < waterWaveWidth; x++) {
        CGFloat y = waveA * sin(waveW * x + offsetXA) + currentK;
        CGPathAddLineToPoint(pathA, nil, x, y);
    }
    CGPathAddLineToPoint(pathA, nil, waterWaveWidth, self.frame.size.height);
    CGPathAddLineToPoint(pathA, nil, 0 ,self.frame.size.height);
    CGPathCloseSubpath(pathA);
    _firstWaveLayer.path = pathA;
    
    CGMutablePathRef pathB = CGPathCreateMutable();

    CGPathMoveToPoint(pathB, nil, 0, y);
    for (CGFloat x = 0; x < waterWaveWidth; x++) {
        CGFloat y = waveB * sin(waveW * x + offsetXB) + currentK;
        CGPathAddLineToPoint(pathB, nil, x, y);
    }
    CGPathAddLineToPoint(pathB, nil, waterWaveWidth, self.frame.size.height);
    CGPathAddLineToPoint(pathB, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(pathB);
    _secondWaveLayer.path = pathB;

    CGPathRelease(pathA);
    CGPathRelease(pathB);
}

#pragma mark 销毁定时器
-(void)dealloc
{
    [_waveDisplaylink invalidate];
}

@end
