//
//  UIViewController+FullScreen.m
//  Pods
//
//  Created by 黄成 on 15/12/22.
//
//

#import "UIViewController+FullScreen.h"
#import <objc/runtime.h>

@implementation UIViewController (FullScreen)

- (void)setFullScreenMode{
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    self.wasStatusBarHidden = [UIApplication sharedApplication].statusBarHidden;
    self.wasFullScreenLayout = self.wantsFullScreenLayout;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [self setWantsFullScreenLayout:YES];
#elif __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
#endif
}

- (void)restoreFullScreenMode{
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IHPONE_7_0
    [[UIApplication sharedApplication] setStatusBarHidden:self.wasStatusBarHidden withAnimation:UIStatusBarAnimationSlide];
    [self setWasFullScreenLayout:self.wasFullScreenLayout];
#endif
}

- (void)setWasStatusBarHidden:(BOOL)wasStatusBarHidden{
    NSNumber *number = [NSNumber numberWithBool:wasStatusBarHidden];
    objc_setAssociatedObject(self, @selector(wasStatusBarHidden), number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)wasStatusBarHidden{
    NSNumber *number = objc_getAssociatedObject(self, @selector(wasStatusBarHidden));
    return number;
}

- (BOOL)wasFullScreenLayout{
    NSNumber *number = objc_getAssociatedObject(self, @selector(wasFullScreenLayout));
    return number;
}

- (void)setWasFullScreenLayout:(BOOL)wasFullScreenLayout{
    NSNumber *number = [NSNumber numberWithBool:wasFullScreenLayout];
    objc_setAssociatedObject(self, @selector(wasFullScreenLayout), number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
