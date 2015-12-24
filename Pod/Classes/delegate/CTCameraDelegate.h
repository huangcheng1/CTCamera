//
//  CTCameraDelegate.h
//  Pods
//
//  Created by 黄成 on 15/12/21.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol CTCameraDelegate <NSObject>

@end

@protocol CTCameraViewDelegate <NSObject>

@optional

/*
 focus
 */
- (void)cameraView:(UIView *)cameraView focusAtPoint:(CGPoint)point;

/*
 exposure
 */
- (void)cameraView:(UIView *)cameraView exposureAtPoint:(CGPoint)point;

/*
 start record
 */
- (void)cameraViewStartRecording;

/*
 close
 */
- (void)cameraViewClose;

/*
 switch
 */
- (void)cameraViewSwitch:(CALayer*)layer;

/*
 trigger
 */
- (void)cameraView:(UIView*)camera triggerFlashModel:(AVCaptureFlashMode)flashMode;

- (BOOL)cameraViewHasFocus;

- (void)cameraViewCaptureScale:(CGFloat)scaleNum;

- (CGFloat)cameraMaxScale;

@end

@protocol CTCameraViewControllerDelegate <NSObject>

@optional

- (void)camera:(id)controller didFinishWithImage:(UIImage*)image withMetadata:(NSDictionary*)metadata;

@end

@protocol CTPhotoEditControllerDelegate <NSObject>


@optional

- (void)photoEdit:(id)controller didFinishWithImage:(UIImage*)image withMetadata:(NSDictionary*)metadata;

@end