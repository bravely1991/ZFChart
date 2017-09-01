//
//  SingleRadarChartViewController.m
//  ZFChartView
//
//  Created by apple on 16/9/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SingleRadarChartViewController.h"
#import "ZFChart.h"

@interface SingleRadarChartViewController()<ZFRadarChartDataSource, ZFRadarChartDelegate>

@property (nonatomic, strong) ZFRadarChart * radarChart;

@property (nonatomic, assign) CGFloat height;

@end

@implementation SingleRadarChartViewController

- (void)setUp{
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        //首次进入控制器为横屏时
        _height = SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT * 0.5;
        
    }else{
        //首次进入控制器为竖屏时
        _height = SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT;
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setUp];
    
    self.radarChart = [[ZFRadarChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _height)];
    self.radarChart.dataSource = self;
    self.radarChart.delegate = self;
    self.radarChart.itemTextColor = [UIColor colorWithRed:58/255.0 green:58/255.0 blue:58/255.0 alpha:1];;
    self.radarChart.itemFont = [UIFont systemFontOfSize:14.f];
    self.radarChart.polygonLineWidth = 2.f;
    self.radarChart.radarLineColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1];
    self.radarChart.isShowValue = NO;
    [self.view addSubview:self.radarChart];
    [self.radarChart strokePath];
}

#pragma mark - ZFRadarChartDataSource

- (NSArray *)itemArrayInRadarChart:(ZFRadarChart *)radarChart{
    return @[@"政务诚信", @"司法公信", @"三方服务", @"金融信用", @"公共服务"];
}

- (NSArray *)valueArrayInRadarChart:(ZFRadarChart *)radarChart{
    return @[@"3", @"6", @"5", @"2", @"4"];
}

- (NSArray *)colorArrayInRadarChart:(ZFRadarChart *)radarChart{
    return @[ZFRed,ZFOrange,ZFBlue,ZFRed,ZFOrange];
}

- (CGFloat)maxValueInRadarChart:(ZFRadarChart *)radarChart{
    return 10.f;
}

- (NSUInteger)sectionCountInRadarChart:(ZFRadarChart *)radarChart {
    return 7;
}

- (NSArray *)describeValueInRadarChart:(ZFRadarChart *)radarChart {
    return @[@"3项行为", @"6项行为", @"5项行为", @"2项行为", @"4项行为"];
}

#pragma mark - ZFRadarChartDelegate

- (CGFloat)radiusForRadarChart:(ZFRadarChart *)radarChart{
    
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        return (SCREEN_HEIGHT - 100) / 2;
    }else{
        return (SCREEN_WIDTH - 100) / 2;
    }
    
//    return 100.f;
}

//- (NSUInteger)sectionCountInRadarChart:(ZFRadarChart *)radarChart{
//    return 4;
//}

//- (CGFloat)radiusExtendLengthForRadarChart:(ZFRadarChart *)radarChart itemIndex:(NSInteger)itemIndex{
//    if (itemIndex == 7) {
//        return 50.f;
//    }
//    
//    return 25.f;
//}

//- (CGFloat)valueRotationAngleForRadarChart:(ZFRadarChart *)radarChart{
//    return 45.f;
//}

- (void)radarChart:(ZFRadarChart *)radarChart didSelectItemLabelAtIndex:(NSInteger)labelIndex{
    NSLog(@"当前点击的下标========%ld", (long)labelIndex);
}


#pragma mark - 横竖屏适配(若需要同时横屏,竖屏适配，则添加以下代码，反之不需添加)

/**
 *  PS：size为控制器self.view的size，若图表不是直接添加self.view上，则修改以下的frame值
 */
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator{
    
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        self.radarChart.frame = CGRectMake(0, 0, size.width, size.height - NAVIGATIONBAR_HEIGHT * 0.5);
        
    }else{
        self.radarChart.frame = CGRectMake(0, 0, size.width, size.height + NAVIGATIONBAR_HEIGHT * 0.5);
        
    }
    
    [self.radarChart strokePath];
}

@end
