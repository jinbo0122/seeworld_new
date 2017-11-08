//
//  YVIew+Ext.h
//  
//
//  Created by  on 15/4/22.
//  
//

#import <UIKit/UIKit.h>

@interface UIView(Ext)

/**
 * @brief Shortcut for frame.origin.x.
 *        Sets frame.origin.x = originX
 */
@property (nonatomic, assign) CGFloat x;

/**
 * @brief Shortcut for frame.origin.y
 *        Sets frame.origin.y = y
 */
@property (nonatomic, assign) CGFloat y;

/**
 * @brief Shortcut for frame.origin.x + frame.size.width
 *       Sets frame.origin.x = rightX - frame.size.width
 */
@property (nonatomic, assign) CGFloat rightX;

/**
 * @brief Shortcut for frame.origin.y + frame.size.height
 *        Sets frame.origin.y = bottomY - frame.size.height
 */
@property (nonatomic, assign) CGFloat bottomY;

/**
 * @brief Shortcut for frame.size.width
 *        Sets frame.size.width = width
 */
@property (nonatomic, assign) CGFloat width;

/**
 * @brief Shortcut for frame.size.height
 *        Sets frame.size.height = height
 */
@property (nonatomic, assign) CGFloat height;

/**
 * @brief Shortcut for center.x
 * Sets center.x = centerX
 */
@property (nonatomic, assign) CGFloat centerX;

/**
 * @brief Shortcut for center.y
 *        Sets center.y = centerY
 */
@property (nonatomic, assign) CGFloat centerY;

/**
 * @brief Shortcut for frame.origin
 */
@property (nonatomic, assign) CGPoint origin;

/**
 * @brief Shortcut for frame.size
 */
@property (nonatomic, assign) CGSize size;


/** Helps clean up code for changing UIView frames.
 
 Instead of creating a CGRect struct, changing properties and reassigning. For example, moving a UIView newX points to the left:
 
 CGRect frame = view.frame;
 frame.origin x = (CGFloat)newX + view.frame.size.width;
 view.frame = frame;
 
 This can be cleaned up to:
 
 view.left += newX;
 
 Properties bottom and right also take into account the width of the UIView.
 */

///---------------------------------------------------------------------------------------
/// @name Edges
///---------------------------------------------------------------------------------------

/** Get the left point of a view. */
@property (nonatomic) CGFloat left;

/** Get the top point of a view. */
@property (nonatomic) CGFloat top;

/** Get the right point of a view. */
@property (nonatomic) CGFloat right;

/** Get the bottom point of a view. */
@property (nonatomic) CGFloat bottom;


///< 移除此view上的所有子视图
- (void)removeAllSubviews;

-(void)setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius;

-(void)addGestureTabRecognizerWithTarget:(id)target action:(SEL)action;

- (UIView *)firstResponderView;
- (void)logView;

@end
