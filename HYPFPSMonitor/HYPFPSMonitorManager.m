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

static NSString *HYPFPSLabelIsHaveAbsoluteFrameXY  = @"HYPFPSLabelIsHaveAbsoluteFrameXY";
static NSString *HYPFPSLabelAbsoluteFrameXSaveKey  = @"HYPFPSLabelAbsoluteFrameXSaveKey";
static NSString *HYPFPSLabelAbsoluteFrameYSaveKey  = @"HYPFPSLabelAbsoluteFrameYSaveKey";

@interface HYPFPSMonitorManager()

@property (nonatomic, class, assign) BOOL isShowingFPSMonitorView;
@property (nonatomic, class, strong) CADisplayLink *displayLink;
@property (nonatomic, class, strong, readonly) UILabel *fpsLabel;

@end

@implementation HYPFPSMonitorManager


#pragma mark - isShowingFPSMonitorView
+ (void)setIsShowingFPSMonitorView:(BOOL)isShowingFPSMonitorView {
    objc_setAssociatedObject(self,
                             @selector(isShowingFPSMonitorView),
                             @(isShowingFPSMonitorView),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (BOOL)isShowingFPSMonitorView {
    return [(NSNumber *)objc_getAssociatedObject(self, _cmd) boolValue];
}


#pragma mark - displayLink
+ (void)setDisplayLink:(CADisplayLink *)dispalyLink {
    objc_setAssociatedObject(self,
                             @selector(displayLink),
                             dispalyLink,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

+ (CADisplayLink *)displayLink {
    return objc_getAssociatedObject(self, _cmd);
}



#pragma mark - fpsLabel
+ (UILabel *)fpsLabel {
    UILabel *fpsLabel = objc_getAssociatedObject(self, _cmd);
    if (fpsLabel) {
        return fpsLabel;
    }
    fpsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                         0,
                                                         HYPFPSMonitorManagerFPSLabelWidth,
                                                         HYPFPSMonitorManagerFPSLabelHeight)];
    fpsLabel.layer.cornerRadius = 5;
    fpsLabel.layer.masksToBounds = YES;
    fpsLabel.textAlignment = NSTextAlignmentCenter;
    fpsLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    fpsLabel.userInteractionEnabled = YES;
    fpsLabel.textColor = [UIColor greenColor];
    fpsLabel.font = [UIFont systemFontOfSize:12];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(fpsLabelDidDragged:)];
    [pan setMaximumNumberOfTouches:1];
    [pan setMinimumNumberOfTouches:1];
    [fpsLabel addGestureRecognizer:pan];
    objc_setAssociatedObject(self,
                             _cmd,
                             fpsLabel,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return fpsLabel;
}

#pragma mark - fpsLabel拖动
+ (void)fpsLabelDidDragged:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateChanged || pan.state == UIGestureRecognizerStateEnded) {
        CGPoint offset = [pan translationInView:self.fpsLabel.superview];
        [self.fpsLabel setCenter:CGPointMake(self.fpsLabel.center.x + offset.x, self.fpsLabel.center.y + offset.y)];
        [pan setTranslation:CGPointMake(0, 0) inView:self.fpsLabel.superview];
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        // 保存上次拖动的位置
        CGRect absoluteFrame = [self getAbsoluteFrameForView:self.fpsLabel];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HYPFPSLabelIsHaveAbsoluteFrameXY];
        [[NSUserDefaults standardUserDefaults] setDouble:(double)absoluteFrame.origin.x forKey:HYPFPSLabelAbsoluteFrameXSaveKey];
        [[NSUserDefaults standardUserDefaults] setDouble:(double)absoluteFrame.origin.y forKey:HYPFPSLabelAbsoluteFrameYSaveKey];
    }
}

#pragma mark - view frame 操作

/**
 获取view在屏幕上的绝对frame

 @param view 获取绝对frame的view
 @return 返回在屏幕上的绝对frame
 */
+ (CGRect)getAbsoluteFrameForView:(UIView *)view {
    CGFloat x = view.frame.origin.x;
    CGFloat y = view.frame.origin.y;
    CGFloat width = view.frame.size.width;
    CGFloat height = view.frame.size.height;
    UIView *superView = view.superview;
    while (superView) {
        x += superView.frame.origin.x;
        y += superView.frame.origin.y;
        superView = superView.superview;
    }
    return CGRectMake(x, y, width, height);
}


/**
 根据绝对位置，转换成在view内的相对位置

 @param absoluteFrame 绝对frame
 @param view 获取绝对位置在view内相对位置的view
 @return view内的相对位置
 */
