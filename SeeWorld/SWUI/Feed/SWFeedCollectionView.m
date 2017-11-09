//
//  SWFeedCollectionView.m
//  SeeWorld
//
//  Created by Albert Lee on 9/3/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWFeedCollectionView.h"
@interface SWFeedCollectionView()<UICollectionViewDataSource,UICollectionViewDelegate>
@end

@implementation SWFeedCollectionView
- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
  self = [super initWithFrame:frame collectionViewLayout:layout];
  if (self) {
    self.delegate = self;
    self.dataSource = self;
    self.pagingEnabled = YES;
    self.backgroundColor = [UIColor colorWithRGBHex:0xffffff];
    [self registerClass:[SWFeedCollectionCell class] forCellWithReuseIdentifier:@"pbIdentifier"];
  }
  return self;
}

- (void)reloadData{
  [super reloadData];
  if (self.dataSourceDelegate && [self.dataSourceDelegate respondsToSelector:@selector(numberOfCellsInHorizontalScrollView:)]) {
    self.totalPage = [self.dataSourceDelegate numberOfCellsInHorizontalScrollView:self];
  }
}

- (void)reloadDataAtIndex:(NSInteger)index{
  if (self.dataSourceDelegate && [self.dataSourceDelegate respondsToSelector:@selector(numberOfCellsInHorizontalScrollView:)]) {
    self.totalPage = [self.dataSourceDelegate numberOfCellsInHorizontalScrollView:self];
  }
  
  [self reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
}

- (void)scrollTo:(NSInteger)index animated:(BOOL)animated{
  if ([self numberOfItemsInSection:0]) {
    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
                 atScrollPosition:UICollectionViewScrollPositionLeft
                         animated:animated];
  }

  _currentPage = index;
  if([self.dataSourceDelegate respondsToSelector:@selector(horizontalScrollView:didScrollToIndex:)]){
    [self.dataSourceDelegate horizontalScrollView:self didScrollToIndex:_currentPage];
  }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
  return self.totalPage;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  return CGSizeMake(self.width-10, self.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  SWFeedCollectionCell *cell = [self dequeueReusableCellWithReuseIdentifier:@"pbIdentifier"
                                                               forIndexPath:indexPath];
  if (!cell) {
    cell = [[SWFeedCollectionCell alloc] initWithFrame:self.frame];
  }
  if (self.dataSourceDelegate && [self.dataSourceDelegate respondsToSelector:@selector(horizontalScrollViewCell:cellAtIndexPath:)]) {
    [self.dataSourceDelegate horizontalScrollViewCell:cell cellAtIndexPath:indexPath];
  }
  
  return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
  if(self.dataSourceDelegate &&
     [self.dataSourceDelegate respondsToSelector:@selector(horizontalScrollViewWillBeginDragging:)]){
    [self.dataSourceDelegate horizontalScrollViewWillBeginDragging:self];
  }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
  NSInteger index = scrollView.contentOffset.x/(CGRectGetWidth(scrollView.frame));
  if (self.dataSourceDelegate &&
      [self.dataSourceDelegate respondsToSelector:@selector(horizontalScrollViewDidScroll:) ]) {
    [self.dataSourceDelegate horizontalScrollViewDidScroll:index];
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  _currentPage = self.contentOffset.x / self.frame.size.width;
  if([self.dataSourceDelegate respondsToSelector:@selector(horizontalScrollView:didScrollToIndex:)]){
    [self.dataSourceDelegate horizontalScrollView:self didScrollToIndex:_currentPage];
  }
}
@end
