//
//  UIImage+Gray.h
//  WaterMarkForLSB
//
//  Created by zz go on 2021/2/4.
//


#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, GrayImageType) {
    GrayImageTypeAverage,
    GrayImageTypeWeightedAverage,
    GrayImageTypeMax,
    GrayImageTypeRed,
    GrayImageTypeGreen,
    GrayImageTypeBlue
};

@interface UIImage (Gray)
+ (UIImage *)grayForImage:(UIImage*)image forType:(GrayImageType)type;

/**
 二值化, scale 为阀值系数 0-1.
 */
- (UIImage *)covertToBinaryzation:(float)scale;
@end
