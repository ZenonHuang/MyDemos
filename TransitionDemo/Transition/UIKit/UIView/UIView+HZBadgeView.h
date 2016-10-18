
#import "LKBadgeView.h"
#import <UIKit/UIKit.h>

@interface HZCircleView : UIView

@end

@interface UIView (HZBadgeView)

@property (nonatomic, assign) CGRect badgeViewFrame;
@property (nonatomic, strong, readonly) LKBadgeView *badgeView;

- (HZCircleView *)setupCircleBadge;

- (void)destroyCircleBadge;

@end
