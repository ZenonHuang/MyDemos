//
//  HZRangeSlider.h
//  HZRangeSlider
//
//  Created by zz go on 2017/5/5.
//  Copyright © 2017年 zzgo. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface HZRangeSlider : UIControl

/**
 *  Minimum value (Default: 0.0)
 */
@property (nonatomic) IBInspectable CGFloat minimumValue;

/**
 *  Maximum value (Default: 1.0)
 */
@property (nonatomic) IBInspectable CGFloat maximumValue;

/**
 *  Minimum range value (Default: 0.0)
 */
@property (nonatomic) IBInspectable CGFloat minimumRange;

/**
 *  Maximum range value (Default: 1.0)
 */
@property (nonatomic) IBInspectable CGFloat maximumRange;



/**
   Set minimum and maximum range at the same time.
   This helps to avoid validation errors when setting each
   of components separately.

 @param minimumRange 最小范围
 @param maximumRange 最大范围
 */
- (void)setMinimumRange:(CGFloat)minimumRange maximumRange:(CGFloat)maximumRange;


/**
 Set minimum and maximum value at the same time.
 This helps to avoid validation errors when setting each
 of components separately.

 @param minimumValue 最小值
 @param maximumValue 最大值
 */
- (void)setMinimumValue:(CGFloat)minimumValue maximumValue:(CGFloat)maximumValue;

@end
