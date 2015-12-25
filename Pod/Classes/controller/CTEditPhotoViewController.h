//
//  CTEditPhotoViewController.h
//  Pods
//
//  Created by 黄成 on 15/12/22.
//
//

#import <UIKit/UIKit.h>
#import "CTCameraSettings.h"
#import "CTCameraDelegate.h"

@interface CTEditPhotoViewController : UIViewController<CTCameraSettings>

@property (nonatomic,weak) id<CTPhotoEditControllerDelegate> delegate;
@property (nonatomic, strong) NSDictionary *capturedImageMetadata;
@property (nonatomic,strong) UIImage *image;

- (instancetype)initWithImage:(UIImage*)image;

@end
