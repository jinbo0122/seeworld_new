//
//  SWMsgVC.m
//  SeeWorld
//
//  Created by Albert Lee on 12/22/15.
//  Copyright © 2015 SeeWorld. All rights reserved.
//

#import "SWMsgVC.h"
#import "SWChatSettingVC.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "MJPhotoView.h"
@interface SWMsgVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation SWMsgVC{
  UIImagePickerController *_libraryPicker;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  self.conversationMessageCollectionView.backgroundColor = [UIColor whiteColor];
  self.defaultInputType = RCChatSessionInputBarInputText;
  self.displayUserNameInCell = NO;
  [[RCIM sharedRCIM] setGlobalMessagePortraitSize:CGSizeMake(35, 35)];
  [self.chatSessionInputBarControl.pluginBoardView updateItemAtIndex:0 image:[UIImage imageNamed:@"chat_add_btn_img"] title:@""];
  [self.chatSessionInputBarControl.pluginBoardView updateItemAtIndex:1 image:[UIImage imageNamed:@"chat_add_btn_shooting"] title:@""];
  [self.chatSessionInputBarControl.pluginBoardView updateItemAtIndex:2 image:[UIImage imageNamed:@"chat_add_btn_location"] title:@""];
  [self.chatSessionInputBarControl.pluginBoardView updateItemAtIndex:3 image:[UIImage imageNamed:@"chat_add_btn_call"] title:@""];
  [self.chatSessionInputBarControl.pluginBoardView updateItemAtIndex:4 image:[UIImage imageNamed:@"actionbar_video_icon"] title:@""];
  self.chatSessionInputBarControl.pluginBoardView.backgroundColor = [UIColor colorWithRGBHex:0xe5e7eb];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"chat_btn_setting"]
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(onRightBtnClicked)];
  
  self.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:self.title
                                                                color:[UIColor colorWithRGBHex:0x838cda]
                                                             fontSize:16];
  self.title = @"";
  
  _libraryPicker = [[UIImagePickerController alloc] init];
  _libraryPicker.navigationBar.tintColor = [UIColor whiteColor];
  _libraryPicker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
  _libraryPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  _libraryPicker.delegate = self;
  
  NSLog(@"call enabled %@",[[RCCall sharedRCCall] isAudioCallEnabled:self.conversationType]?@"YES":@"NO");
  
  self.chatSessionInputBarControl.emojiBoardView.backgroundColor = [UIColor colorWithRGBHex:0xf8f8f8];
  
}

- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  [self.conversationMessageCollectionView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  if (self.conversationType==ConversationType_DISCUSSION) {
    __weak typeof(self)wSelf = self;
    [[RCIMClient sharedRCIMClient] getDiscussion:self.targetId
                                         success:^(RCDiscussion *discussion) {
                                           wSelf.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:discussion.discussionName
                                                                                                          color:[UIColor colorWithRGBHex:0x838cda]
                                                                                                       fontSize:16];
                                           wSelf.title = @"";
                                         } error:^(RCErrorCode status) {
                                           
                                         }];
  }
}

- (void)onRightBtnClicked{
  SWChatSettingVC *vc = [[SWChatSettingVC alloc] init];
  vc.cType = self.conversationType;
  vc.targetId = self.targetId;
  vc.messages = self.conversationDataRepository;
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)willDisplayMessageCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath{
  cell.messageTimeLabel.backgroundColor = [UIColor clearColor];
  cell.messageTimeLabel.textColor = [UIColor colorWithRGBHex:0x9d9d9d];
  if ([cell isKindOfClass:[RCTextMessageCell class]]) {
    ((RCTextMessageCell*)cell).textLabel.textColor = [UIColor colorWithRGBHex:cell.messageDirection==MessageDirection_SEND?0xffffff:0x596d80];
  }
}

- (void)didTapCellPortrait:(NSString *)userId{
  SWFeedUserItem *item = [[SWFeedUserItem alloc] init];
  item.uId = [userId numberValue];
  [SWFeedUserItem pushUserVC:item nav:self.navigationController];
}

-(void)pluginBoardView:(RCPluginBoardView*)pluginBoardView clickedItemWithTag:(NSInteger)tag{
  if (tag == PLUGIN_BOARD_ITEM_ALBUM_TAG) {
    [self presentViewController:_libraryPicker animated:YES completion:nil];
  }else{
    [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
  }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
  [self dismissViewControllerAnimated:YES completion:nil];
  RCImageMessage *msg = [RCImageMessage messageWithImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
  [self sendMediaMessage:msg pushContent:[NSString stringWithFormat:@"%@ 發來了一條消息",[SWConfigManager sharedInstance].user.name] appUpload:NO];
}

- (void)sendMessage:(RCMessageContent *)messageContent
        pushContent:(NSString *)pushContent{
  [super sendMessage:messageContent
         pushContent:[NSString stringWithFormat:@"%@ 發來了一條消息",[SWConfigManager sharedInstance].user.name]];
}

- (void)presentImagePreviewController:(RCMessageModel *)model{
  NSArray *array = [[RCIMClient sharedRCIMClient] getLatestMessages:self.conversationType
                                                           targetId:self.targetId
                                                              count:1000];
  NSMutableArray *imageMsgs = [NSMutableArray array];
  NSInteger index = 0;
  for (NSInteger i=array.count-1; i>=0; i--) {
    RCMessage *msg = [array safeObjectAtIndex:i];
    if ([msg.objectName isEqualToString:@"RC:ImgMsg"]) {
      MJPhoto *photo = [[MJPhoto alloc] init];
      photo.url = [NSURL URLWithString:((RCImageMessage *)msg.content).imageUrl];
      [imageMsgs addObject:photo];
      
      if (msg.messageId == model.messageId) {
        index = [imageMsgs indexOfObject:photo];
      }
    }
  }
  
  MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
  browser.photos = imageMsgs;
  browser.currentPhotoIndex = index;
  [self.navigationController pushViewController:browser animated:YES];
  [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
@end
