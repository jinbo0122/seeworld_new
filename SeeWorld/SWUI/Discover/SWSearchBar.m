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
    [self setImage:[UIImage imageNamed:@"search_icon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    self.layer.masksToBounds = YES;
    
    UIView *subview = [self.subviews lastObject];
    if (subview.subviews.count>2) {
      UITextField *textView;
      for (UIView *view in subview.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
          textView = (id)view;
        }
      }
      textView.layer.borderWidth = 0.5;
      textView.layer.cornerRadius = 4.0;
      textView.layer.borderColor = [UIColor colorWithRGBHex:0x8b9cad].CGColor;
    }
  }
  return self;
}
@end
