//
//  CTViewController.m
//  CTCamera
//
//  Created by root on 12/21/2015.
//  Copyright (c) 2015 root. All rights reserved.
//

#import "CTViewController.h"
#import "CTCameraViewController.h"
#import "CTEditPhotoViewController.h"
#import "UIViewController+FullScreen.h"
#import "CTCamera.h"

@interface CTViewController ()
{
    CTCamera *camera;
    UIImageView *imageview;
}

@end

@implementation CTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    imageview = [[UIImageView alloc]initWithFrame:CGRectMake(100, 200, 200, 200)];
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)click:(id)sender{
    camera = [[CTCamera alloc]init];
    [camera showCameraOn:self withResult:^(UIImage *image) {
        imageview.image = image;
    } withNeedEdit:YES];
}

- (void)editImage:(id)sender{
    camera = [[CTCamera alloc]init];
    [camera showCameraOn:self withResult:^(UIImage *image) {
        imageview.image = image;
    } withNeedEdit:NO];
//    [camera showPhotoEditWithImage:imageview.image OnViewController:self withResult:^(UIImage *image) {
//        imageview.image = image;
//    }];
}

@end
