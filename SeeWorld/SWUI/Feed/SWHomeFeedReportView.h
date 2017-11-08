//
//  SWHomeFeedReportView.h
//  SeeWorld
//
//  Created by Albert Lee on 9/2/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSInteger{
  SWFeedReportTypePorn = 1,
  SWFeedReportTypeViolence = 2,
  SWFeedReportTypeOther = 3,
}SWFeedReportType;

@interface SWHomeFeedReportView : UIView
@property(nonatomic, strong)NSString *userId;
@property(nonatomic, strong)SWFeedItem *feedItem;
- (void)show;
@end
