//
//  SWPostModel.h
//  SeeWorld
//
//  Created by Albert Lee on 21/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol SWPostModelDelegate;
@interface SWPostModel : NSObject
@property(nonatomic,  weak)id<SWPostModelDelegate>delegate;
@property(nonatomic,  strong)NSString *locationName;

- (void)postLink:(NSString *)link content:(NSString *)content;
- (void)postPhoto:(NSArray *)images tags:(NSArray *)tags content:(NSString *)content;
- (void)postVideo:(NSURL *)videoUrl thumbImage:(UIImage *)thumbImage content:(NSString *)content;
- (void)postVideoWithAsset:(ALAsset *)asset thumbImage:(UIImage *)thumbImage content:(NSString *)content;
@end

@protocol SWPostModelDelegate<NSObject>

- (void)postModelDidPostFeed:(SWPostModel *)model;
- (void)postModelDidPostFeedFailed:(SWPostModel *)model;

@end