+ (CGRect)getRelativeFrameWithAbsoluteFrame:(CGRect)absoluteFrame inView:(UIView *)view {
    CGFloat x = absoluteFrame.origin.x;
    CGFloat y = absoluteFrame.origin.y;
    CGFloat width = absoluteFrame.size.width;
    CGFloat height = absoluteFrame.size.height;
    
    UIView *superView = view;
    while (superView) {
        x -= superView.frame.origin.x;
        y -= superView.frame.origin.y;
        superView = superView.superview;
    }
    return CGRectMake(x, y, width, height);
}

/**
 view 从原superView内到另一个superView的相对位置转换，保证绝对位置不变
 
 @param view 转换位置的view
 @param newSuperView view添加到新的superView上
 @return 载新的superView上该view的frame
 */
+ (CGRect)conversionRelativeFrameForView:(UIView *)view
                       addToNewSuperView:(UIWindow *)newSuperView {
    CGRect absoluteFrame = [self getAbsoluteFrameForView:view];
    return [self getRelativeFrameWithAbsoluteFrame:absoluteFrame inView:newSuperView];
}

#pragma mark - showFPSMonitor
+ (void)showFPSMonitor:(BOOL)shouldShow {
    if (shouldShow) {
        if (!self.isShowingFPSMonitorView) {
            [self showFPSMonitorView];
        }
        self.isShowingFPSMonitorView = YES;
    } else {
        [self hideFPSMonitorView];
        self.isShowingFPSMonitorView = NO;
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
}

+ (void)addFPSLabelToKeyWindow {
    if ([UIApplication sharedApplication].keyWindow.isHidden || [self.fpsLabel isDescendantOfView:[UIApplication sharedApplication].keyWindow]) {
        return;
    }
    if (self.fpsLabel.superview) {
        CGRect newFrame = [self conversionRelativeFrameForView:self.fpsLabel
                                             addToNewSuperView:[UIApplication sharedApplication].keyWindow];
        [self.fpsLabel removeFromSuperview];
        self.fpsLabel.frame = newFrame;
    } else {
        // 获取上次拖动的位置
        CGRect absoluteFrame;
        BOOL isHaveCacheFrame = [[NSUserDefaults standardUserDefaults] boolForKey:HYPFPSLabelIsHaveAbsoluteFrameXY];
        if (isHaveCacheFrame) {
            CGFloat absoluteFrameX = (CGFloat)[[NSUserDefaults standardUserDefaults] floatForKey:HYPFPSLabelAbsoluteFrameXSaveKey];
            CGFloat absoluteFrameY = (CGFloat)[[NSUserDefaults standardUserDefaults] floatForKey:HYPFPSLabelAbsoluteFrameYSaveKey];
            absoluteFrame = CGRectMake(absoluteFrameX,
                                       absoluteFrameY,
                                       HYPFPSMonitorManagerFPSLabelWidth,
                                       HYPFPSMonitorManagerFPSLabelHeight);
        } else {
            CGFloat frameY = [UIScreen mainScreen].bounds.size.height - 100;
            if (frameY < 0) {
                frameY = 0;
            }
            absoluteFrame = CGRectMake(10,
                                       frameY,
                                       HYPFPSMonitorManagerFPSLabelWidth,
                                       HYPFPSMonitorManagerFPSLabelHeight);
        }
        CGRect relativeFrame = [self getRelativeFrameWithAbsoluteFrame:absoluteFrame
                                                                inView:[UIApplication sharedApplication].keyWindow];
        self.fpsLabel.frame = relativeFrame;
    }
    self.fpsLabel.layer.zPosition = CGFLOAT_MAX;
    self.fpsLabel.alpha = 0;
    self.fpsLabel.hidden = NO;
    [[UIApplication sharedApplication].keyWindow addSubview:self.fpsLabel];
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
        // 重置 lastTime refreshCount
        HYPFPSMonitorManagerLastTime = 0;
        HYPFPSMonitorManagerRefreshCount = 0;
    }];
}

+ (void)calculateFPSValue:(CADisplayLink *)link {
    // 刷新一次计数 +1
    ++HYPFPSMonitorManagerRefreshCount;
    
    if (HYPFPSMonitorManagerLastTime == 0) {
        self.fpsLabel.text = @"wait...";
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
                          NSFontAttributeName: [UIFont systemFontOfSize:10]}
                  range:NSMakeRange(text.length - 3, 3)];
    self.fpsLabel.attributedText = text;
}

@end

