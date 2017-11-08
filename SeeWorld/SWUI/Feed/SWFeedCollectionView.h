//
//  SWFeedCollectionView.h
//  SeeWorld
//
//  Created by Albert Lee on 9/3/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWFeedCollectionCell.h"
@protocol SWFeedCollectionViewDelegate;
@interface SWFeedCollectionView : UICollectionView
@property(nonatomic,assign)NSInteger currentPage;
@property(nonatomic,assign)NSInteger totalPage;
@property(nonatomic,assign)BOOL isNeedReloadOnEverySweptGesture;
@property(nonatomic,weak)id<SWFeedCollectionViewDelegate> dataSourceDelegate;
- (void)reloadData;
- (void)reloadDataAtIndex:(NSInteger)index;
- (void)scrollTo:(NSInteger)index animated:(BOOL)animated;
@end

@protocol SWFeedCollectionViewDelegate <NSObject>
@required
- (NSInteger)numberOfCellsInHorizontalScrollView:(SWFeedCollectionView *)hScrollView;
- (void     )horizontalScrollViewCell:(SWFeedCollectionCell *)cell cellAtIndexPath:(NSIndexPath*)indexPath;
@optional
- (void)horizontalScrollViewWillBeginDragging:(SWFeedCollectionView *)hScrollView;
- (void)horizontalScrollViewDidScroll:(NSInteger)index;
- (void)horizontalScrollView:(SWFeedCollectionView *)hScrollView didScrollToIndex:(NSInteger)index;
@end