//
//  HYPFPSMonitorManager.m
//  HYPFPSMonitor
//
//  Created by TBD on 2018/4/16.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import "HYPFPSMonitorManager.h"

#define HYPFPSMonitorManagerFPSViewWidth    100
#define HYPFPSMonitorManagerFPSViewHeight   100

#define HYPFPSViewIsHaveAbsoluteFrameXY    @"HYPFPSViewIsHaveAbsoluteFrameXY"
#define HYPFPSViewAbsoluteFrameXSaveKey    @"HYPFPSViewAbsoluteFrameXSaveKey"
#define HYPFPSViewAbsoluteFrameYSaveKey    @"HYPFPSViewAbsoluteFrameYSaveKey"

@interface HYPFPSMonitorManager() <NSCopying, NSMutableCopying>

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) UIView *fpsView;
@property (nonatomic, strong) UILabel *fpsLabel;
@property (nonatomic, assign) BOOL isAddPan;
// 计数器
@property (nonatomic, assign) CFTimeInterval lastTime;
@property (nonatomic, assign) NSUInteger refreshCount;
@end

@implementation HYPFPSMonitorManager

static HYPFPSMonitorManager *sharedHYPFPSMonitorManager = nil;
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHYPFPSMonitorManager = [super allocWithZone:zone];
    });
    return sharedHYPFPSMonitorManager;
}

- (id)copyWithZone:(NSZone *)zone {
    return sharedHYPFPSMonitorManager;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return sharedHYPFPSMonitorManager;
}

- (instancetype)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHYPFPSMonitorManager = [super init];
        sharedHYPFPSMonitorManager->_isCanTouchFPSView = YES;
        sharedHYPFPSMonitorManager->_lastTime = 0;
        sharedHYPFPSMonitorManager->_refreshCount = 0;
    });
    return sharedHYPFPSMonitorManager;
}

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHYPFPSMonitorManager = [[[self class] alloc] init];
    });
    return sharedHYPFPSMonitorManager;
}

+ (instancetype)shared {
    return [self sharedManager];
}

#pragma mark - FPS Views
- (UIView *)fpsView {
    if (self->_fpsView) {
        return self->_fpsView;
    }
    [self createFPSViews];
    return self->_fpsView;
}

- (UILabel *)fpsLabel {
    if (self->_fpsLabel) {
        return self->_fpsLabel;
    }
    [self createFPSViews];
    return self->_fpsLabel;
}

- (void)createFPSViews {
    // fpsView
    UIView *fpsView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               HYPFPSMonitorManagerFPSViewWidth,
                                                               HYPFPSMonitorManagerFPSViewHeight)];
    self->_fpsView = fpsView;
    fpsView.backgroundColor = [UIColor clearColor];
    // fpsLabel
    CGFloat fpsLabelHeight  = 30;
    CGFloat fpsLabelWidth   = 60;
    CGFloat fpsLabelX       = (HYPFPSMonitorManagerFPSViewWidth  - fpsLabelWidth ) / 2;
    CGFloat fpsLabelY       = (HYPFPSMonitorManagerFPSViewHeight - fpsLabelHeight) / 2;
    UILabel *fpsLabel = [[UILabel alloc] initWithFrame:CGRectMake(fpsLabelX,
                                                                  fpsLabelY,
                                                                  fpsLabelWidth,
                                                                  fpsLabelHeight)];
    self->_fpsLabel = fpsLabel;
    [fpsView addSubview:fpsLabel];
    fpsLabel.layer.cornerRadius = 5;
    fpsLabel.layer.masksToBounds = YES;
    fpsLabel.textAlignment = NSTextAlignmentCenter;
    fpsLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    fpsLabel.userInteractionEnabled = YES;
    fpsLabel.textColor = [UIColor whiteColor];
    fpsLabel.font = [UIFont systemFontOfSize:12];
    [self addOrRemoveGestureRecognizer];
}

