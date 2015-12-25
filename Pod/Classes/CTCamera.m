//
//  CTCamera.m
//  Pods
//
//  Created by 黄成 on 15/12/24.
//
//

#import "CTCamera.h"
#import "CTCameraStyle.h"
#import "CTCameraNavViewController.h"
#import "CTCameraViewController.h"
#import "CTEditPhotoViewController.h"
#import "Configuration.h"

@interface CTCamera ()<CTCameraViewControllerDelegate,CTPhotoEditControllerDelegate>

@property (nonatomic,copy) ResultImage result;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,assign) BOOL showEdit;
@property (nonatomic,assign) BOOL shouldSave;

@property (nonatomic,strong) CTCameraViewController *cameraVC;
@property (nonatomic,strong) CTEditPhotoViewController *editVC;
@property (nonatomic,strong) CTCameraNavViewController *navCtr;

@end

@implementation CTCamera

- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)showCameraOn:(UIViewController*)ctr withResult:(ResultImage)result{
    [self showCameraOn:ctr withResult:result withNeedEdit:YES];
}

- (void)showCameraOn:(UIViewController*)ctr withResult:(ResultImage)result withNeedEdit:(BOOL)needEdit{
    [self showCameraOn:ctr withResult:result withNeedEdit:needEdit save:YES];
}

- (void)showCameraOn:(UIViewController*)ctr withResult:(ResultImage)result withNeedEdit:(BOOL)needEdit save:(BOOL)shouldSave{
    self.shouldSave = shouldSave;
    self.result = result;
    self.showEdit = needEdit;
    self.navCtr = [[CTCameraNavViewController alloc]initWithRootViewController:self.cameraVC];
    [self.navCtr.navigationBar setHidden:YES];
    [ctr presentViewController:self.navCtr animated:YES completion:nil];
}

- (void)showPhotoEditWithImage:(UIImage*)image OnViewController:(UIViewController*)ctr withResult:(ResultImage)result{
    [self showPhotoEditWithImage:image OnViewController:ctr withResult:result save:YES];
}

- (void)showPhotoEditWithImage:(UIImage*)image OnViewController:(UIViewController*)ctr withResult:(ResultImage)result save:(BOOL)shouldSave{
    self.shouldSave = shouldSave;
    self.result = result;
    self.image = image;
    self.editVC.image = image;
    self.navCtr = [[CTCameraNavViewController alloc]initWithRootViewController:self.editVC];
    [self.navCtr.navigationBar setHidden:YES];
    [ctr presentViewController:self.navCtr animated:YES completion:nil];
}

- (void)setTintColor:(UIColor*)tintColor{
    [CTCameraStyle shareManager].tintColor = tintColor;
}
- (void)setSelectedTintColor:(UIColor*)selectedTintColor{
    [CTCameraStyle shareManager].selectedTintColor = selectedTintColor;
}

#pragma mark - getImage

- (void)camera:(id)controller didFinishWithImage:(UIImage *)image withMetadata:(NSDictionary *)metadata{
    
    if (self.showEdit) {
        self.editVC = [[CTEditPhotoViewController alloc]init];
        self.editVC.delegate = self;
        self.editVC.image = image;
        self.editVC.capturedImageMetadata = metadata;
        [self.navCtr pushViewController:self.editVC animated:YES];
    }else{
        if (self.result) {
            self.result(image);
        }
        [self writeImageToAlbum:image];
        [controller dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)photoEdit:(id)controller didFinishWithImage:(UIImage *)image withMetadata:(NSDictionary *)metadata{
    if (self.result) {
        self.result(image);
    }
    [self writeImageToAlbum:image];
    [controller dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -  写入相册
- (void)writeImageToAlbum:(UIImage*)image{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    });
}

//fail
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error) {
            NSLog(CTCameraLoc(@"save_image_error"));
        }
    });
}

#pragma mark - getter and setter

- (CTCameraViewController *)cameraVC{
    if (!_cameraVC) {
        _cameraVC = [[CTCameraViewController alloc]init];
        _cameraVC.delegate = self;
    }
    return _cameraVC;
}

- (CTEditPhotoViewController *)editVC{
    if (!_editVC) {
        _editVC = [[CTEditPhotoViewController alloc]init];
        _editVC.delegate = self;
    }
    return _editVC;
}
@end
