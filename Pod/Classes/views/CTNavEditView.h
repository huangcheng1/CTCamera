//
//  CTNavEditView.h
//  Pods
//
//  Created by 黄成 on 15/12/24.
//
//

/*
 * 返回，确定，等
 */

#import <UIKit/UIKit.h>

@protocol CTNavEditViewDelegate <NSObject>

@optional

- (void)didSelectedBack;
- (void)didSelectedFinish;

@end

@interface CTNavEditView : UIView

@property (nonatomic,weak) id<CTNavEditViewDelegate> delegate;

@end