#pragma mark - fpsView拖动
- (void)setIsCanTouchFPSView:(BOOL)isCanTouchFPSView {
    self->_isCanTouchFPSView = isCanTouchFPSView;
    [self addOrRemoveGestureRecognizer];
}
- (void)addOrRemoveGestureRecognizer {
    if (self.isCanTouchFPSView) {
        [self addGestureRecognizer];
    } else {
        [self removeGestureRecognizer];
    }
}

- (void)addGestureRecognizer {
    if (self->_fpsView) {
        if (self.isAddPan) {
            return;
        }
        self.isAddPan = YES;
        self->_fpsView.userInteractionEnabled = YES;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidDragged:)];
        [pan setMaximumNumberOfTouches:1];
        [pan setMinimumNumberOfTouches:1];
        [self->_fpsView addGestureRecognizer:pan];
        objc_setAssociatedObject(pan,
                                 @selector(viewDidDragged:),
                                 self->_fpsView,
                                 OBJC_ASSOCIATION_ASSIGN);
    }
}

- (void)removeGestureRecognizer {
    if (self->_fpsView) {
        self->_fpsView.userInteractionEnabled = NO;
        for (UIGestureRecognizer *ges in self->_fpsView.gestureRecognizers) {
            [self->_fpsView removeGestureRecognizer:ges];
        }
        self.isAddPan = NO;
    }
}

- (void)viewDidDragged:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateChanged || pan.state == UIGestureRecognizerStateEnded) {
        UIView *dragView = objc_getAssociatedObject(pan, @selector(viewDidDragged:));
        CGPoint offset = [pan translationInView:dragView.superview];
        [dragView setCenter:CGPointMake(dragView.center.x + offset.x, dragView.center.y + offset.y)];
        [pan setTranslation:CGPointMake(0, 0) inView:dragView.superview];
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        // 保存上次拖动的位置
        UIView *dragView = objc_getAssociatedObject(pan, @selector(viewDidDragged:));
        CGRect absoluteFrame = [self getAbsoluteFrameForView:dragView];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HYPFPSViewIsHaveAbsoluteFrameXY];
        [[NSUserDefaults standardUserDefaults] setDouble:(double)absoluteFrame.origin.x forKey:HYPFPSViewAbsoluteFrameXSaveKey];
        [[NSUserDefaults standardUserDefaults] setDouble:(double)absoluteFrame.origin.y forKey:HYPFPSViewAbsoluteFrameYSaveKey];
    }
}

#pragma mark - view frame 操作

/**
 获取view在屏幕上的绝对frame

 @param view 获取绝对frame的view
 @return 返回在屏幕上的绝对frame
 */
- (CGRect)getAbsoluteFrameForView:(UIView *)view {
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
- (CGRect)getRelativeFrameWithAbsoluteFrame:(CGRect)absoluteFrame inView:(UIView *)view {
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
- (CGRect)conversionRelativeFrameForView:(UIView *)view
                       addToNewSuperView:(UIWindow *)newSuperView {
    CGRect absoluteFrame = [self getAbsoluteFrameForView:view];
    return [self getRelativeFrameWithAbsoluteFrame:absoluteFrame inView:newSuperView];
}

#pragma mark - showFPSMonitor
- (void)showFPSMonitor {
    if (self.isShowingFPSMonitorView) {
        return;
    }
    if (!self.displayLink) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(calculateFPSValue:)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    [self addFPSViewToKeyWindow];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addFPSViewToKeyWindow)
                                                 name:UIWindowDidBecomeKeyNotification
                                               object:nil];
    [self willChangeValueForKey:NSStringFromSelector(@selector(isShowingFPSMonitorView))];
    self->_isShowingFPSMonitorView = YES;
    [self didChangeValueForKey:NSStringFromSelector(@selector(isShowingFPSMonitorView))];
}

