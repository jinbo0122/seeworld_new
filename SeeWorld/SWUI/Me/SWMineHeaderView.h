//
//  SWMineHeaderView.h
//  SeeWorld
//
//  Created by Albert Lee on 5/16/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SWMineHeaderViewDelegate;
@interface SWMineHeaderView : UIView
@property(nonatomic,   weak)id<SWMineHeaderViewDelegate>delegate;
@property(nonatomic, strong)UIButton *btnCover;
@property(nonatomic, strong)UIButton *btnAvatar;
@property(nonatomic, strong)UIButton *btnEditCover;
@property(nonatomic, strong)UIButton *btnEditAvatar;
@property(nonatomic, assign)BOOL      isEditMode;
@property(nonatomic, strong)UILabel  *lblName;
@property(nonatomic, strong)UILabel  *lblIntro;

@property(nonatomic, strong)UILabel  *lblPost;
@property(nonatomic, strong)UIButton *btnFollowing;
@property(nonatomic, strong)UIButton *btnFollower;
@property(nonatomic, strong)UIButton *btnEdit;
@property(nonatomic, strong)UIButton *btnMode;
@property(nonatomic, strong)UIButton *btnMore;
@property(nonatomic, strong)UIButton *btnChat;

@property(nonatomic, strong)UIView   *privateView;
- (void)refreshWithUser:(SWFeedUserItem *)user;
@end

@protocol SWMineHeaderViewDelegate <NSObject>

- (void)mineHeaderViewDidNeedEditCover:(SWMineHeaderView *)header;
- (void)mineHeaderViewDidNeedEditAvatar:(SWMineHeaderView *)header;

@optional
- (void)mineHeaderDidNeedGoFollowing:(SWMineHeaderView *)header;
- (void)mineHeaderDidNeedGoFollower:(SWMineHeaderView *)header;
- (void)mineHeaderDidPressEdit:(SWMineHeaderView *)header;
- (void)mineHeaderDidPressChat:(SWMineHeaderView *)header;
- (void)mineHeaderDidPressMode:(SWMineHeaderView *)header;
- (void)mineHeaderDidPressMore:(SWMineHeaderView *)header;
@end