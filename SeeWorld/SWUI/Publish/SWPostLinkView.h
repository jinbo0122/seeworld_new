//
//  SWPostLinkView.h
//  SeeWorld
//
//  Created by Albert Lee on 21/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWPostLinkView : UIView
@property(nonatomic, strong)UIImageView *imageView;
- (void)refreshWithTitle:(NSString *)title image:(NSString *)imageUrl;
@end
