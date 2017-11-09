//
//  SWActionSheet.m
//  
//
//  Created by abc on 15/6/18.
//  
//

#import "SWActionSheet.h"
#import "SWFoundation.h"
#import "SWColor.h"

#define SWFONT(size) [UIFont systemFontOfSize:size]

static const NSUInteger kSWActionSheetButtonHeight = 50;
static const NSUInteger kSWActionSheetTitleHeight = 40;
static const NSUInteger kSWActionSheetCancelSpace = 5;
static const NSUInteger kSWActionSheetShareHeight = 15 + 46 + 5 + 14 + 15;


@interface SWActionSheetItem()
@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,copy) void (^block)(void);
@end


@implementation SWActionSheetItem
+(instancetype)itemWithTitle:(NSString *)title block:(void(^)(void))block
{
    SWActionSheetItem *item = [[self alloc] init];
    item.title = title;
    item.block = block;
    return item;
}


+(instancetype)itemWithTitle:(NSString *)title image:(UIImage *)image block:(void(^)(void))block
{
    SWActionSheetItem *item = [self itemWithTitle:title block:block];
    item.image = image;
    return item;
}

@end


@interface SWActionSheetButton : UIButton
@property (nonatomic,strong) SWActionSheetItem *item;
@property (nonatomic,copy)  void(^clickedBlock)(void);
@end

@implementation SWActionSheetButton

- (instancetype)initWithFrame:(CGRect)frame;
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRGBHex:0x152c3e];
        [self setTitle:@"" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.font = SWFONT(15);
    }
    return self;
}

- (void)setItem:(SWActionSheetItem *)item
{
    _item = item;
    [self setTitle:item.title forState:UIControlStateNormal];
    self.layer.masksToBounds = YES;
    if ([item.title isEqualToString:@"广告"]) {
        [self setTitleColor:[UIColor hexChangeFloat:@"f4453C"] forState:UIControlStateNormal];
    }
    
    if ([item.title isEqualToString:@"使用Facebook注册"]) {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor hexChangeFloat:@"667EB9"];
        self.layer.cornerRadius = 6.f;
    }
    
    if ([item.title isEqualToString:@"使用微博注册"]) {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor hexChangeFloat:@"F56467"];
        self.layer.cornerRadius = 6.f;
    }
    
    if ([item.title isEqualToString:@"使用邮箱注册"]) {
        [self setTitleColor:[UIColor hexChangeFloat:@"494949"] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor hexChangeFloat:@"F0F0F0"];
        self.layer.cornerRadius = 6.f;
    }
    
    [self addTarget:self action:@selector(actionClicked:) forControlEvents:UIControlEventTouchUpInside];
    if (item.image) {
        [self setImage:item.image forState:UIControlStateNormal];
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        self.imageEdgeInsets = UIEdgeInsetsMake(0,16,0,0);
        CGSize textSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
        self.titleEdgeInsets = UIEdgeInsetsMake(46 + 4,(self.width - textSize.width)/2 - 46, 0, 0);
    }
}

- (void)actionClicked:(SWActionSheetButton *)sender
{
    if (_clickedBlock) {
        _clickedBlock();
    }
    if (sender.item.block) {
        sender.item.block();
    }
}

@end


@interface SWActionSheet()
@property (nonatomic,strong) UIView *sheetViewBackgroundView;
@property (nonatomic,strong) UIView *backgroundView;
@property (nonatomic,assign) SWActionSheetType type;
@end

@implementation SWActionSheet

