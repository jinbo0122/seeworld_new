//
//  SWReportView.h
//  SeeWorld
//
//  Created by Albert Lee on 1/22/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWReportView : UIView
- (id)initWithTitle:(NSString *)title;
@property(nonatomic, strong)COMPLETION_BLOCK block;
- (void)show;
@end
