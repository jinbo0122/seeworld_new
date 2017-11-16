//
//  SWPostPhotoView.h
//  SeeWorld
//
//  Created by Albert Lee on 17/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWPostPhotoView : UIView
- (void)refreshWithPhotos:(NSArray *)array;
@end

@interface UIButton (UserProfilePhotoList)
@property (nonatomic, strong)NSNumber *photoIndex;
@end
