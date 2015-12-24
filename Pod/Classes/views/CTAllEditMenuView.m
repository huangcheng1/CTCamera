//
//  CTAllEditMenuView.m
//  Pods
//
//  Created by 黄成 on 15/12/24.
//
//

#import "CTAllEditMenuView.h"
#import "Configuration.h"
#import "UIImage+TintColor.h"
#import "CTCameraStyle.h"

@interface CTAllEditMenuView ()

@property (nonatomic,strong) UIButton *mosaicBtn;

@end

@implementation CTAllEditMenuView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.mosaicBtn];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.mosaicBtn.frame = CGRectMake(16, (self.frame.size.height - 40)/2, 50, 40);
}
#pragma mark - action

- (void)clickMosaic:(id)sender{
    if ([self.delegate respondsToSelector:@selector(didSelectMosaic)]) {
        [self.delegate didSelectMosaic];
    }
}

- (UIButton *)mosaicBtn{
    if (!_mosaicBtn) {
        _mosaicBtn = [[UIButton alloc]init];
        [_mosaicBtn setTitle:CTCameraLoc(@"mosaic_image") forState:UIControlStateNormal];
        [_mosaicBtn setTitleColor:[CTCameraStyle shareManager].tintColor forState:UIControlStateNormal];
        [_mosaicBtn setTitleColor:[CTCameraStyle shareManager].selectedTintColor forState:UIControlStateSelected];
        _mosaicBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_mosaicBtn setImage:[[UIImage imageNamed:CTCameraImage(@"ct_camera_masico_press")] tintImageWithColor:[CTCameraStyle shareManager].tintColor] forState:UIControlStateNormal];
        [_mosaicBtn setImage:[[UIImage imageNamed:CTCameraImage(@"ct_camera_masico_press")] tintImageWithColor:[CTCameraStyle shareManager].selectedTintColor] forState:UIControlStateSelected];
        [_mosaicBtn addTarget:self action:@selector(clickMosaic:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mosaicBtn;
}

@end
