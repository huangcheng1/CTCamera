//
//  CTCamera.h
//  Pods
//
//  Created by 黄成 on 15/12/24.
//
//

#import <Foundation/Foundation.h>

typedef void (^ResultImage)(UIImage*image);

@interface CTCamera : NSObject

- (void)showCameraOn:(UIViewController*)ctr withResult:(ResultImage)result withNeedEdit:(BOOL)needEdit save:(BOOL)shouldSave;

- (void)showCameraOn:(UIViewController*)ctr withResult:(ResultImage)result withNeedEdit:(BOOL)needEdit;

- (void)showCameraOn:(UIViewController*)ctr withResult:(ResultImage)result;

- (void)showPhotoEditWithImage:(UIImage*)image OnViewController:(UIViewController*)ctr withResult:(ResultImage)result save:(BOOL)shouldSave;

- (void)showPhotoEditWithImage:(UIImage*)image OnViewController:(UIViewController*)ctr withResult:(ResultImage)result;

- (void)setTintColor:(UIColor*)tintColor;
- (void)setSelectedTintColor:(UIColor*)selectedTintColor;


@end
