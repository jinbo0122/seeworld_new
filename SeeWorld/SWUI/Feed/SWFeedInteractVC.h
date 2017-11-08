//
//  SWFeedInteractVC.h
//  SeeWorld
//
//  Created by Albert Lee on 9/2/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "ALBaseVC.h"
#import "SWFeedInteractModel.h"
typedef enum : NSUInteger {
  SWFeedInteractIndexComments = 0,
  SWFeedInteractIndexLikes = 1,
} SWFeedInteractIndex;

@protocol SWFeedInteractVCDelegate;
@interface SWFeedInteractVC : ALBaseVC
@property(nonatomic,   weak)id<SWFeedInteractVCDelegate>delegate;
@property(nonatomic, assign)BOOL      isModal;
@property(nonatomic, assign)SWFeedInteractIndex defaultIndex;
@property(nonatomic, assign)NSInteger feedRow;
@property(nonatomic, strong)SWFeedInteractModel *model;
- (BOOL)isMyPic;
@end

@protocol SWFeedInteractVCDelegate <NSObject>

- (void)feedInteractVCDidDismiss:(SWFeedInteractVC *)vc row:(NSInteger)row likes:(NSMutableArray *)likes comments:(NSMutableArray *)comments;

@end