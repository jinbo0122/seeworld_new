//
//  DWTagList.h
//
//  Created by Dominic Wroblewski on 07/07/2012.
//  Copyright (c) 2012 Terracoding LTD
//

#import <UIKit/UIKit.h>

@protocol DWTagListDelegate, DWTagViewDelegate;

@interface DWTagList : UIScrollView
{
    UIView      *view;
    NSArray     *textArray;
    CGSize      sizeFit;
    UIColor     *lblBackgroundColor;
}

@property (nonatomic, assign) BOOL viewOnly;
@property (nonatomic, assign) BOOL showTagMenu;
@property (nonatomic, assign) BOOL longPressShowMenu;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) NSArray *textArray;
@property (nonatomic, weak) id<DWTagListDelegate> tagDelegate;
@property (nonatomic, strong) UIColor *highlightedBackgroundColor;
@property (nonatomic, assign) BOOL automaticResize;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) CGFloat labelMargin;
@property (nonatomic, assign) CGFloat bottomMargin;
@property (nonatomic, assign) CGFloat horizontalPadding;
@property (nonatomic, assign) CGFloat verticalPadding;
@property (nonatomic, assign) CGFloat minimumWidth;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *textShadowColor;
@property (nonatomic, assign) CGSize textShadowOffset;
@property (nonatomic, strong) UIColor *textBackColor;
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, assign) NSInteger defaultSelected;//默认选中第几项，add by xiongchen
@property (nonatomic, assign) CGRect   lastTextRect;             //add by xiongchen 最后一个字符的rect


- (void)setTagBackgroundColor:(UIColor *)color;
- (void)setTagHighlightColor:(UIColor *)color;
- (void)setTags:(NSArray *)array;
- (void)setSelected:(NSInteger)defaultSelected;
- (void)display;
- (CGSize)fittedSize;
- (void)scrollToBottomAnimated:(BOOL)animated;
@end

@interface DWTagView : UIView

@property (nonatomic, strong) UIButton              *button;
@property (nonatomic, strong) UILabel               *label;
@property (nonatomic, weak)   id<DWTagViewDelegate> delegate;

- (void)updateWithString:(NSString*)text
                    font:(UIFont*)font
      constrainedToWidth:(CGFloat)maxWidth
                 padding:(CGSize)padding
            minimumWidth:(CGFloat)minimumWidth
           needLongTouch:(BOOL)longTouch;
- (void)setLabelText:(NSString*)text;
- (void)setCornerRadius:(CGFloat)cornerRadius;
- (void)setBorderColor:(CGColorRef)borderColor;
- (void)setBorderWidth:(CGFloat)borderWidth;
- (void)setTextColor:(UIColor*)textColor;
- (void)setTextShadowColor:(UIColor*)textShadowColor;
- (void)setTextShadowOffset:(CGSize)textShadowOffset;

@end


@protocol DWTagListDelegate <NSObject>

@optional

- (void)selectedTag:(NSString *)tagName tagIndex:(NSInteger)tagIndex;
- (void)selectedTag:(NSString *)tagName;
- (void)deletedTag:(NSInteger)tagIndex;
- (void)tagListTagsChanged:(DWTagList *)tagList;

@end

@protocol DWTagViewDelegate <NSObject>

@required

- (void)tagViewWantsToBeDeleted:(DWTagView *)tagView;

@end
