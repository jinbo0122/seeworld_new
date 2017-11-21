//
//  SWPostPreviewVC.m
//  SeeWorld
//
//  Created by Albert Lee on 21/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#import "SWPostPreviewVC.h"
#import "SWPostPreview.h"
#import "SWAddTagViewVC.h"
@interface SWPostPreviewVC ()<UIScrollViewDelegate,SWPostPreviewDelegate,
SWAddTagViewVCDelegate>

@end

@implementation SWPostPreviewVC{
  NSInteger _currentIndex;
  UIScrollView *_scrollView;
  
  UIButton *_btnCancel;
  UIButton *_btnNext;
}

- (id)init{
  if (self = [super init]) {
    
  }
  return self;
}

- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:NO];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  [self.navigationController setNavigationBarHidden:YES];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor blackColor];
  _currentIndex = 0;
  [self titleView];
  self.automaticallyAdjustsScrollViewInsets = NO;
  _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
  _scrollView.bounces = NO;
  _scrollView.delegate = self;
  _scrollView.pagingEnabled = YES;
  [self.view addSubview:_scrollView];
  
  for (NSInteger i=0; i<_images.count; i++) {
    SWPostPreview *preview = [[SWPostPreview alloc] initWithFrame:CGRectMake(UIScreenWidth *i, 0, _scrollView.width, _scrollView.height)];
    preview.image = [_images safeObjectAtIndex:i];
    preview.delegate = self;
    preview.tag = i+_startIndex;
    [_scrollView addSubview:preview];
  }
  
  self.navigationItem.rightBarButtonItem = [UIBarButtonItem loadBarButtonItemWithTitle:@"下一步"
                                                                                 color:[UIColor whiteColor]
                                                                                  font:[UIFont systemFontOfSize:16]
                                                                                target:self
                                                                                action:@selector(onNextClicked)];
  
  _scrollView.contentSize = CGSizeMake(UIScreenWidth *_images.count, UIScreenHeight);
  
  
  if (_isModal) {
    _btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(0, iOSTopHeight+20, 56, 44)];
    [_btnCancel setTitle:SWStringCancel forState:UIControlStateNormal];
    [_btnCancel.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:_btnCancel];
    [_btnCancel addTarget:self action:@selector(onCancel) forControlEvents:UIControlEventTouchUpInside];
    
    _btnNext = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-56, iOSTopHeight+20, 56, 44)];
    [_btnNext setTitle:@"下一步" forState:UIControlStateNormal];
    [_btnNext.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:_btnNext];
    [_btnNext addTarget:self action:@selector(onNextClicked) forControlEvents:UIControlEventTouchUpInside];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)titleView{
  self.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:[NSString stringWithFormat:@"%@/%@",@(_currentIndex+1),@(_images.count)]
                                                                color:[UIColor whiteColor]];
}

- (void)onCancel{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onNextClicked{
  NSMutableArray *images = [[NSMutableArray alloc] init];
  NSMutableArray *tags = [[NSMutableArray alloc] init];
  for (SWPostPreview *preview in [_scrollView subviews]) {
    if ([preview isKindOfClass:[SWPostPreview class]]) {
      [images addObject:preview.tagView.backgroundImageView.image];
      [tags safeAddObject:[preview tags]];
    }
  }
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(postPreviewVCDidPressFinish:images:tags:)]) {
    [self.delegate postPreviewVCDidPressFinish:self images:images tags:tags];
  }
//
//  
//  UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Publish" bundle:nil];
//  ComposeViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ComposeViewController"];
//  vc.photoImage = self.photoImage;
//  UIImage *image = [UIImage imageWithView:self.tagView];
//  vc.resultImage = image;
//  vc.tags = tags;
//  [self pushViewController:vc];
}

#pragma mark Scroll View
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  _currentIndex = scrollView.contentOffset.x/UIScreenWidth;
  [self titleView];
}

#pragma mark Preview Delegate
- (void)postPreviewDidNeedAddTag:(SWPostPreview *)preview{
  SWAddTagViewVC *vc = [[SWAddTagViewVC alloc] init];
  vc.photoImage = preview.tagView.backgroundImageView.image;
  vc.delegate = self;
  vc.addedTags = [preview.addedTags mutableCopy];
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
  [self presentViewController:nav animated:YES completion:nil];
}

- (void)addTagViewVCDidReturnTags:(NSArray *)tags{
  SWPostPreview *preview;
  for (SWPostPreview *view in [_scrollView subviews]) {
    if (view.tag == _startIndex+_currentIndex && [view isKindOfClass:[SWPostPreview class]]) {
      preview = view;
      break;
    }
  }
  
  [preview.addedTags removeAllObjects];
  [preview.addedTags addObjectsFromArray:tags];
  [preview.tagView reloadData];
  [self dismissViewControllerAnimated:YES completion:nil];
}
@end
