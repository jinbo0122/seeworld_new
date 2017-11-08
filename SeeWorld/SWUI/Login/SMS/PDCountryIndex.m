//
//  PDCountryIndex.m
//  pandora
//
//  Created by Albert Lee on 10/13/14.
//  Copyright (c) 2014 Albert Lee. All rights reserved.
//

#import "PDCountryIndex.h"

@implementation PDCountryIndex
- (NSString *)getName{
  return self.countryNamePinyin;
}

- (void)setSecNum:(NSInteger)sectionNum{
  self.sectionNum = sectionNum;
}
@end
