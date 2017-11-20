//
//  SWPostPhotoView.h
//  SeeWorld
//
//  Created by Albert Lee on 17/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SWPostPhotoViewDelagate;
@interface SWPostPhotoView : UIView
@property (nonatomic,   weak)id<SWPostPhotoViewDelagate>delegate;
- (void)refreshWithPhotos:(NSArray *)array;
@end

@interface UIButton (UserProfilePhotoList)
@property (nonatomic, strong)NSNumber *photoIndex;
@end


@protocol SWPostPhotoViewDelagate<NSObject>
- (void)postPhotoViewDidNeedDelete:(NSInteger)tag;
- (void)postPhotoViewDidNeedChoose:(NSInteger)tag;
@end
