//
//  CTCameraViewController.m
//  Pods
//
//  Created by 黄成 on 15/12/21.
//
//

#import "CTCameraViewController.h"
#import "Configuration.h"
#import "CTMotionManager.h"
#import "CTCameraStyle.h"

@interface CTCameraViewController ()<CTCameraManagerDelegate,CTCameraViewDelegate>{
    BOOL _isProcessingPhoto;
    UIDeviceOrientation _deviceOrientation;
}

@end

@implementation CTCameraViewController

@synthesize tintColor = _tintColor;
@synthesize selectedTintColor = _selectedTintColor;

+ (instancetype) initWithDelegate:(id<CTCameraViewControllerDelegate>)delegate
{
    return [[self alloc] initWithDelegate:delegate cameraView:nil];
}

+ (instancetype) init
{
    return [[self alloc] initWithDelegate:nil cameraView:nil];
}

- (instancetype) initWithDelegate:(id<CTCameraViewControllerDelegate>)delegate cameraView:(id)camera
{
    self = [super init];
    
    if ( self ) {
        _isProcessingPhoto = NO;
        if ( delegate )
            _delegate = delegate;
        
//        if ( camera )
//            [self setCustomCamera:camera];
//        
//        [self setUseCameraSegue:YES];
        
        [self setTintColor:[CTCameraStyle shareManager].tintColor];
        [self setSelectedTintColor:[CTCameraStyle shareManager].selectedTintColor];
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSError *error;
    if ([self.cameraManager setupSessionWithPreset:AVCaptureSessionPresetPhoto error:&error]) {
        [self.view addSubview:self.cameraView];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if([self.cameraManager respondsToSelector:@selector(startRunning)]){
        [self.cameraManager startRunning];
    }
    __weak typeof(self) weakSelf = self;
    [[CTMotionManager sharedManager]setMotionRotationHandler:^(UIDeviceOrientation orientation){
        [weakSelf rotationChanged:orientation];
    }];
    [[CTMotionManager sharedManager]startMotionHandler];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[CTMotionManager sharedManager]stopMotionHandler];
    if ([self.cameraManager respondsToSelector:@selector(stopRunning)]) {
        [self.cameraManager stopRunning];
    }
}
- (BOOL) prefersStatusBarHidden
{
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rotationChanged:(UIDeviceOrientation)deviceOrientation{
    if (deviceOrientation != UIDeviceOrientationUnknown || deviceOrientation!= UIDeviceOrientationFaceUp || deviceOrientation != UIDeviceOrientationFaceDown) {
        _deviceOrientation = deviceOrientation;
    }
    /*
     让图标或者控件旋转
     */
    CGFloat rotation = 0.0;
    switch (deviceOrientation) {
        case UIDeviceOrientationLandscapeLeft:
            rotation = 90 * M_PI / 180.0;
            break;
        case UIDeviceOrientationLandscapeRight:
            rotation = -90 * M_PI / 180.0;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            rotation = 180 * M_PI / 180.0;
            break;
        default:
            rotation = 0.0;
            break;
    }
    [self.cameraView tranformViews:rotation];
    
}

#pragma mark - CTCameraManagerDelegate


- (void) captureImageDidFinish:(UIImage *)image withMetadata:(NSDictionary *)metadata{
    _isProcessingPhoto = NO;
    if ([self.delegate respondsToSelector:@selector(camera:didFinishWithImage:withMetadata:)]) {
        [self.delegate camera:self didFinishWithImage:image withMetadata:metadata];
    }
}

- (void) captureImageFailedWithError:(NSError *)error{
    _isProcessingPhoto = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc]initWithTitle:CTCameraLoc(@"errortitle") message:error.localizedDescription delegate:nil cancelButtonTitle:CTCameraLoc(@"sure") otherButtonTitles:nil, nil] show];
    });
}

- (void) someOtherError:(NSError *)error{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc]initWithTitle:CTCameraLoc(@"errortitle") message:error.localizedDescription delegate:nil cancelButtonTitle:CTCameraLoc(@"sure") otherButtonTitles:nil, nil] show];
    });
}

