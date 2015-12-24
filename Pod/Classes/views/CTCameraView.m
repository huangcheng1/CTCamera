//
//  CTCameraView.m
//  Pods
//
//  Created by 黄成 on 15/12/21.
//
//

#import "CTCameraView.h"
#import "Configuration.h"
#import "UIImage+TintColor.h"
#import "CTCameraStyle.h"

#define previewFrame (CGRect){ 0, 44, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 138 }

@interface CTCameraView ()

@property (nonatomic, strong) CALayer *focusBox;
@property (nonatomic, strong) UIView *topContainerBar;
@property (nonatomic, strong) UIView *bottomContainerBar;

@end

@implementation CTCameraView

@synthesize tintColor = _tintColor;
@synthesize selectedTintColor = _selectedTintColor;

+ (id)initWithFrame:(CGRect)frame{
    return [[self alloc] initWithFrame:frame captureSession:nil];
}

+ (CTCameraView*)initWithCaptureSession:(AVCaptureSession*)captureSession{
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds captureSession:captureSession];
}

- (instancetype)initWithFrame:(CGRect)frame captureSession:(AVCaptureSession*)captureSession{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor blackColor]];
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc]init];
        if (captureSession) {
            [_previewLayer setSession:captureSession];
            [_previewLayer setFrame:previewFrame];
        }else{
            [_previewLayer setFrame:self.bounds];
        }
        
        if ([_previewLayer respondsToSelector:@selector(connection)]) {
            if ([_previewLayer.connection isVideoOrientationSupported]) {
                [_previewLayer.connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
            }
        }
        
        [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [self.layer addSublayer:_previewLayer];
    }
    return self;
}

- (void)defaultInterface{
    /*
     *  协议里面的参数，需要初始化完后加入
     *
     */
    self.tintColor = [CTCameraStyle shareManager].tintColor;
    self.selectedTintColor = [CTCameraStyle shareManager].selectedTintColor;
    
    UIView *focusView = [[UIView alloc] initWithFrame:self.frame];
    focusView.backgroundColor = [UIColor clearColor];
    [focusView.layer addSublayer:self.focusBox];
    [self addSubview:focusView];
    
    [self addSubview:self.topContainerBar];
    [self addSubview:self.bottomContainerBar];
    [self.topContainerBar addSubview:self.cameraButton];
    [self.topContainerBar addSubview:self.flashButton];
    
    [self.bottomContainerBar addSubview:self.triggerButton];
    [self.bottomContainerBar addSubview:self.closeButton];
    
    [self createGesture];
}

- (void)tranformViews:(CGFloat)rotation{
    [UIView animateWithDuration:0.2 animations:^{
        self.cameraButton.transform = CGAffineTransformMakeRotation(rotation);
        self.flashButton.transform = CGAffineTransformMakeRotation(rotation);
        self.triggerButton.transform = CGAffineTransformMakeRotation(rotation);
        self.closeButton.transform = CGAffineTransformMakeRotation(rotation);
    }];
}
- (void)createGesture{
    
    _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToFocus:)];
    [_singleTap setDelaysTouchesEnded:NO];
    [_singleTap setNumberOfTapsRequired:1];
    [_singleTap setNumberOfTouchesRequired:1];
    [self addGestureRecognizer:_singleTap];

}


#pragma mark - Actions

- (void) flashTriggerAction:(UIButton *)button
{
    if ( [_delegate respondsToSelector:@selector(cameraView:triggerFlashModel:)] ) {
        [button setSelected:!button.isSelected];
        [_delegate cameraView:self triggerFlashModel:button.isSelected ? AVCaptureFlashModeOn : AVCaptureFlashModeOff];
    }
}

- (void) changeCamera:(UIButton *)button
{
    [button setSelected:!button.isSelected];
    if ( button.isSelected && self.flashButton.isSelected )
        [self flashTriggerAction:self.flashButton];
    [self.flashButton setEnabled:!button.isSelected];
    if ( [self.delegate respondsToSelector:@selector(cameraViewSwitch:)] )
        [self.delegate cameraViewSwitch:_previewLayer];
}

- (void) close
{
    if ( [_delegate respondsToSelector:@selector(cameraViewClose)] )
        [_delegate cameraViewClose];
}

- (void) triggerAction:(UIButton *)button
{
    if ( [_delegate respondsToSelector:@selector(cameraViewStartRecording)] )
        [_delegate cameraViewStartRecording];
}

- (void) tapToFocus:(UIGestureRecognizer *)recognizer
{
    CGPoint tempPoint = (CGPoint)[recognizer locationInView:self];
    if ( [_delegate respondsToSelector:@selector(cameraView:focusAtPoint:)] && CGRectContainsPoint(_previewLayer.frame, tempPoint) ){
        [_delegate cameraView:self focusAtPoint:(CGPoint){ tempPoint.x, tempPoint.y - CGRectGetMinY(_previewLayer.frame) }];
        [self drawFocusBoxAtPointOfInterest:tempPoint andRemove:YES];
    }
    [self drawFocusBoxAtPointOfInterest:tempPoint andRemove:YES];
}
- (void) drawFocusBoxAtPointOfInterest:(CGPoint)point andRemove:(BOOL)remove
{
    [self draw:_focusBox atPointOfInterest:point andRemove:remove];
}

