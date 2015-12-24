//
//  CTEditPhotoViewController.m
//  Pods
//
//  Created by 黄成 on 15/12/22.
//
//

#import "CTEditPhotoViewController.h"
#import "UIViewController+FullScreen.h"
#import "GPUImageMosaicFilter.h"
#import "GPUImageBrightnessFilter.h"
#import "GPUImageView.h"
#import <CoreImage/CoreImage.h>
#import "CTEditView.h"
#import "Configuration.h"
#import "CTMosaicEditView.h"
#import "CTEditTitleView.h"
#import "CTAllEditMenuView.h"
#import "CTNavEditView.h"

@interface CTEditPhotoViewController ()<CTMosaicEditViewDelegate,CTAllEditMenuViewDelegate,CTNavEditViewDelegate>

@property (nonatomic,strong) CTEditView *imageView;
@property (nonatomic,strong) CTMosaicEditView *mosaicView;
@property (nonatomic,strong) CTEditTitleView *titleView;
@property (nonatomic,strong) CTAllEditMenuView *allEditMenu;
@property (nonatomic,strong) CTNavEditView *navTitleView;

@property (nonatomic,strong) UIImage *editImage;

@end

@implementation CTEditPhotoViewController

@synthesize tintColor = _tintColor;
@synthesize selectedTintColor = _selectedTintColor;

- (instancetype)initWithImage:(UIImage *)image{
    self = [super init];
    if (self) {
        self.image = image;
        self.editImage = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:19/255.0 green:19/255.0 blue:19/255.0 alpha:1.0];
    [self setFullScreenMode];
    [self.view addSubview:self.navTitleView];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.allEditMenu];
    [self.view addSubview:self.mosaicView];
    [self.view addSubview:self.titleView];
    
    self.allEditMenu.frame = CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44);
    self.navTitleView.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    
    self.mosaicView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 44);
    self.titleView.frame = CGRectMake(0, -44, self.view.frame.size.width, 44);
}



- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}

- (void)reLastStep{
    if ([self.imageView hasLastStep]) {
        [self.imageView lastStep];
    }
}

- (void)nextStep{
    if ([self.imageView hasNextStep]) {
        [self.imageView nextStep];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Titile Nav Delegate

- (void)didSelectedBack{
    if (self.navigationController && self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didSelectedFinish{
    if ([self.delegate respondsToSelector:@selector(photoEdit:didFinishWithImage:withMetadata:)]) {
        [self.delegate photoEdit:self didFinishWithImage:self.editImage withMetadata:self.capturedImageMetadata?:nil];
    }
}

#pragma mark - AllEdit Delegate

- (void)didSelectMosaic{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.allEditMenu.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 44);
        self.navTitleView.frame = CGRectMake(0, -44, self.view.frame.size.width, 44);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.mosaicView.frame = CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44);
            self.titleView.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
        } completion:^(BOOL finished) {
            if (finished) {
                [self.imageView setCanEdit:YES];
            }
        }];
    }];
}

#pragma mark - mosaic Delegate

- (BOOL)hasNextMosaicOperation{
    return [self.imageView hasNextStep];
}

- (BOOL)hasLastMosaicOperation{
    return [self.imageView hasLastStep];
}

- (void)nextMosaicOperation{
    [self.imageView nextStep];
}

- (void)lastMosaicOperation{
    [self.imageView lastStep];
}

- (void)closeMosaic{
    [self.imageView removeAllSubLayerOnView];
    [self closeMosaicView];
}

- (void)commitMosaic{
    UIImage *image = [self.imageView getFinalImage];
    self.editImage = image;
    [self.imageView packageWithImage:image];
    [self closeMosaicView];
}

- (void)closeMosaicView{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.mosaicView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 44);
        self.titleView.frame = CGRectMake(0, -44, self.view.frame.size.width, 44);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.allEditMenu.frame = CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44);
            self.navTitleView.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
        } completion:^(BOOL finished) {
            if (finished) {
                [self.imageView setCanEdit:NO];
            }
        }];
    }];
}
#pragma mark getter and setter

- (CTEditView *)imageView{
    if (!_imageView) {
        _imageView = [[CTEditView alloc]initWithImage:self.image withFrame:CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height - 44 * 2)];
    }
    return _imageView;
}

- (CTMosaicEditView *)mosaicView{
    if (!_mosaicView) {
        _mosaicView = [[CTMosaicEditView alloc]init];
        _mosaicView.delegate = self;
    }
    return _mosaicView;
}

- (CTEditTitleView *)titleView{
    if (!_titleView) {
        _titleView = [[CTEditTitleView alloc]init];
        [_titleView packageWithStr:CTCameraLoc(@"mosaic_image")];
    }
    return _titleView;
}

- (CTAllEditMenuView *)allEditMenu{
    if (!_allEditMenu) {
        _allEditMenu = [[CTAllEditMenuView alloc]init];
        _allEditMenu.delegate = self;
    }
    return _allEditMenu;
}

- (CTNavEditView *)navTitleView{
    if (!_navTitleView) {
        _navTitleView = [[CTNavEditView alloc]init];
        _navTitleView.delegate = self;
    }
    return _navTitleView;
}

- (void)setImage:(UIImage *)image{
    if (image) {
        _image = image;
        _editImage = image;
    }
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}
@end
