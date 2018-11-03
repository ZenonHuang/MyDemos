#import <UIKit/UIKit.h>

@interface UIDevice (KWS)

@property (nonatomic, readonly) NSString *machineModel;
@property (nonatomic, readonly) NSString *machineModelName;

- (BOOL)isLowPerformanceDevice;

- (NSString*)hy_systemVersion;

- (BOOL)isIPhone4sOrLower;

- (BOOL)isIPhone5sOrLower;

- (BOOL)isIPhone6OrLower;

- (BOOL)isIPhone8PlusOrLower;

- (BOOL)isIPhoneXOrHigher;

- (BOOL)isLowerThanIPad3;

- (BOOL)isIPhoneLowerThan:(NSString *)modelName;

- (BOOL)isIPadLowerThan:(NSString *)modelName;

- (BOOL)isARM64;

@end