- (void)addFPSViewToKeyWindow {
    if ([UIApplication sharedApplication].keyWindow.isHidden || [self.fpsView isDescendantOfView:[UIApplication sharedApplication].keyWindow]) {
        return;
    }
    if (self.fpsView.superview) {
        CGRect newFrame = [self conversionRelativeFrameForView:self.fpsView
                                             addToNewSuperView:[UIApplication sharedApplication].keyWindow];
        [self.fpsView removeFromSuperview];
        self.fpsView.frame = newFrame;
    } else {
        // 获取上次拖动的位置
        CGRect absoluteFrame;
        BOOL isHaveCacheFrame = [[NSUserDefaults standardUserDefaults] boolForKey:HYPFPSViewIsHaveAbsoluteFrameXY];
        // 如果允许触摸并且有缓存位置则用缓存的位置，否则使用默认位置
        if (self.isCanTouchFPSView && isHaveCacheFrame) {
            CGFloat absoluteFrameX = (CGFloat)[[NSUserDefaults standardUserDefaults] floatForKey:HYPFPSViewAbsoluteFrameXSaveKey];
            CGFloat absoluteFrameY = (CGFloat)[[NSUserDefaults standardUserDefaults] floatForKey:HYPFPSViewAbsoluteFrameYSaveKey];
            absoluteFrame = CGRectMake(absoluteFrameX,
                                       absoluteFrameY,
                                       HYPFPSMonitorManagerFPSViewWidth,
                                       HYPFPSMonitorManagerFPSViewHeight);
        } else {
            CGFloat frameY = [UIScreen mainScreen].bounds.size.height - HYPFPSMonitorManagerFPSViewHeight;
            if (frameY < 0) {
                frameY = 0;
            }
            absoluteFrame = CGRectMake(0,
                                       frameY,
                                       HYPFPSMonitorManagerFPSViewWidth,
                                       HYPFPSMonitorManagerFPSViewHeight);
        }
        CGRect relativeFrame = [self getRelativeFrameWithAbsoluteFrame:absoluteFrame
                                                                inView:[UIApplication sharedApplication].keyWindow];
        self.fpsView.frame = relativeFrame;
    }
    self.fpsView.layer.zPosition = FLT_MAX;
    self.fpsView.alpha = 0;
    self.fpsView.hidden = NO;
    [[UIApplication sharedApplication].keyWindow addSubview:self.fpsView];
    [UIView animateWithDuration:0.25 animations:^{
        self.fpsView.alpha = 1;
    } completion:^(BOOL finished) {
        // 防止其他操作导致隐藏
        self.fpsView.alpha = 1;
        self.fpsView.hidden = NO;
    }];
}

- (void)hideFPSMonitor {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.displayLink.paused = YES;
    [self.displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [self.displayLink invalidate];
    self.displayLink = nil;
    [UIView animateWithDuration:0.1 animations:^{
        self.fpsView.alpha = 0;
    } completion:^(BOOL finished) {
        self.fpsLabel.attributedText = nil;
        self.fpsLabel.text = nil;
        [self.fpsView removeFromSuperview];
        // 防止其他操作导致显示
        self.fpsView.alpha = 0;
        self.fpsView.hidden = YES;
        // 重置 lastTime refreshCount
        self.lastTime = 0;
        self.refreshCount = 0;
        [self willChangeValueForKey:NSStringFromSelector(@selector(isShowingFPSMonitorView))];
        self->_isShowingFPSMonitorView = NO;
        [self didChangeValueForKey:NSStringFromSelector(@selector(isShowingFPSMonitorView))];
    }];
}

- (void)calculateFPSValue:(CADisplayLink *)link {
    // 刷新一次计数 +1
    ++self.refreshCount;
    
    if (self.lastTime == 0) {
        self.fpsLabel.text = @"wait...";
        self.lastTime = link.timestamp;
        return;
    }
    
    NSTimeInterval delta = link.timestamp - self.lastTime;
    if (delta < 1) {
        return;
    }
    float fpsValue = self.refreshCount / delta;
    
    // 重置 lastTime refreshCount
    self.lastTime = link.timestamp;
    self.refreshCount = 0;
    
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

