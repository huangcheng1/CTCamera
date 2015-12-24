//
//  CTEditTitleView.m
//  Pods
//
//  Created by 黄成 on 15/12/24.
//
//

#import "CTEditTitleView.h"
#import "CTCameraStyle.h"

@interface CTEditTitleView ()

@property (nonatomic,strong) UILabel *label;

@end

@implementation CTEditTitleView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self addSubview:self.label];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.label.frame = CGRectMake(self.frame.size.width / 4, (self.frame.size.height - 30 )/2, self.frame.size.width/2, 30);
}

- (void)packageWithStr:(NSString *)str{
    self.label.text = str;
}

- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.font = [UIFont systemFontOfSize:16.0];
        _label.textColor = [CTCameraStyle shareManager].tintColor;
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}
@end
