//
//  PDSelectSMSCodeVC.h
//  pandora
//
//  Created by Albert Lee on 10/13/14.
//  Copyright (c) 2014 Albert Lee. All rights reserved.
//

#import "ALBaseVC.h"
@protocol PDSelectSMSCodeVCDelegate;
@interface PDSelectSMSCodeVC : ALBaseVC
@property(nonatomic, weak)id<PDSelectSMSCodeVCDelegate>delegate;
@end

@protocol PDSelectSMSCodeVCDelegate <NSObject>

- (void)smsDidReturnWithCountry:(NSString *)country code:(NSString *)code;

@end