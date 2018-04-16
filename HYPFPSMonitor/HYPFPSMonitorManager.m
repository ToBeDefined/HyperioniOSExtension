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
    [self addFPSLabelToKeyWindow];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addFPSLabelToKeyWindow)
                                                 name:UIWindowDidBecomeKeyNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self.fpsLabel
                                             selector:@selector(removeFromSuperview)
                                                 name:UIWindowDidResignKeyNotification
                                               object:nil];
}

+ (void)addFPSLabelToKeyWindow {
    if ([UIApplication sharedApplication].keyWindow.isHidden || [self.fpsLabel isDescendantOfView:[UIApplication sharedApplication].keyWindow]) {
        return;
    }
    [self.fpsLabel removeFromSuperview];
    self.fpsLabel.layer.zPosition = CGFLOAT_MAX;
    self.fpsLabel.alpha = 0;
    self.fpsLabel.hidden = NO;
    [[UIApplication sharedApplication].keyWindow addSubview:self.fpsLabel];
    CGFloat frameY = [UIApplication sharedApplication].keyWindow.frame.size.height - 100;
    if (frameY < 0) {
        frameY = 0;
    }
    self.fpsLabel.frame = CGRectMake(10,
                                     frameY,
                                     HYPFPSMonitorManagerFPSLabelWidth,
                                     HYPFPSMonitorManagerFPSLabelHeight);
    [UIView animateWithDuration:0.5 animations:^{
        self.fpsLabel.alpha = 1;
    }];
}

+ (void)hideFPSMonitorView {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.displayLink.paused = YES;
    [self.displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [self.displayLink invalidate];
    self.displayLink = nil;
    self.fpsLabel.attributedText = nil;
    [UIView animateWithDuration:0.5 animations:^{
        self.fpsLabel.alpha = 0;
    } completion:^(BOOL finished) {
        [self.fpsLabel removeFromSuperview];
        self.fpsLabel.hidden = YES;
    }];
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










