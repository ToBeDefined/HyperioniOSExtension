//
//  HYPFPSMonitorManager.m
//  HYPFPSMonitor
//
//  Created by TBD on 2018/4/16.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "HYPFPSMonitorManager.h"
#import <objc/runtime.h>

// 计数器
CFTimeInterval HYPFPSMonitorManagerLastTime = 0;
NSUInteger HYPFPSMonitorManagerRefreshCount = 0;

CGFloat HYPFPSMonitorManagerFPSLabelWidth  = 60;
CGFloat HYPFPSMonitorManagerFPSLabelHeight = 30;

@interface HYPFPSMonitorManager()

@property (nonatomic, class, assign) BOOL isShowingFPSMonitorView;
@property (nonatomic, class, strong) CADisplayLink *displayLink;

@property (nonatomic, class, weak) UIWindow *fpsLabelWindow;
@property (nonatomic, class, weak) UIWindow *originKeyWindow;

@property (nonatomic, class, strong, readonly) UILabel *fpsLabel;

@end

@implementation HYPFPSMonitorManager


#pragma mark - isShowingFPSMonitorView
static BOOL __isShowingFPSMonitorView = NO;
+ (void)setIsShowingFPSMonitorView:(BOOL)isShowingFPSMonitorView {
    __isShowingFPSMonitorView = isShowingFPSMonitorView;
}

+ (BOOL)isShowingFPSMonitorView {
    return __isShowingFPSMonitorView;
}


#pragma mark - displayLink
static CADisplayLink *__dispalyLink = nil;
+ (CADisplayLink *)displayLink {
    return __dispalyLink;
}

+ (void)setDisplayLink:(CADisplayLink *)dispalyLink {
    __dispalyLink = dispalyLink;
}


#pragma mark - fpsLabelWindow
static UIWindow *__fpsLabelWindow = nil;
+ (UIWindow *)fpsLabelWindow {
    return __fpsLabelWindow;
}

+ (void)setFpsLabelWindow:(UIWindow *)fpsLabelWindow {
    __fpsLabelWindow = fpsLabelWindow;
}


#pragma mark - originKeyWindow
static UIWindow *__fpsMonitororiginKeyWindow = nil;
+ (UIWindow *)originKeyWindow {
    return __fpsMonitororiginKeyWindow;
}

+ (void)setOriginKeyWindow:(UIWindow *)originKeyWindow {
    __fpsMonitororiginKeyWindow = originKeyWindow;
}


#pragma mark - fpsLabel
static UILabel *__fpsLabel = nil;
+ (UILabel *)fpsLabel {
    if (__fpsLabel) {
        return __fpsLabel;
    }
    UILabel *fpsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  HYPFPSMonitorManagerFPSLabelWidth,
                                                                  HYPFPSMonitorManagerFPSLabelHeight)];
    fpsLabel.layer.cornerRadius = 5;
    fpsLabel.layer.masksToBounds = YES;
    fpsLabel.textAlignment = NSTextAlignmentCenter;
    fpsLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    __fpsLabel = fpsLabel;
    return __fpsLabel;
}

#pragma mark -
+ (void)showFPSMonitor:(BOOL)shouldShow {
    if (shouldShow && !self.isShowingFPSMonitorView) {
        [self showFPSMonitorView];
    } else {
        [self hideFPSMonitorView];
    }
}

+ (void)showFPSMonitorView {
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(calculateFPSValue:)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    self.originKeyWindow = [UIApplication sharedApplication].keyWindow;
    self.fpsLabelWindow = [[UIWindow alloc] initWithFrame:CGRectMake(10,
                                                                     [UIScreen mainScreen].bounds.size.height - 100,
                                                                     HYPFPSMonitorManagerFPSLabelWidth,
                                                                     HYPFPSMonitorManagerFPSLabelHeight)];
    self.fpsLabelWindow.alpha = 0;
    self.fpsLabelWindow.hidden = NO;
    self.fpsLabelWindow.layer.zPosition = CGFLOAT_MAX;
    self.fpsLabel.layer.zPosition = CGFLOAT_MAX;
    [self.fpsLabelWindow addSubview:self.fpsLabel];
    [self.fpsLabelWindow makeKeyWindow];
    [UIView animateWithDuration:0.2 animations:^{
        self.fpsLabelWindow.alpha = 1;
    } completion:^(BOOL finished) {
        [self.originKeyWindow makeKeyWindow];
        self.originKeyWindow = nil;
    }];
//    __weak typeof(self) weakSelf = self;
//    __block UIWindow *originKeyWindow = nil;
//    [[NSNotificationCenter defaultCenter] addObserverForName:UIWindowDidBecomeKeyNotification
//                                                      object:nil
//                                                       queue:[NSOperationQueue mainQueue]
//                                                  usingBlock:^(NSNotification * _Nonnull note) {
//                                                      if (self.fpsLabelWindow.isKeyWindow || [UIApplication sharedApplication].keyWindow == originKeyWindow) {
//                                                          return;
//                                                      }
//                                                      originKeyWindow = [UIApplication sharedApplication].keyWindow;
//                                                      [weakSelf.fpsLabelWindow makeKeyWindow];
////                                                      [originKeyWindow makeKeyWindow];
//                                                  }];
}

+ (void)hideFPSMonitorView {
    self.displayLink.paused = YES;
    [self.displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [self.displayLink invalidate];
    self.displayLink = nil;
    self.fpsLabel.attributedText = nil;
    [UIView animateWithDuration:0.2 animations:^{
        self.fpsLabelWindow.alpha = 0;
    } completion:^(BOOL finished) {
        self.fpsLabelWindow.hidden = YES;
        self.fpsLabelWindow = nil;
    }];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (void)calculateFPSValue:(CADisplayLink *)link {
    // 刷新一次计数 +1
    ++HYPFPSMonitorManagerRefreshCount;
    
    if (HYPFPSMonitorManagerLastTime == 0) {
        HYPFPSMonitorManagerLastTime = link.timestamp;
        return;
    }
    
    NSTimeInterval delta = link.timestamp - HYPFPSMonitorManagerLastTime;
    if (delta < 1) {
        return;
    }
    float fpsValue = HYPFPSMonitorManagerRefreshCount / delta;
    
    // 重置 lastTime refreshCount
    HYPFPSMonitorManagerLastTime = link.timestamp;
    HYPFPSMonitorManagerRefreshCount = 0;
    
    CGFloat progress = fpsValue / 60.0;
    UIColor *color = [UIColor colorWithHue:0.27 * (progress - 0.2) saturation:1 brightness:0.9 alpha:1];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%02d FPS",(int)round(fpsValue)]];
    [text addAttributes:@{NSForegroundColorAttributeName: color,
                          NSFontAttributeName: [UIFont systemFontOfSize:14]}
                  range:NSMakeRange(0, 2)];
    
    [text addAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                          NSFontAttributeName: [UIFont systemFontOfSize:14]}
                  range:NSMakeRange(text.length - 3, 3)];
    self.fpsLabel.attributedText = text;
}

@end