- (void) draw:(CALayer *)layer atPointOfInterest:(CGPoint)point andRemove:(BOOL)remove
{
    if ( remove )
        [layer removeAllAnimations];
    
    if ( [layer animationForKey:@"transform.scale"] == nil && [layer animationForKey:@"opacity"] == nil ) {
        [CATransaction begin];
        [CATransaction setValue: (id) kCFBooleanTrue forKey: kCATransactionDisableActions];
        [layer setPosition:point];
        [CATransaction commit];
        
        CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        [scale setFromValue:[NSNumber numberWithFloat:1]];
        [scale setToValue:[NSNumber numberWithFloat:0.7]];
        [scale setDuration:0.8];
        [scale setRemovedOnCompletion:YES];
        
        CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [opacity setFromValue:[NSNumber numberWithFloat:1]];
        [opacity setToValue:[NSNumber numberWithFloat:0]];
        [opacity setDuration:0.8];
        [opacity setRemovedOnCompletion:YES];
        
        [layer addAnimation:scale forKey:@"transform.scale"];
        [layer addAnimation:opacity forKey:@"opacity"];
    }
}


#pragma setter and getter

- (UIView *) topContainerBar
{
    if ( !_topContainerBar ) {
        _topContainerBar = [[UIView alloc] initWithFrame:(CGRect){ 0, 0, CGRectGetWidth(self.bounds), CGRectGetMinY(previewFrame) }];
        [_topContainerBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [_topContainerBar setBackgroundColor:RGBColor(0x000000, 1)];
    }
    return _topContainerBar;
}

- (UIView *) bottomContainerBar
{
    if ( !_bottomContainerBar ) {
        CGFloat newY = CGRectGetMaxY(previewFrame);
        _bottomContainerBar = [[UIView alloc] initWithFrame:(CGRect){ 0, newY, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - newY }];
        [_bottomContainerBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
        [_bottomContainerBar setUserInteractionEnabled:YES];
        [_bottomContainerBar setBackgroundColor:RGBColor(0x000000, 1)];
    }
    return _bottomContainerBar;
}

- (UIButton *)flashButton{
    if (!_flashButton) {
        _flashButton = [[UIButton alloc]init];
        [_flashButton setBackgroundColor:[UIColor clearColor]];
        [_flashButton setImage:[[UIImage imageNamed:CTCameraImage(@"flash")] tintImageWithColor:self.tintColor] forState:UIControlStateNormal];
        [_flashButton setImage:[[UIImage imageNamed:CTCameraImage(@"flash")] tintImageWithColor:self.selectedTintColor] forState:UIControlStateSelected];
        [_flashButton setFrame:CGRectMake(16, 8, 30, 30)];
        [_flashButton addTarget:self action:@selector(flashTriggerAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flashButton;
}

- (UIButton *)cameraButton{
    if (!_cameraButton) {
        
        _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraButton setBackgroundColor:[UIColor clearColor]];
        [_cameraButton setImage:[[UIImage imageNamed:CTCameraImage(@"flip")] tintImageWithColor:self.tintColor] forState:UIControlStateNormal];
        [_cameraButton setImage:[[UIImage imageNamed:CTCameraImage(@"flip")] tintImageWithColor:self.selectedTintColor] forState:UIControlStateHighlighted];
        [_cameraButton setFrame:(CGRect){ CGRectGetWidth(self.bounds) - 16 - 30, 8.0f, 30, 30 }];
        [_cameraButton addTarget:self action:@selector(changeCamera:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraButton;
}

- (UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setBackgroundColor:[UIColor clearColor]];
        [_closeButton setImage:[[UIImage imageNamed:CTCameraImage(@"close")] tintImageWithColor:self.tintColor] forState:UIControlStateNormal];
        [_closeButton setImage:[[UIImage imageNamed:CTCameraImage(@"close")] tintImageWithColor:self.selectedTintColor] forState:UIControlStateHighlighted];
        [_closeButton setFrame:(CGRect){ 16,  CGRectGetMidY(self.bottomContainerBar.bounds) - 15, 30, 30 }];
        [_closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIButton *)triggerButton{
    if ( !_triggerButton ) {
        _triggerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_triggerButton setBackgroundColor:self.tintColor];
        [_triggerButton setImage:[UIImage imageNamed:CTCameraImage(@"trigger")] forState:UIControlStateNormal];
        [_triggerButton setImage:[[UIImage imageNamed:CTCameraImage(@"trigger")] tintImageWithColor:self.selectedTintColor] forState:UIControlStateHighlighted];
        [_triggerButton setFrame:(CGRect){ 0, 0, 66, 66 }];
        [_triggerButton.layer setCornerRadius:33.0f];
        [_triggerButton setCenter:(CGPoint){ CGRectGetMidX(self.bottomContainerBar.bounds), CGRectGetMidY(self.bottomContainerBar.bounds) }];
        [_triggerButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
        [_triggerButton addTarget:self action:@selector(triggerAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _triggerButton;
}
- (CALayer *) focusBox
{
    if ( !_focusBox ) {
        _focusBox = [[CALayer alloc] init];
        [_focusBox setCornerRadius:45.0f];
        [_focusBox setBounds:CGRectMake(0.0f, 0.0f, 90, 90)];
        [_focusBox setBorderWidth:5.f];
        [_focusBox setBorderColor:[RGBColor(0xffffff, 1) CGColor]];
        [_focusBox setOpacity:0];
    }
    
    return _focusBox;
}

@end
