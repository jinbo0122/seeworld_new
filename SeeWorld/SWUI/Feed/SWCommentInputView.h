//
//  SWCommentInputView.h
//  SeeWorld
//
//  Created by Albert Lee on 9/2/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWCommentTextField.h"

@interface SWCommentInputView : UIView
@property(nonatomic, strong)SWCommentTextField *txtField;
@property(nonatomic, strong)UIButton *btnPhoto;
@property(nonatomic, strong)SWFeedUserItem  *replyUser;
@end
