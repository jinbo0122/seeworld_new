//
//  ALWebVC.m
//  StudentLoan
//
//  Created by Albert Lee on 2/22/16.
//  Copyright © 2016 Albert Lee. All rights reserved.
//

#import "ALWebVC.h"
@interface ALWebVC()<UIWebViewDelegate>
@end

@implementation ALWebVC{
  UIWebView *_webView;
}
- (void)viewDidLoad{
  [super viewDidLoad];
  _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
  [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
  [self.view addSubview:_webView];
  _webView.delegate = self;
  _webView.scalesPageToFit = YES;
#ifndef BBSDKMODE
  _webView.height+=iOS7NavHeight;
  _webView.height-=10;
#else
#endif
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
  NSString *title=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
  __weak typeof(self)wSelf = self;
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    if ([[wSelf.navigationController.viewControllers lastObject] isEqual:wSelf]) {
      wSelf.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:title color:[UIColor whiteColor]];
    }
  });
}
@end
