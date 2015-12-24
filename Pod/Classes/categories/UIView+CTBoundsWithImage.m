//
//  UIView+CTBoundsWithImage.m
//  Pods
//
//  Created by 黄成 on 15/12/23.
//
//

#import "UIView+CTBoundsWithImage.h"

@implementation UIView (CTBoundsWithImage)

- (CGRect)getBoundsWithImage:(UIImage*)image{
    
    CGSize size = self.frame.size;
    CGSize toSize = image.size;
    
    UIImage *newImage;
    //按照宽度缩放
    CGFloat zoom = size.width / toSize.width;
    
    if (size.height > toSize.height * zoom ) {//高度大于要显示的区域
        return CGRectMake(0, 0, size.width, toSize.height * zoom);
    }else if (size.height / zoom <= toSize.height){//高度小于要显示区域，,太长截取
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0, 0, size.width,size.height)];
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        image = scaledImage;

        return CGRectMake(0, 0, size.width, size.height);
    }else{
        return CGRectMake(0, 0, size.width, size.height);
    }

}

@end
