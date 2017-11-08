//
//  PDSMSCodeCell.h
//  pandora
//
//  Created by Albert Lee on 10/13/14.
//  Copyright (c) 2014 Albert Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDSMSCodeCell : UITableViewCell
@property(nonatomic, strong)UILabel *lblCountry;
@property(nonatomic, strong)UILabel *lblCode;
- (void)refreshSMSCodeCell:(NSDictionary *)source;
@end
