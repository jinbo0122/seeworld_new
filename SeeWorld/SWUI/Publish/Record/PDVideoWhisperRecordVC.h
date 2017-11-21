//
//  PDVideoWhisperRecordVC.h
//  pandora
//
//  Created by Albert Lee on 27/10/2016.
//  Copyright © 2016 Albert Lee. All rights reserved.
//

#import "ALBaseVC.h"
@protocol PDVideoWhisperRecordVCDelegate;
@interface PDVideoWhisperRecordVC : ALBaseVC
@property(nonatomic, weak)id<PDVideoWhisperRecordVCDelegate>delegate;
@property(nonatomic, assign)NSInteger startIndex;
@property(nonatomic, assign)BOOL fromPostVC;

@end


@protocol PDVideoWhisperRecordVCDelegate<NSObject>
- (void)videoWhisperRecordVCDidReturnVideoUrl:(NSURL *)videoUrl;

@optional
- (void)videoWhisperRecordVCDidReturnImages:(NSArray *)images tags:(NSArray *)tags;

@end
