//
//  ZFPolygon.m
//  ZFChartView
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFPolygon.h"
#import "ZFConst.h"

@interface ZFPolygon()

/** 动画时间 */
@property (nonatomic, assign) CGFloat animationDuration;
/** 多边形中心点 */
@property (nonatomic, assign) CGPoint polygonCenter;
/** 雷达中点当前角度 */
@property (nonatomic, assign) CGFloat currentRadarAngle;
///** 雷达角点终点xPos */
//@property (nonatomic, assign) CGFloat endXPos;
///** 雷达角点终点yPos */
//@property (nonatomic, assign) CGFloat endYPos;
/** 雷达开始角度 */
@property (nonatomic, assign) CGFloat startAngle;
/** 雷达结束角度 */
@property (nonatomic, assign) CGFloat endAngle;
/** 获取当前item半径 */
@property (nonatomic, assign) CGFloat currentRadius;
/** 存储每个item半径的数组 */
@property (nonatomic, strong) NSMutableArray * radiusArray;


@end

@implementation ZFPolygon

/**
 *  初始化变量
 */
- (void)commonInit{
    _animationDuration = 0.5f;
    _startAngle = -90.f;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

/**
 *  未填充bezierPath
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)noFill{
    UIBezierPath * bezier = [UIBezierPath bezierPath];
    for (NSInteger i = 0; i < _radiusArray.count; i++) {
        i == 0 ? [bezier moveToPoint:_polygonCenter] : [bezier addLineToPoint:_polygonCenter];
    }
    
    [bezier closePath];
    return bezier;
}

/**
 *  填充bezierPath
 *
 *  @return UIBezierPath
 */
- (void)getDescribePoint{
    [self.describePointArray removeAllObjects];
    _startAngle = -90.f;
    //获取第一个item半径
    _currentRadius = [_radiusArray.firstObject floatValue];
    //    UIBezierPath * bezier = [UIBezierPath bezierPath];
    //    [bezier moveToPoint:CGPointMake(_polygonCenter.x, _polygonCenter.y - _currentRadius)];
    
    [self.describePointArray addObject:[NSValue valueWithCGPoint:CGPointMake(_polygonCenter.x, _polygonCenter.y - _currentRadius)]];
    
    
    for (NSInteger i = 1; i < _radiusArray.count; i++) {
        _currentRadarAngle = _averageRadarAngle * i;
        //计算每个item的角度
        _endAngle = _startAngle + _averageRadarAngle;
        //获取当前item半径
        _currentRadius = [_radiusArray[i] floatValue];
        
        if (_endAngle > -90.f && _endAngle <= 0.f) {
            _endXPos = _polygonCenter.x + fabs(-(_currentRadius * ZFSin(_currentRadarAngle)));
            _endYPos = _polygonCenter.y - fabs(_currentRadius * ZFCos(_currentRadarAngle));
            
        }else if (_endAngle > 0.f && _endAngle <= 90.f){
            _endXPos = _polygonCenter.x + fabs(-(_currentRadius * ZFSin(_currentRadarAngle)));
            _endYPos = _polygonCenter.y + fabs(_currentRadius * ZFCos(_currentRadarAngle));
            
        }else if (_endAngle > 90.f && _endAngle <= 180.f){
            _endXPos = _polygonCenter.x - fabs(-(_currentRadius * ZFSin(_currentRadarAngle)));
            _endYPos = _polygonCenter.y + fabs(_currentRadius * ZFCos(_currentRadarAngle));
            
        }else if (_endAngle > 180.f && _endAngle < 270.f){
            _endXPos = _polygonCenter.x - fabs(-(_currentRadius * ZFSin(_currentRadarAngle)));
            _endYPos = _polygonCenter.y - fabs(_currentRadius * ZFCos(_currentRadarAngle));
        }
        
        //        [bezier addLineToPoint:CGPointMake(_endXPos, _endYPos)];
        //记录下一个item开始角度
        _startAngle = _endAngle;
        
        [self.describePointArray addObject:[NSValue valueWithCGPoint:CGPointMake(_endXPos, _endYPos)]];
        
    }
    //    [bezier closePath];
    //    return bezier;
}

#pragma mark - 清除控件

/**
 *  清除之前所有subLayers
 */
- (void)removeAllSubLayers{
    NSArray * sublayers = [NSArray arrayWithArray:self.layer.sublayers];
    for (CALayer * layer in sublayers) {
        [layer removeAllAnimations];
        [layer removeFromSuperlayer];
    }
}

#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath{
    [self removeAllSubLayers];
    
    [self getDescribePoint];
    [self getExtendPoint];
    NSInteger count = self.extendPointArray.count;
    for (NSInteger i=0; i<count; i++) {
        CGPoint point = [self.extendPointArray[(i+1) % count] CGPointValue];
        CGPoint nextPoint = [self.extendPointArray[(i+2) % count] CGPointValue];
        UIColor *color = self.extendColorArray[i];
        [self.layer addSublayer:[self drawTraiangleWithPoint:point nextPoint:nextPoint fillColor:color]];
        //        [self.layer addSublayer:[self drawTraiangleStrokeWithPoint:point nextPoint:nextPoint strokeColor:color]];
    }
}

