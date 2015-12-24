//
//  CTCameraStyle.h
//  Pods
//
//  Created by 黄成 on 15/12/24.
//
//

#import <Foundation/Foundation.h>

@interface CTCameraStyle : NSObject

@property (nonatomic,strong) UIColor *tintColor;
@property (nonatomic,strong) UIColor *selectedTintColor;

+ (instancetype)shareManager;

@end
