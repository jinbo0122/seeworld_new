//
//  SWFeedLinkView.h
//  SeeWorld
//
//  Created by Albert Lee on 22/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWFeedLinkView : UIView
@property(nonatomic, strong)UIImageView *imageView;
- (void)refreshWithTitle:(NSString *)title image:(NSString *)imageUrl;

@end