- (instancetype)initWithType:(SWActionSheetType)type items:(NSArray *)items title:(NSString *)title {
    
    if (self = [super initWithFrame:[[UIScreen mainScreen] bounds]]) {
        self.backgroundColor = [UIColor clearColor];
        _type = type;
        _backgroundView = [[UIView alloc] initWithFrame:self.frame];
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.alpha = 0;
        [self addSubview:_backgroundView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        tap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tap];
        CGFloat sheetViewBackgroundViewHeight = (title.length > 0? kSWActionSheetTitleHeight:0) +
                                                ((SWActionSheetTypeShare == type || SWActionSheetTypeShareWithEdit == type) ? kSWActionSheetShareHeight:items.count * kSWActionSheetButtonHeight) +
                                                (SWActionSheetTypeShareWithEdit == type ? kSWActionSheetButtonHeight:0) +
                                                (SWActionSheetTypeNoCancel == type || SWActionSheetTypeMiddle == type? 0:kSWActionSheetCancelSpace +
                                                kSWActionSheetButtonHeight);
        
        _sheetViewBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(SWActionSheetTypeMiddle == type? 15:0,
                                                                            self.height,
                                                                            SWActionSheetTypeMiddle == type? self.width - 15*2:self.width,
                                                                            sheetViewBackgroundViewHeight)];
        
        if (SWActionSheetTypeMiddle == type)
        {
            _sheetViewBackgroundView.layer.cornerRadius = 5;
            _sheetViewBackgroundView.layer.masksToBounds = YES;
        }
        
        CGFloat height = 0;
        
        if (title.length > 0) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height, _sheetViewBackgroundView.width, kSWActionSheetTitleHeight)];
            titleLabel.text = title;
            titleLabel.textColor = [UIColor hexChangeFloat:@"acacac"];
            titleLabel.backgroundColor = [UIColor whiteColor];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = SWFONT(13);
            
            [_sheetViewBackgroundView addSubview:titleLabel];
            
            UIImageView *lineImageHView = [[UIImageView alloc] initWithFrame:CGRectMake(8, kSWActionSheetTitleHeight - 1, _sheetViewBackgroundView.width - (8 * 2) , 1)];
            lineImageHView.image = [UIImage imageNamed:@"Public_px_line"];
            
            [_sheetViewBackgroundView addSubview:lineImageHView];
            
            height += kSWActionSheetTitleHeight;
        }
        
        UIView *buttonContentView = nil;
        if (SWActionSheetTypeShare == type || SWActionSheetTypeShareWithEdit == type)
        {
            buttonContentView = [[UIView alloc] initWithFrame:CGRectMake(0, height, _sheetViewBackgroundView.width, kSWActionSheetShareHeight)];
            buttonContentView.backgroundColor = [UIColor whiteColor];
            [_sheetViewBackgroundView addSubview:buttonContentView];
        }
        
        for (int i = 0; i < items.count; i++)
        {
            SWActionSheetItem *item = items[i];
            if (SWActionSheetTypeShare == type)
            {
                NSUInteger with = _sheetViewBackgroundView.width - 4;
                NSUInteger buttonWith = 46 + 16*2;
                NSUInteger splitWith = (with/items.count - buttonWith)/2;
                
                SWActionSheetButton *actionButton = [[SWActionSheetButton alloc] initWithFrame:CGRectMake(4 + (with/items.count) * i + splitWith,height + 15, buttonWith, 46 + 5 + 13)];
                actionButton.item = item;
                WS(weakSelf);
                actionButton.clickedBlock = ^{
                    [weakSelf dismiss];
                };
                [_sheetViewBackgroundView addSubview:actionButton];
            }
            else if (SWActionSheetTypeShareWithEdit == type)
            {
                SWActionSheetButton *actionButton = nil;
                WS(weakSelf);
                if (i == items.count - 1)
                {
                    actionButton = [[SWActionSheetButton alloc] initWithFrame:CGRectMake(0,buttonContentView.bottomY, _sheetViewBackgroundView.width, kSWActionSheetButtonHeight)];
                    actionButton.item = item;
                    actionButton.clickedBlock = ^{
                        [weakSelf dismiss];
                    };
                    
                    UIView *lineImageHView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 0, _sheetViewBackgroundView.width - (8 * 2) , 1)];
                    lineImageHView.backgroundColor = [UIColor hexChangeFloat:@"b7b7b7"];
                    [actionButton addSubview:lineImageHView];
                    
                    [_sheetViewBackgroundView addSubview:actionButton];
                    if (i < items.count - 1) {
                        UIView *lineImageHView = [[UIImageView alloc] initWithFrame:CGRectMake(8, kSWActionSheetButtonHeight - 1, _sheetViewBackgroundView.width - (8 * 2) , 1)];
                        lineImageHView.backgroundColor = [UIColor hexChangeFloat:@"b7b7b7"];
                        [actionButton addSubview:lineImageHView];
                    }
                }
                else
                {
                    NSUInteger with = _sheetViewBackgroundView.width - 4;
                    NSUInteger buttonWith = 46 + 16*2;
                    NSUInteger splitWith = (with/(items.count-1) - buttonWith)/2;
                    
                    SWActionSheetButton *actionButton = [[SWActionSheetButton alloc] initWithFrame:CGRectMake(4 + (with/(items.count-1)) * i + splitWith,height + 15, buttonWith, 46 + 5 + 13)];
                    actionButton.item = item;
                    actionButton.clickedBlock = ^{
                        [weakSelf dismiss];
                    };
                    [_sheetViewBackgroundView addSubview:actionButton];
                }
            }
            else
            {
                SWActionSheetButton *actionButton = [[SWActionSheetButton alloc] initWithFrame:CGRectMake(0,height + kSWActionSheetButtonHeight * i, _sheetViewBackgroundView.width, kSWActionSheetButtonHeight)];
                actionButton.item = item;
                WS(weakSelf);
                actionButton.clickedBlock = ^{
                    [weakSelf dismiss];
                };
                
                [_sheetViewBackgroundView addSubview:actionButton];
                if (![actionButton.titleLabel.text isEqualToString:@"使用Facebook注册"] && ![actionButton.titleLabel.text isEqualToString:@"使用微博注册"] && ![actionButton.titleLabel.text isEqualToString:@"使用邮箱注册"])
                {
                    if (i < items.count - 1) {
                        UIView *lineImageHView = [[UIImageView alloc] initWithFrame:CGRectMake(8, kSWActionSheetButtonHeight - 1, _sheetViewBackgroundView.width - (8 * 2) , 1)];
                        lineImageHView.backgroundColor = [UIColor hexChangeFloat:@"b7b7b7"];
                        [actionButton addSubview:lineImageHView];
                    }
                }
            }
        }
        
        _sheetViewBackgroundView.backgroundColor = [UIColor clearColor];
        if (SWActionSheetTypeNoCancel != type && SWActionSheetTypeMiddle != type)
        {
            SWActionSheetButton *cancelButton = [[SWActionSheetButton alloc] initWithFrame:CGRectMake(0, sheetViewBackgroundViewHeight - kSWActionSheetButtonHeight, _sheetViewBackgroundView.width, kSWActionSheetButtonHeight)];
            [cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
            [cancelButton setTitle:SWStringCancel forState:UIControlStateNormal];
            [cancelButton setTitleColor:[UIColor hexChangeFloat:@"494949"] forState:UIControlStateNormal];
            [_sheetViewBackgroundView addSubview:cancelButton];
        }
        [self addSubview:_sheetViewBackgroundView];
        
    }
    return self;
}


- (void)show
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        _backgroundView.alpha = .4f;
        _sheetViewBackgroundView.y = (SWActionSheetTypeMiddle == _type? (self.height - _sheetViewBackgroundView.height)/2  : self.height - _sheetViewBackgroundView.height);
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}

- (void)dismiss
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.25 animations:^{
        _backgroundView.alpha = 0;
        _sheetViewBackgroundView.y = self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}

@end
