//
//  SWSelectContactCell.h
//  SeeWorld
//
//  Created by Albert Lee on 1/5/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWSelectContactCell : UITableViewCell
@property(nonatomic, strong)UIButton *btnChat;
- (void)refreshUser:(SWFeedUserItem *)item selected:(NSArray*)selectedContacts;
@end
