//
//  CTNavEditView.m
//  Pods
//
//  Created by 黄成 on 15/12/24.
//
//

#import "CTNavEditView.h"
#import "Configuration.h"
#import "UIImage+TintColor.h"
#import "CTCameraStyle.h"

@interface CTNavEditView ()

@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) UIButton *finishBtn;

@end

@implementation CTNavEditView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self addSubview:self.backBtn];
        [self addSubview:self.finishBtn];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.backBtn.frame = CGRectMake(16, ( self.bounds.size.height - 22 )/2, 22, 22);
    self.finishBtn.frame = CGRectMake(self.bounds.size.width - 16 - 50, ( self.bounds.size.height - 22 )/2, 50, 22);
}

- (void)didSelectedFinish:(id)sender{
    if ([self.delegate respondsToSelector:@selector(didSelectedFinish)]) {
        [self.delegate didSelectedFinish];
    }
}

- (void)didSelectedBack:(id)sender{
    if ([self.delegate respondsToSelector:@selector(didSelectedBack)]) {
        [self.delegate didSelectedBack];
    }
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc]init];
        [_backBtn setImage:[[UIImage imageNamed:CTCameraImage(@"ctcamera_back")] tintImageWithColor:[CTCameraStyle shareManager].tintColor] forState:UIControlStateNormal];
        [_backBtn setImage:[[UIImage imageNamed:CTCameraImage(@"ctcamera_back")] tintImageWithColor:[CTCameraStyle shareManager].selectedTintColor] forState:UIControlStateSelected];
        [_backBtn addTarget:self action:@selector(didSelectedBack:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIButton *)finishBtn{
    if (!_finishBtn) {
        _finishBtn = [[UIButton alloc]init];
        [_finishBtn setTitle:CTCameraLoc(@"finish") forState:UIControlStateNormal];
        [_finishBtn setBackgroundImage:[UIImage createImageWithColor:[CTCameraStyle shareManager].selectedTintColor] forState:UIControlStateNormal];
        _finishBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _finishBtn.layer.masksToBounds = YES;
        _finishBtn.layer.cornerRadius = 4;
        [_finishBtn addTarget:self action:@selector(didSelectedFinish:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishBtn;
}
@end
