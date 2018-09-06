




#import <Foundation/Foundation.h>

@interface NSObject (Throttle)

- (void)hz_performSelector:(SEL)aSelector withThrottle:(NSTimeInterval)inteval;

@end
