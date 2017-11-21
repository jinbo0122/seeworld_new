 //
//  SWPostModel.m
//  SeeWorld
//
//  Created by Albert Lee on 21/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#import "SWPostModel.h"
#import "SWFeedComposeAPI.h"
#import "FeedComposeResponse.h"
#import "GetQiniuTokenApi.h"
#import "GetQiniuTokenResponse.h"
#import "QNUploadManager.h"
#import "QNResponseInfo.h"
typedef void(^COMPLETION_BLOCK_WITH_IMAGE_URL)(NSString *feedImageUrl);
typedef void(^COMPLETION_BLOCK_WITH_PhotoJson)(NSString *photoJson);

@interface SWPostModel()
@property(nonatomic, strong)NSMutableArray    *postImagesInfo;
@property(nonatomic, assign)__block NSInteger currentUploadIndex;

@end

@implementation SWPostModel{
  CGSize  _videoThumbSize;
}

- (id)init{
  if (self = [super init]) {
    _currentUploadIndex = 0;
    _postImagesInfo = [NSMutableArray array];
  }
  return self;
}

- (void)postLink:(NSString *)link content:(NSString *)content{
  SWFeedComposeAPI *api = [[SWFeedComposeAPI alloc] init];
  api.feedDescription = content;
  api.latitude = ((NSNumber *)[[NSUserDefaults standardUserDefaults] valueForKey:@"latitude"]).floatValue;
  api.longitude = ((NSNumber *)[[NSUserDefaults standardUserDefaults] valueForKey:@"longitude"]).floatValue;
  api.link = link;
  api.feedType = SWFeedTypeLink;
  [SWHUD showWaiting];
  __weak typeof(self)wSelf = self;
  [api startWithModelClass:[FeedComposeResponse class] completionBlock:^(ModelMessage *message) {
    [SWHUD hideWaiting];
    if (message.isSuccess){
      [SWHUD showCommonToast:@"發佈成功"];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"hidePickerController" object:nil];
      if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(postModelDidPostFeed:)]) {
        [wSelf.delegate postModelDidPostFeed:wSelf];
      }
    }else{
      if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(postModelDidPostFeedFailed:)]) {
        [wSelf.delegate postModelDidPostFeedFailed:wSelf];
      }
      [SWHUD showCommonToast:@"發佈失败"];
    }
  }];
}

- (void)uploadImage:(UIImage *)image completionBlock:(COMPLETION_BLOCK_WITH_IMAGE_URL)completionBlock{
  GetQiniuTokenApi *api = [[GetQiniuTokenApi alloc] init];
  __weak typeof(self)wSelf = self;
  [api startWithModelClass:[GetQiniuTokenResponse class] completionBlock:^(ModelMessage *message) {
    if (message.isSuccess){
      GetQiniuTokenResponse *resp = message.object;
      NSString *token = resp.data;
      QNUploadManager *manager = [[QNUploadManager alloc] init];
      
      NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
      [manager putData:imageData key:[SWObject createUUID]
                 token:token
              complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                if (info.ok && resp[@"key"]) {
                  NSString *imageURL = [NSString stringWithFormat:@"http:/7xlsvh.com1.z0.glb.clouddn.com/%@",[resp valueForKey:@"key"]];
                  if (completionBlock) {
                    completionBlock(imageURL);
                  }
                }else{
                  if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(postModelDidPostFeedFailed:)]) {
                    [wSelf.delegate postModelDidPostFeedFailed:wSelf];
                  }
                  [SWHUD hideWaiting];
                  [SWHUD showCommonToast:@"發佈失败"];
                }
              } option:nil];
    }else{
      if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(postModelDidPostFeedFailed:)]) {
        [wSelf.delegate postModelDidPostFeedFailed:wSelf];
      }
      [SWHUD hideWaiting];
      [SWHUD showCommonToast:@"發佈失败"];
    }
  }];
}

- (void)uploadImages:(NSArray *)images completionBlock:(COMPLETION_BLOCK_WITH_PhotoJson)block{
  if (_currentUploadIndex == images.count) {
    if (block) {
      block([self.postImagesInfo JSONString]);
    }
    return;
  }
  UIImage *image = images[_currentUploadIndex];
  CGSize size = image.size;
  __weak typeof(self)wSelf = self;
  [self uploadImage:images[_currentUploadIndex] completionBlock:^(NSString *feedImageUrl) {
    [wSelf.postImagesInfo addObject:@{@"src":feedImageUrl,
                                      @"width":@(size.width),
                                      @"height":@(size.width)}];
    wSelf.currentUploadIndex++;
    [wSelf uploadImages:images completionBlock:block];
  }];
}


