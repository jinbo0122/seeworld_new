//
//  SWAlertView.h
//  SeeWorld
//
//  Created by Albert Lee on 6/6/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWAlertView : UIView
- (id)initWithTitle:(NSString *)title
         cancelText:(NSString *)cancelText
        cancelBlock:(COMPLETION_BLOCK)cancelBlock
             okText:(NSString *)okText
            okBlock:(COMPLETION_BLOCK)okBlock;
- (void)show;
@end