#pragma mark - 重写setter, getter方法

- (void)setMaxRadius:(CGFloat)maxRadius{
    _maxRadius = maxRadius;
    _polygonCenter = CGPointMake(_maxRadius, _maxRadius);
}

- (void)setValueArray:(NSMutableArray *)valueArray{
    _valueArray = valueArray;
    
    //计算每个item的半径
    for (NSInteger i = 0; i < _valueArray.count; i++) {
        CGFloat percent = ([_valueArray[i] floatValue] - _minValue) / (_maxValue - _minValue);
        CGFloat currentRadius = _maxRadius * percent;
        
        [self.radiusArray addObject:@(currentRadius)];
    }
}

#pragma mark - 获取2*n多边形点
- (void)getExtendPoint {
    NSInteger count = self.describePointArray.count;
    for (int i=0; i<count; i++) {
        [self.extendPointArray addObject:self.describePointArray[i]];
        
        CGPoint point = [self.describePointArray[i] CGPointValue];
        CGPoint pointNext = [self.describePointArray[(i+1) % count] CGPointValue];
        
        CGFloat newX = point.x + (pointNext.x - point.x)/2.0;
        CGFloat newY = point.y + (pointNext.y - point.y)/2.0;
        CGPoint newPoint = CGPointMake(newX, newY);
        [self.extendPointArray addObject:[NSValue valueWithCGPoint:newPoint]];
    }
}

//填充三角形
- (CAShapeLayer *)drawTraiangleWithPoint:(CGPoint)point nextPoint:(CGPoint)nextPoint fillColor:(UIColor *)color{
    // 三角形
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = color.CGColor;
    shapeLayer.strokeColor = nil;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineWidth = 1;
    
    UIBezierPath *triangle = [UIBezierPath bezierPath];
    [triangle moveToPoint:_polygonCenter];
    [triangle addLineToPoint:point];
    [triangle addLineToPoint:nextPoint];
    [triangle closePath];
    shapeLayer.path = triangle.CGPath;
    
    if (_isAnimated) {
        CABasicAnimation * fillAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        fillAnimation.duration = _animationDuration;
        fillAnimation.fillMode = kCAFillModeForwards;
        fillAnimation.removedOnCompletion = NO;
        fillAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        fillAnimation.fromValue = (__bridge id)[self noFill].CGPath;
        fillAnimation.toValue = (__bridge id)triangle.CGPath;
        
        [shapeLayer addAnimation:fillAnimation forKey:@"animationDuration"];
    }
    
    return shapeLayer;
}

//绘制三角形轮廓
- (CAShapeLayer *)drawTraiangleStrokeWithPoint:(CGPoint)point nextPoint:(CGPoint)nextPoint strokeColor:(UIColor *)color{
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = nil;
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineWidth = 1;
    
    UIBezierPath *triangle = [UIBezierPath bezierPath];
    [triangle moveToPoint:_polygonCenter];
    [triangle addLineToPoint:point];
    [triangle addLineToPoint:nextPoint];
    [triangle closePath];
    shapeLayer.path = triangle.CGPath;
    
    if (_isAnimated) {
        CABasicAnimation * fillAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        fillAnimation.duration = _animationDuration;
        fillAnimation.fillMode = kCAFillModeForwards;
        fillAnimation.removedOnCompletion = NO;
        fillAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        fillAnimation.fromValue = (__bridge id)[self noFill].CGPath;
        fillAnimation.toValue = (__bridge id)triangle.CGPath;
        
        [shapeLayer addAnimation:fillAnimation forKey:@"animationDuration"];
    }
    
    return shapeLayer;
}

#pragma mark - 懒加载

- (NSMutableArray *)radiusArray{
    if (!_radiusArray) {
        _radiusArray = [NSMutableArray array];
    }
    return _radiusArray;
}

- (NSMutableArray *)describePointArray {
    if (!_describePointArray) {
        _describePointArray = [NSMutableArray array];
    }
    return _describePointArray;
}

- (NSMutableArray *)extendPointArray {
    if (!_extendPointArray) {
        _extendPointArray = [NSMutableArray array];
        
    }
    return _extendPointArray;
}

- (NSMutableArray *)extendColorArray {
    if (!_extendColorArray) {
        _extendColorArray = [NSMutableArray array];
        
        [_extendColorArray addObject:XRColorRGB(93, 112, 121)];
        [_extendColorArray addObject:XRColorRGB(63, 85, 91)];
        
        [_extendColorArray addObject:XRColorRGB(159, 20, 95)];
        [_extendColorArray addObject:XRColorRGB(222, 30, 117)];
        
        [_extendColorArray addObject:XRColorRGB(233, 198, 73)];
        [_extendColorArray addObject:XRColorRGB(222, 152, 65)];
        
        [_extendColorArray addObject:XRColorRGB(166, 202, 65)];
        [_extendColorArray addObject:XRColorRGB(133, 168, 51)];
        
        [_extendColorArray addObject:XRColorRGB(117, 177, 211)];
        [_extendColorArray addObject:XRColorRGB(77, 140, 172)];
    }
    
    return _extendColorArray;
}

@end
