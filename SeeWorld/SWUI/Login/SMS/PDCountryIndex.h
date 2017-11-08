//
//  PDCountryIndex.h
//  pandora
//
//  Created by Albert Lee on 10/13/14.
//  Copyright (c) 2014 Albert Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDCountryIndex : NSObject
@property (nonatomic, strong)NSString *countryName;
@property (nonatomic, strong)NSString *countryNamePinyin;
@property (nonatomic, strong)NSString *countryCode;
@property (nonatomic, assign)NSInteger sectionNum;
- (NSString *)getName;
- (void)setSecNum:(NSInteger)sectionNum;
@end
