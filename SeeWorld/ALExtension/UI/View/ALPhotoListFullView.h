//
//  ALPhotoListFullView.h
//  ALExtension
//
//  Created by Albert Lee on 7/13/15.
//  Copyright (c) 2015 Albert Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWFeedItem.h"
@interface ALPhotoListFullView : UIView
@property(nonatomic, strong)SWFeedItem *feedItem;
- (id)initWithFrames:(NSArray *)frames photoList:(NSArray *)photoList index:(NSInteger)index;
@end
