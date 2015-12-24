//
//  CTMosaicEditView.m
//  Pods
//
//  Created by 黄成 on 15/12/24.
//
//

#import "CTMosaicEditView.h"
#import "Configuration.h"
#import "UIImage+TintColor.h"
#import "CTCameraStyle.h"

@interface CTMosaicEditView ()

@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIButton *lastBtn;
@property (nonatomic,strong) UIButton *nextBtn;
@property (nonatomic,strong) UIButton *commitBtn;

@end

@implementation CTMosaicEditView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.cancelBtn];
        [self addSubview:self.lastBtn];
        [self addSubview:self.nextBtn];
        [self addSubview:self.commitBtn];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat height = self.bounds.size.height;
    CGFloat centerX = self.bounds.size.width / 2;
    self.nextBtn.frame = CGRectMake(centerX + 16, (height - 32)/2, 32 + 40, 32);
    self.lastBtn.frame = CGRectMake(centerX - 16 - 32 - 40, (height - 32)/2, 32 + 40, 32);
    
    self.cancelBtn.frame = CGRectMake(16, ( height - 21 )/ 2, 21, 21);
    self.commitBtn.frame = CGRectMake(self.bounds.size.width - 30 - 16, (height - 21 ) / 2, 30, 21);
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    /*画两条线*/
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextSetLineWidth(context, 0.5);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    CGContextMoveToPoint(context, CGRectGetMaxX(self.cancelBtn.frame) + 16, 8);
    CGContextAddLineToPoint(context, CGRectGetMaxX(self.cancelBtn.frame) + 16, CGRectGetHeight(self.frame) - 8);
    
    CGContextMoveToPoint(context, CGRectGetMinX(self.commitBtn.frame) - 16, 8);
    CGContextAddLineToPoint(context, CGRectGetMinX(self.commitBtn.frame) - 16, CGRectGetHeight(self.frame) - 8);
    CGContextStrokePath(context);
}

- (void)reLastStep{
    if ([self.delegate respondsToSelector:@selector(hasLastMosaicOperation)]) {
        if ([self.delegate hasLastMosaicOperation] && [self.delegate respondsToSelector:@selector(lastMosaicOperation)]) {
            [self.delegate lastMosaicOperation];
        }
    }
}

- (void)nextStep{
    if ([self.delegate respondsToSelector:@selector(hasNextMosaicOperation)]) {
        if ([self.delegate hasNextMosaicOperation] && [self.delegate respondsToSelector:@selector(nextMosaicOperation)]) {
            [self.delegate nextMosaicOperation];
        }
    }
}

- (void)commitClick{
    if ([self.delegate respondsToSelector:@selector(commitMosaic)]) {
        [self.delegate commitMosaic];
    }
}

- (void)cancelClick{
    if ([self.delegate respondsToSelector:@selector(closeMosaic)]) {
        [self.delegate closeMosaic];
    }
}

- (UIButton *)lastBtn{
    if (!_lastBtn) {
        
        _lastBtn = [[UIButton alloc]init];
        [_lastBtn setTitle:CTCameraLoc(@"last_step") forState:UIControlStateNormal];
        [_lastBtn setTitleColor:[CTCameraStyle shareManager].tintColor forState:UIControlStateNormal];
        [_lastBtn setTitleColor:[CTCameraStyle shareManager].selectedTintColor forState:UIControlStateSelected];
        _lastBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_lastBtn setImage:[[UIImage imageNamed:CTCameraImage(@"ctcamera_publish_undo")] tintImageWithColor:[CTCameraStyle shareManager].tintColor] forState:UIControlStateNormal];
        [_lastBtn setImage:[[UIImage imageNamed:CTCameraImage(@"ctcamera_publish_undo")] tintImageWithColor:[CTCameraStyle shareManager].selectedTintColor] forState:UIControlStateSelected];
        [_lastBtn addTarget:self action:@selector(reLastStep) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _lastBtn;
}

- (UIButton *)nextBtn{
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc]init];
        [_nextBtn setTitle:CTCameraLoc(@"next_step") forState:UIControlStateNormal];
        _nextBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_nextBtn setTitleColor:[CTCameraStyle shareManager].tintColor forState:UIControlStateNormal];
        [_nextBtn setTitleColor:[CTCameraStyle shareManager].selectedTintColor forState:UIControlStateSelected];
        [_nextBtn setImage:[[UIImage imageNamed:CTCameraImage(@"ctcamera_publish_redo")] tintImageWithColor:[CTCameraStyle shareManager].tintColor] forState:UIControlStateNormal];
        [_nextBtn setImage:[[UIImage imageNamed:CTCameraImage(@"ctcamera_publish_redo")] tintImageWithColor:[CTCameraStyle shareManager].selectedTintColor] forState:UIControlStateSelected];
        [_nextBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
        [_nextBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -55, 0, 0)];
        [_nextBtn addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc]init];
        [_cancelBtn setImage:[[UIImage imageNamed:CTCameraImage(@"close")] tintImageWithColor:[CTCameraStyle shareManager].tintColor] forState:UIControlStateNormal];
        [_cancelBtn setImage:[[UIImage imageNamed:CTCameraImage(@"close")] tintImageWithColor:[CTCameraStyle shareManager].selectedTintColor] forState:UIControlStateSelected];
        [_cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)commitBtn{
    if (!_commitBtn) {
        _commitBtn = [[UIButton alloc]init];
        [_commitBtn setImage:[[UIImage imageNamed:CTCameraImage(@"ctcamera_publish_save")] tintImageWithColor:[CTCameraStyle shareManager].tintColor] forState:UIControlStateNormal];
        [_commitBtn setImage:[[UIImage imageNamed:CTCameraImage(@"ctcamera_publish_save")] tintImageWithColor:[CTCameraStyle shareManager].selectedTintColor] forState:UIControlStateSelected];
        [_commitBtn addTarget:self action:@selector(commitClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}
@end
