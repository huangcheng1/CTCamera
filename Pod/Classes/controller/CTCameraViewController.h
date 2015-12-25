//
//  CTCameraViewController.h
//  Pods
//
//  Created by 黄成 on 15/12/21.
//
//

#import <UIKit/UIKit.h>
#import "CTCameraSettings.h"
#import "CTCameraView.h"
#import "CTCameraDelegate.h"
#import "CTCameraManager.h"
#import "UIViewController+FullScreen.h"

@interface CTCameraViewController : UIViewController<CTCameraSettings>

@property (nonatomic,weak) id<CTCameraViewControllerDelegate> delegate;

@property (nonatomic,strong) CTCameraView *cameraView;

@property (nonatomic,strong) CTCameraManager *cameraManager;

@end