- (void) acquiringDeviceLockFailedWithError:(NSError *)error{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc]initWithTitle:CTCameraLoc(@"errortitle") message:CTCameraLoc(@"acquiringdevicelock") delegate:nil cancelButtonTitle:CTCameraLoc(@"sure") otherButtonTitles:nil, nil] show];
    });
}

- (void) captureSessionDidStartRunning{
    NSLog(CTCameraLoc(@"running"));
}

#pragma mark - CTCameraViewDelegate
- (CGFloat)cameraMaxScale{
    return [self.cameraManager cameraMaxScale];
}

- (void)cameraView:(UIView *)camera triggerFlashModel:(AVCaptureFlashMode)flashMode{
    if ([self.cameraManager hasFlash]) {
        [self.cameraManager setFlashMode:flashMode];
    }
}

- (void)cameraViewCaptureScale:(CGFloat)scaleNum{
    [self.cameraManager setCameraMaxScale:scaleNum];
}

- (void)cameraViewClose{
    if(self.navigationController && self.navigationController.viewControllers.count > 1){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (BOOL)cameraViewHasFocus{
    return self.cameraManager.hasFocus;
}

- (void)cameraViewSwitch:(CALayer *)layer{
    if ( [self.cameraManager hasMutipleCameras] ) {
        
        /*
         做个翻转动画
         */
        CATransform3D rotationanimation = CATransform3DMakeRotation(M_PI, 0, 1, 0);
        rotationanimation.m34 = - 1.0 / 1000.0;
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        animation.toValue = [NSValue valueWithCATransform3D:rotationanimation];
        animation.delegate = self;
        animation.duration = 1.0;
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = YES;
        [layer addAnimation:animation forKey:nil];
        
        [self.cameraManager cameraToggle];
    }
}

- (void)cameraView:(UIView *)cameraView exposureAtPoint:(CGPoint)point{
    if (self.cameraManager.videoInput.device.isExposurePointOfInterestSupported) {
        [self.cameraManager exposureAtPoint:[self.cameraManager convertToPointOfInterestFrom:[[(CTCameraView*)cameraView previewLayer] frame] coordinates:point layer:[(CTCameraView*)cameraView previewLayer]]];
    }
}

- (void)cameraView:(UIView *)cameraView focusAtPoint:(CGPoint)point{
    if (self.cameraManager.videoInput.device.isFocusPointOfInterestSupported) {
        [self.cameraManager focustAtPoint:[self.cameraManager convertToPointOfInterestFrom:[[(CTCameraView*)cameraView previewLayer] frame] coordinates:point layer:[(CTCameraView*)cameraView previewLayer]]];
    }
}

- (void)cameraViewStartRecording{
    if (_isProcessingPhoto) {
        return;
    }
    _isProcessingPhoto = YES;
    if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_7_0) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted) {
            [[[UIAlertView alloc]initWithTitle:CTCameraLoc(@"errortitle") message:CTCameraLoc(@"nopolicy") delegate:nil cancelButtonTitle:CTCameraLoc(@"cancel") otherButtonTitles:nil, nil] show];
            return;
        }
        else if (status == AVAuthorizationStatusNotDetermined){
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:nil];
            return;
        }
    }
    [self.cameraManager captureImageForDeviceOrientation:_deviceOrientation];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        //finish
    }
}


#pragma mark - getter and setter

- (CTCameraView *) cameraView
{
    if ( !_cameraView ) {
        _cameraView = [CTCameraView initWithCaptureSession:self.cameraManager.captureSession];
        [_cameraView setTintColor:self.tintColor];
        [_cameraView setSelectedTintColor:self.selectedTintColor];
        [_cameraView defaultInterface];
        [_cameraView setDelegate:self];
    }
    
    return _cameraView;
}

- (CTCameraManager *)cameraManager{
    if (!_cameraManager) {
        _cameraManager = [[CTCameraManager alloc]init];
        _cameraManager.delegate = self;
    }
    return _cameraManager;
}
@end
