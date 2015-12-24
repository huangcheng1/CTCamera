//
//  CTMotionManager.m
//  Pods
//
//  Created by 黄成 on 15/12/22.
//
//

#import "CTMotionManager.h"
#import <CoreMotion/CoreMotion.h>

@interface CTMotionManager (){
    CMAccelerometerHandler _motionHandler;
}

@property (nonatomic,strong) CMMotionManager *motionManager;
@property (nonatomic,assign) UIDeviceOrientation deviceOrientation;

@end

@implementation CTMotionManager

+ (instancetype)sharedManager{
    static dispatch_once_t once;
    static CTMotionManager *shareObj;
    dispatch_once(&once, ^{
        shareObj = [[CTMotionManager alloc]init];
    });
    return shareObj;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        if ([self.motionManager isAccelerometerAvailable]) {
            [self.motionManager setAccelerometerUpdateInterval:0.2f];
        }else{
            [self deviceOrientationDidChangeTo:UIDeviceOrientationPortrait];
        }
    }
    return self;
}

- (void)startMotionHandler{
    __weak typeof(self) weakSelf = self;
    _motionHandler = ^ (CMAccelerometerData *accelerometerData,NSError *error){
        
        __strong typeof(self) selfBlock = weakSelf;
        
        CGFloat xx = accelerometerData.acceleration.x;
        CGFloat yy = -accelerometerData.acceleration.y;
        CGFloat zz = accelerometerData.acceleration.z;
        
        CGFloat device_angle = M_PI / 2.0f - atan2(yy, xx);
        UIDeviceOrientation orientation = UIDeviceOrientationUnknown;
        
        if (device_angle > M_PI)
            device_angle -= 2 * M_PI;
        
        if ((zz < -.60f) || (zz > .60f)) {
            if ( UIDeviceOrientationIsLandscape(selfBlock.deviceOrientation) )
                orientation = selfBlock.deviceOrientation;
            else
                orientation = UIDeviceOrientationUnknown;
        } else {
            if ( (device_angle > -M_PI_4) && (device_angle < M_PI_4) )
                orientation = UIDeviceOrientationPortrait;
            else if ((device_angle < -M_PI_4) && (device_angle > -3 * M_PI_4))
                orientation = UIDeviceOrientationLandscapeLeft;
            else if ((device_angle > M_PI_4) && (device_angle < 3 * M_PI_4))
                orientation = UIDeviceOrientationLandscapeRight;
            else
                orientation = UIDeviceOrientationPortraitUpsideDown;
        }
        
        if (orientation != selfBlock.deviceOrientation) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [selfBlock deviceOrientationDidChangeTo:orientation];
            });
        }

    };
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:_motionHandler];
}

- (void)stopMotionHandler{
    [self.motionManager stopAccelerometerUpdates];
}

- (void)deviceOrientationDidChangeTo:(UIDeviceOrientation)orientation{
    [self setDeviceOrientation:orientation];
    if (self.motionRotationHandler) {
        self.motionRotationHandler(self.deviceOrientation);
    }
}

#pragma mark - getter

- (CMMotionManager *)motionManager{
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc]init];
    }
    return _motionManager;
}

@end
