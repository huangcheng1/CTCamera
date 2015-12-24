//
//  CTCameraManager.h
//  Pods
//
//  Created by 黄成 on 15/12/21.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol CTCameraManagerDelegate <NSObject>

@optional
/**
 *  This method indicates when the capture session has captured an image
 *
 *  @param image    The captured image
 *  @param metadata The metadata of the image
 */
- (void) captureImageDidFinish:(UIImage *)image withMetadata:(NSDictionary *)metadata;

/**
 *  This method indicates when the capture session has an error
 *
 *  @param error The error of the capture session
 */
- (void) captureImageFailedWithError:(NSError *)error;

/**
 *  This method indicates an error during the toggle action of the camera
 *
 *  @param error The error
 */
- (void) someOtherError:(NSError *)error;

/**
 *  During the requests exclusive access to the device’s hardware properties, this method indicates if a lock cannot be acquired
 *
 *  @param error The error
 */
- (void) acquiringDeviceLockFailedWithError:(NSError *)error;

/**
 *  This method indicates when the capture session did start
 */
- (void) captureSessionDidStartRunning;


@end

@interface CTCameraManager : NSObject

@property (nonatomic,weak) id<CTCameraManagerDelegate> delegate;

//捕获 capture session
@property (nonatomic,readonly,strong) AVCaptureSession *captureSession;

//摄像头输出  video input
@property (nonatomic,readonly,strong) AVCaptureDeviceInput *videoInput;

//闪光的状态 flash on or off or auto
@property (nonatomic,assign) AVCaptureFlashMode flashMode;

//torch mode
@property (nonatomic,assign) AVCaptureTorchMode torchMode;

//焦点的模式 focus mode
@property (nonatomic,assign) AVCaptureFocusMode focusMode;

//曝光模式 exposure mode
@property (nonatomic,assign) AVCaptureExposureMode exposureMode;

//白平衡 whiteBalanceMode
@property (nonatomic,assign) AVCaptureWhiteBalanceMode whiteBalanceMode;

//camera count
@property (nonatomic,assign,readonly) NSUInteger cameraCount;


/*
 *设置最大缩放程度 max scale
 */
- (void)setCameraMaxScale:(CGFloat)maxScale;

/*
 *获取最大缩放程度 max scale
 */
- (CGFloat)cameraMaxScale;

/*
 *切换镜头，前后，返回成功失败
 */
- (BOOL)cameraToggle;

/*
 *是否有前后镜头
 */
- (BOOL)hasMutipleCameras;

/*
 *是否有闪光
 */
- (BOOL)hasFlash;

/*
 *是否有火炬
 */
- (BOOL)hasTorch;

/*
 *是否有焦点
 */
- (BOOL)hasFocus;

/*
 *是否有曝光
 */
- (BOOL)hasExposure;

/*
 * 是否有白平衡
 */
- (BOOL)hasWhiteBalance;

/*
 * session  预设
 */
- (BOOL)setupSessionWithPreset:(NSString*)sessionPreset error:(NSError**)error;

/*
 * 开始记录
 */
- (void)startRunning;

/*
 * 结束
 */
- (void)stopRunning;

/*
 *设置image的方向
 */
- (void)captureImageForDeviceOrientation:(UIDeviceOrientation)deviceOrientation;

/*
 *聚焦
 */
- (void)focustAtPoint:(CGPoint)point;

/*
 *曝光
 */
- (void)exposureAtPoint:(CGPoint)point;


/**
 *  Convert the touch in point to use for the focus or exposure
 *
 *  @param frame           The target frame
 *  @param viewCoordinates The touch coordinates
 *  @param layer           The used AVCaptureVideoPreviewLayer
 *
 *  @return Return the converted CGPoint
 */
- (CGPoint)convertToPointOfInterestFrom:(CGRect)frame coordinates:(CGPoint)viewCoordinates layer:(AVCaptureVideoPreviewLayer*)layer;

@end

