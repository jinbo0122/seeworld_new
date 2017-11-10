//
//  SWFeedModelProtocol.h
//  SeeWorld
//
//  Created by Albert Lee on 11/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#ifndef SWFeedModelProtocol_h
#define SWFeedModelProtocol_h

@protocol SWFeedModelProtocol<NSObject>
@property(nonatomic, strong)NSMutableArray *feeds;
@property(nonatomic, strong)NSString *userId;
- (void)likeClickedByRow:(NSInteger)row;
@end

#endif /* SWFeedModelProtocol_h */
