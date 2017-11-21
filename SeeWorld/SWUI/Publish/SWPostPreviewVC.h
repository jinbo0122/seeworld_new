//
//  SWPostPreviewVC.h
//  SeeWorld
//
//  Created by Albert Lee on 21/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#import "ALBaseVC.h"
@protocol SWPostPreviewVCDelegate;
@interface SWPostPreviewVC : ALBaseVC

@property(nonatomic, weak)id<SWPostPreviewVCDelegate>delegate;
@property(nonatomic, strong)NSMutableArray  *images;
@property(nonatomic, assign)NSInteger startIndex;
@end

@protocol SWPostPreviewVCDelegate<NSObject>

- (void)postPreviewVCDidPressFinish:(SWPostPreviewVC *)vc images:(NSArray*)images tags:(NSArray *)tags;

@end