- (void)postPhoto:(NSArray *)images tags:(NSArray *)tags content:(NSString *)content{
  NSMutableArray *postTags = [NSMutableArray array];
  for (NSArray *imageTags in tags) {
    for (NSDictionary *tag in imageTags) {
      if ([[tag allKeys] containsObject:@"imageId"]) {
        [postTags addObject:tag];
      }
    }
  }
  [SWHUD showWaiting];
  __weak typeof(self)wSelf = self;
  _currentUploadIndex = 0;
  NSInteger imageCount = images.count;
  [_postImagesInfo removeAllObjects];
  [self uploadImages:images completionBlock:^(NSString *photoJson) {
    if (wSelf.postImagesInfo.count == imageCount) {
      SWFeedComposeAPI *api = [[SWFeedComposeAPI alloc] init];
      api.feedDescription = content;
      api.latitude = ((NSNumber *)[[NSUserDefaults standardUserDefaults] valueForKey:@"latitude"]).floatValue;
      api.longitude = ((NSNumber *)[[NSUserDefaults standardUserDefaults] valueForKey:@"longitude"]).floatValue;
      api.feedType = SWFeedTypeImage;
      api.photoJson = photoJson;
      api.tags = postTags;
      [api startWithModelClass:[FeedComposeResponse class] completionBlock:^(ModelMessage *message) {
        [SWHUD hideWaiting];
        if (message.isSuccess){
          [SWHUD showCommonToast:@"發佈成功"];
          [[NSNotificationCenter defaultCenter] postNotificationName:@"hidePickerController" object:nil];
          if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(postModelDidPostFeed:)]) {
            [wSelf.delegate postModelDidPostFeed:wSelf];
          }
        }else{
          if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(postModelDidPostFeedFailed:)]) {
            [wSelf.delegate postModelDidPostFeedFailed:wSelf];
          }
          [SWHUD showCommonToast:@"發佈失败"];
        }
      }];
    }
  }];
}

- (void)postVideo:(NSURL *)videoUrl thumbImage:(UIImage *)thumbImage content:(NSString *)content{
  [SWHUD showWaiting];
  _videoThumbSize = thumbImage.size;
  GetQiniuTokenApi *api = [[GetQiniuTokenApi alloc] init];
  __weak typeof(self)wSelf = self;
  [api startWithModelClass:[GetQiniuTokenResponse class] completionBlock:^(ModelMessage *message) {
    if (message.isSuccess){
      GetQiniuTokenResponse *resp = message.object;
      NSString *token = resp.data;
      QNUploadManager *manager = [[QNUploadManager alloc] init];
      
      NSData *imageData = UIImageJPEGRepresentation(thumbImage, 0.3);
      [manager putData:imageData key:[SWObject createUUID]
                 token:token
              complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                if (info.ok && resp[@"key"]) {
                  NSString *imageURL = [NSString stringWithFormat:@"http:/7xlsvh.com1.z0.glb.clouddn.com/%@",[resp valueForKey:@"key"]];
                  [wSelf postVideo:videoUrl thumbImageURL:imageURL content:content];
                }else{
                  if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(postModelDidPostFeedFailed:)]) {
                    [wSelf.delegate postModelDidPostFeedFailed:wSelf];
                  }
                  [SWHUD hideWaiting];
                  [SWHUD showCommonToast:@"發佈失败"];
                }
              } option:nil];
    }else{
      if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(postModelDidPostFeedFailed:)]) {
        [wSelf.delegate postModelDidPostFeedFailed:wSelf];
      }
      [SWHUD hideWaiting];
      [SWHUD showCommonToast:@"發佈失败"];
    }
  }];
}

- (void)postVideo:(NSURL *)videoUrl thumbImageURL:(NSString *)thumbImageURL content:(NSString *)content{
  GetQiniuTokenApi *api = [[GetQiniuTokenApi alloc] init];
  __weak typeof(self)wSelf = self;
  [api startWithModelClass:[GetQiniuTokenResponse class] completionBlock:^(ModelMessage *message) {
    if (message.isSuccess){
      GetQiniuTokenResponse *resp = message.object;
      NSString *token = resp.data;
      QNUploadManager *manager = [[QNUploadManager alloc] init];
      [manager putFile:[videoUrl path]
                   key:[SWObject createUUID]
                 token:token
              complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                if (info.ok && resp[@"key"]) {
                  NSString *videoUrlString = [NSString stringWithFormat:@"http:/7xlsvh.com1.z0.glb.clouddn.com/%@",[resp valueForKey:@"key"]];
                  [wSelf postVideoURL:videoUrlString thumbImageURL:thumbImageURL content:content];
                }else{
                  if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(postModelDidPostFeedFailed:)]) {
                    [wSelf.delegate postModelDidPostFeedFailed:wSelf];
                  }
                  [SWHUD hideWaiting];
                  [SWHUD showCommonToast:@"發佈失败"];
                }
              } option:nil];
    }else{
      if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(postModelDidPostFeedFailed:)]) {
        [wSelf.delegate postModelDidPostFeedFailed:wSelf];
      }
      [SWHUD hideWaiting];
      [SWHUD showCommonToast:@"發佈失败"];
    }
  }];
}

