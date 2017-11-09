//
//  SWSearchBar.m
//  SeeWorld
//
//  Created by Albert Lee on 9/9/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWSearchBar.h"

@implementation SWSearchBar
- (id)initWithFrame:(CGRect)frame{
  if (self = [super initWithFrame:frame]) {
    self.searchBarStyle = UISearchBarStyleMinimal;
    self.showsCancelButton = YES;
    self.barTintColor = [UIColor whiteColor];
    self.placeholder = SWStringSearchUser;
    self.tintColor = [UIColor whiteColor];
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius = 4.0;
    
    [self setImage:[UIImage imageNamed:@"search_icon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
  }
  return self;
}
@end
