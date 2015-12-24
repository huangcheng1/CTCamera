//
//  CTEditView.h
//  Pods
//
//  Created by 黄成 on 15/12/22.
//
//

/*
 * 显示image
 */
#import <UIKit/UIKit.h>

@interface CTEditView : UIView

- (instancetype)initWithImage:(UIImage*)image withFrame:(CGRect)frame;

- (void)packageWithImage:(UIImage*)image;

- (BOOL)hasNextStep;//是否有下一步
- (void)nextStep;//下一步

- (BOOL)hasLastStep;//是否有上一步
- (void)lastStep;//上一步

- (void)removeAllSubLayerOnView;

- (UIImage*)getFinalImage;

- (void)setCanEdit:(BOOL)canEdit;

@end
