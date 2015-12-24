//
//  CTCameraStyle.m
//  Pods
//
//  Created by 黄成 on 15/12/24.
//
//

#import "CTCameraStyle.h"

@implementation CTCameraStyle

+ (instancetype)shareManager{
    static dispatch_once_t once;
    static CTCameraStyle *shareObj;
    dispatch_once(&once, ^{
        shareObj = [[CTCameraStyle alloc]init];
    });
    return shareObj;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.tintColor = [UIColor whiteColor];
        self.selectedTintColor = [UIColor redColor];
    }
    return self;
}
@end
