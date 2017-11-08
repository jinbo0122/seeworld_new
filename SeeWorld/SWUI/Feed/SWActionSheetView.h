//
//  SWActionSheetView.h
//  SeeWorld
//
//  Created by Albert Lee on 10/8/15.
//  Copyright © 2015 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWActionSheetView : UIView
@property(nonatomic, strong)COMPLETION_BLOCK completeBlock;
@property(nonatomic, strong)COMPLETION_BLOCK cancelBlock;
@property(nonatomic, strong)NSString *title;
@property(nonatomic, strong)NSString *content;
@property(nonatomic, strong)UIButton *btnCancel;
- (id)initWithFrame:(CGRect)frame title:(NSString *)title content:(NSString *)content;
- (void)show;
- (void)dismiss;
@end
