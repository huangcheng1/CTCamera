//
//  CTAllEditMenuView.h
//  Pods
//
//  Created by 黄成 on 15/12/24.
//
//

/*
 * 显示所有可以对图片的操作
 */

#import <UIKit/UIKit.h>

@protocol CTAllEditMenuViewDelegate <NSObject>

@optional

- (void)didSelectMosaic;

@end

@interface CTAllEditMenuView : UIView

@property (nonatomic,weak) id<CTAllEditMenuViewDelegate> delegate;

@end
