//
//  CTMotionManager.h
//  Pods
//
//  Created by 黄成 on 15/12/22.
//
//

#import <Foundation/Foundation.h>

typedef void (^CTMotionManagerRotationHandler)(UIDeviceOrientation);

@interface CTMotionManager : NSObject

@property (nonatomic,copy) CTMotionManagerRotationHandler motionRotationHandler;

+ (instancetype)sharedManager;

- (void)startMotionHandler;
- (void)stopMotionHandler;

@end