- (void)postVideoWithAsset:(ALAsset *)asset thumbImage:(UIImage *)thumbImage content:(NSString *)content{
  [SWHUD showWaiting];
  _videoThumbSize = thumbImage.size;
  GetQiniuTokenApi *api = [[GetQiniuTokenApi alloc] init];
  __weak typeof(self)wSelf = self;
  [api startWithModelClass:[GetQiniuTokenResponse class] completionBlock:^(ModelMessage *message) {
    if (message.isSuccess){
      GetQiniuTokenResponse *resp = message.object;
      NSString *token = resp.data;
      QNUploadManager *manager = [[QNUploadManager alloc] init];
      
      NSData *imageData = UIImageJPEGRepresentation(thumbImage, 0.3);
      [manager putData:imageData key:[SWObject createUUID]
                 token:token
              complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                if (info.ok && resp[@"key"]) {
                  NSString *imageURL = [NSString stringWithFormat:@"http:/7xlsvh.com1.z0.glb.clouddn.com/%@",[resp valueForKey:@"key"]];
                  [wSelf postVideoWithAsset:asset thumbImageURL:imageURL content:content];
                }else{
                  if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(postModelDidPostFeedFailed:)]) {
                    [wSelf.delegate postModelDidPostFeedFailed:wSelf];
                  }
                  [SWHUD hideWaiting];
                  [SWHUD showCommonToast:@"發佈失败"];
                }
              } option:nil];
    }else{
      if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(postModelDidPostFeedFailed:)]) {
        [wSelf.delegate postModelDidPostFeedFailed:wSelf];
      }
      [SWHUD hideWaiting];
      [SWHUD showCommonToast:@"發佈失败"];
    }
  }];
}

- (void)postVideoWithAsset:(ALAsset *)asset thumbImageURL:(NSString *)thumbImageURL content:(NSString *)content{
  GetQiniuTokenApi *api = [[GetQiniuTokenApi alloc] init];
  __weak typeof(self)wSelf = self;
  [api startWithModelClass:[GetQiniuTokenResponse class] completionBlock:^(ModelMessage *message) {
    if (message.isSuccess){
      GetQiniuTokenResponse *resp = message.object;
      NSString *token = resp.data;
      QNUploadManager *manager = [[QNUploadManager alloc] init];
      [manager putALAsset:asset
                   key:[SWObject createUUID]
                 token:token
              complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                if (info.ok && resp[@"key"]) {
                  NSString *videoUrlString = [NSString stringWithFormat:@"http:/7xlsvh.com1.z0.glb.clouddn.com/%@",[resp valueForKey:@"key"]];
                  [wSelf postVideoURL:videoUrlString thumbImageURL:thumbImageURL content:content];
                }else{
                  if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(postModelDidPostFeedFailed:)]) {
                    [wSelf.delegate postModelDidPostFeedFailed:wSelf];
                  }
                  [SWHUD hideWaiting];
                  [SWHUD showCommonToast:@"發佈失败"];
                }
              } option:nil];
    }else{
      if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(postModelDidPostFeedFailed:)]) {
        [wSelf.delegate postModelDidPostFeedFailed:wSelf];
      }
      [SWHUD hideWaiting];
      [SWHUD showCommonToast:@"發佈失败"];
    }
  }];
}


- (void)postVideoURL:(NSString *)videoUrl thumbImageURL:(NSString *)thumbImageURL content:(NSString *)content{
  SWFeedComposeAPI *api = [[SWFeedComposeAPI alloc] init];
  api.feedDescription = content;
  api.latitude = ((NSNumber *)[[NSUserDefaults standardUserDefaults] valueForKey:@"latitude"]).floatValue;
  api.longitude = ((NSNumber *)[[NSUserDefaults standardUserDefaults] valueForKey:@"longitude"]).floatValue;
  api.feedType = SWFeedTypeVideo;
  api.photoJson = [@[@{@"src":thumbImageURL?thumbImageURL:@"",@"width":@(_videoThumbSize.width),@"height":@(_videoThumbSize.height)}] JSONString];
  api.videoUrl = videoUrl;
  __weak typeof(self)wSelf = self;
  [api startWithModelClass:[FeedComposeResponse class] completionBlock:^(ModelMessage *message) {
    [SWHUD hideWaiting];
    if (message.isSuccess){
      [SWHUD showCommonToast:@"發佈成功"];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"hidePickerController" object:nil];
      if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(postModelDidPostFeed:)]) {
        [wSelf.delegate postModelDidPostFeed:wSelf];
      }
    }else{
      if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(postModelDidPostFeedFailed:)]) {
        [wSelf.delegate postModelDidPostFeedFailed:wSelf];
      }
      [SWHUD showCommonToast:(message.message.length == 0? @"發佈失败":message.message)];
    }
  }];
}
@end
