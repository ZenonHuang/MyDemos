#import "UIDevice+KWS.h"
#include <sys/sysctl.h>

@implementation UIDevice (KWS)

- (NSString *)machineModel
{
    static dispatch_once_t one;
    static NSString *model;
    dispatch_once(&one, ^{
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        model = [NSString stringWithUTF8String:machine];
        free(machine);
    });
    return model;
}

- (NSString*)hy_systemVersion
{
    static dispatch_once_t one;
    static NSString *system;
    dispatch_once(&one, ^{
        system = [[UIDevice currentDevice] systemVersion];
    });
    return system;
}

- (NSString *)machineModelName {
    static dispatch_once_t one;
    static NSString *name;
    dispatch_once(&one, ^{
        NSString *model = [self machineModel];
        if (!model) return;
        NSDictionary *dic = @{
                              @"Watch1,1" : @"Apple Watch 38mm",
                              @"Watch1,2" : @"Apple Watch 42mm",
                              @"Watch2,3" : @"Apple Watch Series 2 38mm",
                              @"Watch2,4" : @"Apple Watch Series 2 42mm",
                              @"Watch2,6" : @"Apple Watch Series 1 38mm",
                              @"Watch1,7" : @"Apple Watch Series 1 42mm",
                              
                              @"iPod1,1" : @"iPod touch 1",
                              @"iPod2,1" : @"iPod touch 2",
                              @"iPod3,1" : @"iPod touch 3",
                              @"iPod4,1" : @"iPod touch 4",
                              @"iPod5,1" : @"iPod touch 5",
                              @"iPod7,1" : @"iPod touch 6",
                              
                              @"iPhone1,1" : @"iPhone 1G",
                              @"iPhone1,2" : @"iPhone 3G",
                              @"iPhone2,1" : @"iPhone 3GS",
                              @"iPhone3,1" : @"iPhone 4 (GSM)",
                              @"iPhone3,2" : @"iPhone 4",
                              @"iPhone3,3" : @"iPhone 4 (CDMA)",
                              @"iPhone4,1" : @"iPhone 4S",
                              @"iPhone5,1" : @"iPhone 5",
                              @"iPhone5,2" : @"iPhone 5",
                              @"iPhone5,3" : @"iPhone 5c",
                              @"iPhone5,4" : @"iPhone 5c",
                              @"iPhone6,1" : @"iPhone 5s",
                              @"iPhone6,2" : @"iPhone 5s",
                              @"iPhone7,1" : @"iPhone 6 Plus",
                              @"iPhone7,2" : @"iPhone 6",
                              @"iPhone8,1" : @"iPhone 6s",
                              @"iPhone8,2" : @"iPhone 6s Plus",
                              @"iPhone8,4" : @"iPhone SE",
                              @"iPhone9,1" : @"iPhone 7",
                              @"iPhone9,2" : @"iPhone 7 Plus",
                              @"iPhone9,3" : @"iPhone 7",
                              @"iPhone9,4" : @"iPhone 7 Plus",
                              @"iPhone10,1": @"iPhone 8",
                              @"iPhone10,2": @"iPhone 8 Plus",
                              @"iPhone10,3": @"iPhone X",
                              @"iPhone10,4": @"iPhone 8",
                              @"iPhone10,5": @"iPhone 8 Plus",
                              @"iPhone10,6": @"iPhone X",
                              @"iPhone11,2": @"iPhone XS",
                              @"iPhone11,4": @"iPhone XS Max",
                              @"iPhone11,6": @"iPhone XS Max",
                              @"iPhone11,8": @"iPhone XR",
                              
                              @"iPad1,1" : @"iPad 1",
                              @"iPad2,1" : @"iPad 2 (WiFi)",
                              @"iPad2,2" : @"iPad 2 (GSM)",
                              @"iPad2,3" : @"iPad 2 (CDMA)",
                              @"iPad2,4" : @"iPad 2",
                              @"iPad2,5" : @"iPad mini 1",
                              @"iPad2,6" : @"iPad mini 1",
                              @"iPad2,7" : @"iPad mini 1",
                              @"iPad3,1" : @"iPad 3 (WiFi)",
                              @"iPad3,2" : @"iPad 3 (4G)",
                              @"iPad3,3" : @"iPad 3 (4G)",
                              @"iPad3,4" : @"iPad 4",
                              @"iPad3,5" : @"iPad 4",
                              @"iPad3,6" : @"iPad 4",
                              @"iPad4,1" : @"iPad Air",
                              @"iPad4,2" : @"iPad Air",
                              @"iPad4,3" : @"iPad Air",
                              @"iPad4,4" : @"iPad mini 2",
                              @"iPad4,5" : @"iPad mini 2",
                              @"iPad4,6" : @"iPad mini 2",
                              @"iPad4,7" : @"iPad mini 3",
                              @"iPad4,8" : @"iPad mini 3",
                              @"iPad4,9" : @"iPad mini 3",
                              @"iPad5,1" : @"iPad mini 4",
                              @"iPad5,2" : @"iPad mini 4",
                              @"iPad5,3" : @"iPad Air 2",
                              @"iPad5,4" : @"iPad Air 2",
                              @"iPad6,3" : @"iPad Pro (9.7 inch)",
                              @"iPad6,4" : @"iPad Pro (9.7 inch)",
                              @"iPad6,7" : @"iPad Pro (12.9 inch)",
                              @"iPad6,8" : @"iPad Pro (12.9 inch)",
                              @"iPad6,11": @"iPad 5",
                              @"iPad6,12": @"iPad 5",
                              @"iPad7,1" : @"iPad Pro 2 (12.9 inch)",
                              @"iPad7,2" : @"iPad Pro 2 (12.9 inch)",
                              @"iPad7,3" : @"iPad Pro (10.5 inch)",
                              @"iPad7,4" : @"iPad Pro (10.5 inch)",
                              @"iPad7,5" : @"iPad 6",
                              @"iPad7,6" : @"iPad 6",
                              
                              @"AppleTV2,1" : @"Apple TV 2",
                              @"AppleTV3,1" : @"Apple TV 3",
                              @"AppleTV3,2" : @"Apple TV 3",
                              @"AppleTV5,3" : @"Apple TV 4",
                              
                              @"i386" : @"Simulator x86",
                              @"x86_64" : @"Simulator x64",
                              };
        name = dic[model];
        if (!name) name = model;
    });
    return name;
}

