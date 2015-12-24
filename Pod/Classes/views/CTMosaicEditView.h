//
//  CTMosaicEditView.h
//  Pods
//
//  Created by 黄成 on 15/12/24.
//
//

/**
 * 控制马赛克的view
 */

#import <UIKit/UIKit.h>

@protocol CTMosaicEditViewDelegate <NSObject>

@optional

- (void)closeMosaic;
- (void)commitMosaic;
- (void)nextMosaicOperation;
- (void)lastMosaicOperation;
- (BOOL)hasNextMosaicOperation;
- (BOOL)hasLastMosaicOperation;

@end

@interface CTMosaicEditView : UIView

@property (nonatomic,weak) id<CTMosaicEditViewDelegate>delegate;

@end
