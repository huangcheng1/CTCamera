//
//  UIViewController+FullScreen.h
//  Pods
//
//  Created by 黄成 on 15/12/22.
//
//

#import <UIKit/UIKit.h>

@interface UIViewController (FullScreen)

@property (nonatomic,assign) BOOL wasStatusBarHidden;

@property (nonatomic,assign) BOOL wasFullScreenLayout;

- (void)setFullScreenMode;

- (void)restoreFullScreenMode;

@end
