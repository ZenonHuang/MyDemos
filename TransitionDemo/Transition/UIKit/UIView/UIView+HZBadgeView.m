

#import "UIView+HZBadgeView.h"

#import <objc/runtime.h>

@implementation HZCircleView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddEllipseInRect(context, CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetHeight(rect)));
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.829 green:0.194 blue:0.257 alpha:1.000].CGColor);
    
    CGContextFillPath(context);
}

@end


static NSString const * HZBadgeViewKey = @"HZBadgeViewKey";
static NSString const * HZBadgeViewFrameKey = @"HZBadgeViewFrameKey";

static NSString const * HZCircleBadgeViewKey = @"HZCircleBadgeViewKey";

@implementation UIView (HZBadgeView)

- (void)setBadgeViewFrame:(CGRect)badgeViewFrame {
    objc_setAssociatedObject(self, &HZBadgeViewFrameKey, NSStringFromCGRect(badgeViewFrame), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)badgeViewFrame {
    return CGRectFromString(objc_getAssociatedObject(self, &HZBadgeViewFrameKey));
}

- (LKBadgeView *)badgeView {
    LKBadgeView *badgeView = objc_getAssociatedObject(self, &HZBadgeViewKey);
    if (badgeView)
        return badgeView;
    
    badgeView = [[LKBadgeView alloc] initWithFrame:self.badgeViewFrame];
    [self addSubview:badgeView];
    
    self.badgeView = badgeView;
    
    return badgeView;
}

- (void)setBadgeView:(LKBadgeView *)badgeView {
    objc_setAssociatedObject(self, &HZBadgeViewKey, badgeView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HZCircleView *)setupCircleBadge {
    self.opaque = NO;
    self.clipsToBounds = NO;
    CGRect circleViewFrame = CGRectMake(CGRectGetWidth(self.bounds) - 4, 0, 8, 8);
    
    HZCircleView *circleView = objc_getAssociatedObject(self, &HZCircleBadgeViewKey);
    if (!circleView) {
        circleView = [[HZCircleView alloc] initWithFrame:circleViewFrame];
        [self addSubview:circleView];
        objc_setAssociatedObject(self, &HZCircleBadgeViewKey, circleView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    circleView.frame = circleViewFrame;
    circleView.hidden = NO;

    return circleView;
}

- (void)destroyCircleBadge {
    HZCircleView *circleView = objc_getAssociatedObject(self, &HZCircleBadgeViewKey);
    if (circleView) {
        circleView.hidden = YES;
    }
}

@end