- (BOOL)isLowPerformanceDevice
{
    return [self isIPhone4sOrLower] || [self isLowerThanIPad3];
}

- (BOOL)isIPhone4sOrLower
{
    return [self isIPhoneLowerThan:@"iPhone5,1"];
}

- (BOOL)isIPhone5sOrLower{
    return [self isIPhoneLowerThan:@"iPhone7,1"];
}

- (BOOL)isIPhone6OrLower
{
    return [self isIPhoneLowerThan:@"iPhone8,1"];
}

- (BOOL)isIPhone8PlusOrLower{
    //[10,3],[10,6]
    return [self isIPhoneLowerThan:@"iPhone10,6"];
}

- (BOOL)isIPhoneXOrHigher{
    return ![self isIPhone8PlusOrLower];
}
- (BOOL)isLowerThanIPad3
{
    return [self isIPadLowerThan:@"iPad3,1"];
}

- (BOOL)isIPhoneLowerThan:(NSString *)modelName
{
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone) {
        return NO;
    }
    
    NSComparisonResult result = [[self machineModel] compare:modelName options:NSNumericSearch];
    
    return result == NSOrderedAscending;
}

- (BOOL)isIPadLowerThan:(NSString *)modelName
{
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        return NO;
    }
    
    NSComparisonResult result = [[self machineModel] compare:modelName options:NSNumericSearch];
    
    return result == NSOrderedAscending;
}

- (BOOL)isARM64
{
#if defined(__arm64__)
    return YES;
#else
    return NO;
#endif
}

@end
