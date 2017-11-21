//
//  SWPostPreview.h
//  SeeWorld
//
//  Created by Albert Lee on 21/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTTagView.h"
#import "WTTagViewItem.h"
#import "WTTag.h"
@protocol SWPostPreviewDelegate;
@interface SWPostPreview : UIView
@property(nonatomic,   weak)id<SWPostPreviewDelegate>delegate;
@property(nonatomic, strong)WTTagView *tagView;
@property(nonatomic, strong)UIImage   *image;
@property(nonatomic, strong)NSMutableArray *addedTags;
- (NSArray *)tags;

@end


@protocol SWPostPreviewDelegate<NSObject>
- (void)postPreviewDidNeedAddTag:(SWPostPreview *)preview;
@end
