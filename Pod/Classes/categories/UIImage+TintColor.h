//
//  UIImage+TintColor.h
//  Pods
//
//  Created by 黄成 on 15/12/21.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (TintColor)

- (UIImage*)tintImageWithColor:(UIColor*)tintColor;

+ (UIImage*)createImageWithColor:(UIColor*)color;

@end
