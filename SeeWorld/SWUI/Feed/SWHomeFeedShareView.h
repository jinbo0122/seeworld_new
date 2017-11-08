//
//  SWHomeFeedShareView.h
//  SeeWorld
//
//  Created by Albert Lee on 9/2/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^COMPLETION_BLOCK_WITH_IMAGE)(UIImage *image);
@interface SWHomeFeedShareView : UIView
@property(nonatomic, strong)COMPLETION_BLOCK reportBlock;
@property(nonatomic, strong)COMPLETION_BLOCK_WITH_IMAGE instaBlock;
@property(nonatomic, strong)COMPLETION_BLOCK_WITH_IMAGE fbBlock;
@property(nonatomic, strong)UIImage *shareImage;
- (void)show;
- (void)dismiss;
@end
