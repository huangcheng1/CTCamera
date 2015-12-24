//
//  CTCameraView.h
//  Pods
//
//  Created by 黄成 on 15/12/21.
//
//

/**
 * 相机
 */
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "CTCameraSettings.h"
#import "CTCameraDelegate.h"

@interface CTCameraView : UIView<CTCameraSettings>

@property (nonatomic,weak) id<CTCameraViewDelegate>delegate;

//取消按钮 cancel
@property (nonatomic, strong) UIButton *closeButton;

//切换前后相机 switch camera
@property (nonatomic, strong) UIButton *cameraButton;

//闪光灯 flash mode
@property (nonatomic, strong) UIButton *flashButton;

//照相 take shot
@property (nonatomic, strong) UIButton *triggerButton;

//预览 camera preview layer
@property (nonatomic, strong , readonly) AVCaptureVideoPreviewLayer *previewLayer;

//单击 single tap for focus
@property (nonatomic, strong , readonly) UITapGestureRecognizer *singleTap;

+ (id) initWithFrame:(CGRect)frame;

+ (CTCameraView *) initWithCaptureSession:(AVCaptureSession *)captureSession;

- (void)defaultInterface;

- (void)tranformViews:(CGFloat)rotation;
@end
