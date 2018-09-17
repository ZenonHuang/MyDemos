//
//  HZRangeSlider.m
//  HZRangeSlider
//
//  Created by zz go on 2017/5/5.
//  Copyright © 2017年 zzgo. All rights reserved.
//

#import "HZRangeSlider.h"
#import <float.h>

/**
 *  Shadow height. Affects vertical center for track views.
 */
static CGFloat kShadowVerticalOffset = 1.0;

/**
 *  The size of thumb's arc.
 */
static CGFloat kThumbDimension = 24.0;

/**
 *  Track height
 */
static CGFloat kTrackDimension = 8.0;

/**
 * Thumb hit expansion, both vertical and horizontal.
 */
static CGFloat kThumbHitExpansion = 10;


@interface HZRangeSliderThumb : UIImageView
@end

@implementation HZRangeSliderThumb

/*
 Override hit test to make larger hit area for thumbs. 
 This does not come without false positives, but
 should not create much confusion on touch devices until certain threshold
 of expansion area.
 */
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect rect = CGRectInset([self bounds], -kThumbHitExpansion, -kThumbHitExpansion);
    
    return CGRectContainsPoint(rect, point);
}

@end

@interface HZRangeSlider ()

@property (nonatomic) UIImageView *minimumRangeView;
@property (nonatomic) UIImageView *maximumRangeView;

@property (nonatomic) UIImageView *trackView;
@property (nonatomic) UIImageView *filledTrackView;

@property (nonatomic) NSLayoutConstraint *minimimRangeConstraint;
@property (nonatomic) NSLayoutConstraint *maximumRangeConstraint;
@property (nonatomic) NSLayoutConstraint *trackCenterYConstraint;

@property (nonatomic) UIView *draggingView;
@property (nonatomic) CGPoint draggingViewTouchPoint;

@property (nonatomic) NSMutableDictionary *runtimeAttributes;
@property (nonatomic) BOOL shouldCaptureRuntimeAttributes;

@end

@implementation HZRangeSlider

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(!self) {
        return nil;
    }
    
    [self setup];
    
#if TARGET_INTERFACE_BUILDER
    
    /*
     Interface builder calls -initWithFrame: instead of -initWithCoder:
     */
    self.runtimeAttributes = [[NSMutableDictionary alloc] init];
    self.shouldCaptureRuntimeAttributes = YES;
    
#endif
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(!self) {
        return nil;
    }
    
    [self setup];
    
    self.runtimeAttributes = [[NSMutableDictionary alloc] init];
    self.shouldCaptureRuntimeAttributes = YES;
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self applyRuntimeAttributes];
}

- (void)prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];
    
    [self applyRuntimeAttributes];
}

- (void)applyRuntimeAttributes {
    /*
     Apply runtime attributes in specific order
     */
    
    NSDictionary *runtimeAttributes = self.runtimeAttributes;
    
    self.runtimeAttributes = nil;
    self.shouldCaptureRuntimeAttributes = NO;
    
    NSNumber *minimumRange = runtimeAttributes[NSStringFromSelector(@selector(minimumRange))];
    NSNumber *maximumRange = runtimeAttributes[NSStringFromSelector(@selector(maximumRange))];
    NSNumber *minimumValue = runtimeAttributes[NSStringFromSelector(@selector(minimumValue))];
    NSNumber *maximumValue = runtimeAttributes[NSStringFromSelector(@selector(maximumValue))];
    
    /*
     Set min/max ranges before setting values.
     */
    if(minimumRange) {
        self.minimumRange = minimumRange.doubleValue;
        self.minimumValue = self.minimumRange;
    }
    
    if(maximumRange) {
        self.maximumRange = maximumRange.doubleValue;
        self.maximumValue = self.maximumRange;
    }
    
    if(minimumValue) {
        self.minimumValue = minimumValue.doubleValue;
    }
    
    if(maximumValue) {
        self.maximumValue = maximumValue.doubleValue;
    }
}

- (void)setBounds:(CGRect)bounds {
    CGRect oldBounds = self.bounds;
    
    [super setBounds:bounds];
    
    if(!CGRectEqualToRect(oldBounds, bounds)) {
        [self setNeedsUpdateConstraints];
    }
}

- (void)updateConstraints {
    [super updateConstraints];
    
    CGFloat entireRange = self.maximumRange - self.minimumRange;
    CGFloat minFraction = (self.minimumValue - self.minimumRange) / entireRange;
    CGFloat maxFraction = (self.maximumValue - self.minimumRange) / entireRange;
    
    CGFloat minConstraintRange = [self minimumConstantForThumbLeadingConstraint];
    CGFloat maxConstraintRange = [self maximumConstantForThumbLeadingConstraint];
    
    self.minimimRangeConstraint.constant = minConstraintRange + (maxConstraintRange - minConstraintRange) * minFraction;
    self.maximumRangeConstraint.constant = minConstraintRange + (maxConstraintRange - minConstraintRange) * maxFraction;
}

- (void)tintColorDidChange {
    [super tintColorDidChange];
    
    [self updateThumbImages];
}

- (void)setup {
    /*
     Setup default values
     */
    
    _minimumValue = 0;
    _maximumValue = 1;
    _minimumRange = 0;
    _maximumRange = 1;
    
    /*
     Create subviews
     */
    self.minimumRangeView = [[HZRangeSliderThumb alloc] initWithImage:nil];
    self.minimumRangeView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.maximumRangeView = [[HZRangeSliderThumb alloc] initWithImage:nil];
    self.maximumRangeView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.trackView = [[UIImageView alloc] initWithImage:[self trackImage]];
    self.trackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.filledTrackView = [[UIImageView alloc] initWithImage:[self filledTrackImage]];
    self.filledTrackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    /*
     Add subviews
     */
    [self addSubview:self.trackView];
    [self addSubview:self.filledTrackView];
    [self addSubview:self.minimumRangeView];
    [self addSubview:self.maximumRangeView];
    
    /*
     Create track view constraints
     */
    self.trackCenterYConstraint = [self.trackView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor];
    self.trackCenterYConstraint.constant = kShadowVerticalOffset * -1;
    self.trackCenterYConstraint.active = YES;
    
    [self.trackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.trackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    
    /*
     Create filled track view constraints
     */
    [self.filledTrackView.centerYAnchor constraintEqualToAnchor:self.trackView.centerYAnchor].active = YES;
    [self.filledTrackView.leadingAnchor constraintEqualToAnchor:self.minimumRangeView.centerXAnchor].active = YES;
    [self.filledTrackView.trailingAnchor constraintEqualToAnchor:self.maximumRangeView.centerXAnchor].active = YES;
    
    /*
     Break intrinsic content size of filled track when both thumbs intersect
     */
    [self.filledTrackView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.filledTrackView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    
    /*
     Create minimum range view constraints
     */
    [self.minimumRangeView.topAnchor constraintGreaterThanOrEqualToAnchor:self.topAnchor].active = YES;
    [self.minimumRangeView.bottomAnchor constraintGreaterThanOrEqualToAnchor:self.bottomAnchor].active = YES;
    [self.minimumRangeView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    
    /*
     Create maximum range view constrants
     */
    [self.maximumRangeView.topAnchor constraintGreaterThanOrEqualToAnchor:self.topAnchor].active = YES;
    [self.maximumRangeView.bottomAnchor constraintGreaterThanOrEqualToAnchor:self.bottomAnchor].active = YES;
    [self.maximumRangeView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    
    /*
     Constraint both minimum and maximum range views to the beginning of track view
     */
    self.minimimRangeConstraint = [self.minimumRangeView.leadingAnchor constraintEqualToAnchor:self.trackView.leadingAnchor];
    self.maximumRangeConstraint = [self.maximumRangeView.leadingAnchor constraintEqualToAnchor:self.trackView.leadingAnchor];
    
    self.minimimRangeConstraint.active = YES;
    self.maximumRangeConstraint.active = YES;
    
    /*
     Generate assets for thumbs
     */
    [self updateThumbImages];
}

#pragma mark - Accessors
#pragma mark -

- (void)setMinimumValue:(CGFloat)minimumValue {
    if(self.shouldCaptureRuntimeAttributes) {
        self.runtimeAttributes[NSStringFromSelector(@selector(minimumValue))] = @(minimumValue);
        return;
    }
    
    if( fabs(minimumValue - _minimumValue) < FLT_EPSILON ) {
        return;
    }
    
    if(minimumValue > self.maximumValue) {
        minimumValue = self.maximumValue;
    }
    
    _minimumValue = MIN(self.maximumRange, MAX(minimumValue, self.minimumRange));
    
    [self setNeedsUpdateConstraints];
}

- (void)setMaximumValue:(CGFloat)maximumValue {
    if(self.shouldCaptureRuntimeAttributes) {
        self.runtimeAttributes[NSStringFromSelector(@selector(maximumValue))] = @(maximumValue);
        return;
    }
    
    if( fabs(maximumValue - _maximumValue) < FLT_EPSILON ) {
        return;
    }
    
    if(maximumValue < self.minimumValue) {
        maximumValue = self.minimumValue;
    }
    
    _maximumValue = MIN(self.maximumRange, MAX(maximumValue, self.minimumRange));;
    
    [self setNeedsUpdateConstraints];
}

- (void)setMinimumRange:(CGFloat)minimumRange {
    if(self.shouldCaptureRuntimeAttributes) {
        self.runtimeAttributes[NSStringFromSelector(@selector(minimumRange))] = @(minimumRange);
        return;
    }
    
    if( fabs(minimumRange - _minimumRange) < FLT_EPSILON ) {
        return;
    }
    
    _minimumRange = minimumRange;
    
    if(_minimumValue < minimumRange) {
        _minimumValue = minimumRange;
        
        [self setNeedsUpdateConstraints];
    }
}

- (void)setMaximumRange:(CGFloat)maximumRange {
    if(self.shouldCaptureRuntimeAttributes) {
        self.runtimeAttributes[NSStringFromSelector(@selector(maximumRange))] = @(maximumRange);
        return;
    }
    
    if( fabs(maximumRange - _maximumRange) < FLT_EPSILON ) {
        return;
    }
    
    _maximumRange = maximumRange;
    
    if(_maximumValue > maximumRange) {
        _maximumValue = maximumRange;
        
        [self setNeedsUpdateConstraints];
    }
}

- (void)setMinimumRange:(CGFloat)minimumRange maximumRange:(CGFloat)maximumRange {
    NSAssert(minimumRange <= maximumRange, @"minimumRange cannot be greater than maximumRange");
    
    if( fabs(minimumRange - _minimumRange) < FLT_EPSILON && fabs(maximumRange - _maximumRange) < FLT_EPSILON ) {
        return;
    }
    
    _minimumRange = minimumRange;
    _maximumRange = maximumRange;
    
    if(_maximumValue > maximumRange) {
        _maximumValue = maximumRange;
    }
    
    if(_minimumValue < minimumRange) {
        _minimumValue = minimumRange;
    }
    
    [self setNeedsUpdateConstraints];
}

- (void)setMinimumValue:(CGFloat)minimumValue maximumValue:(CGFloat)maximumValue {
    NSAssert(minimumValue <= maximumValue, @"minimumValue cannot be greater than maximumValue");
    
    if( fabs(minimumValue - _minimumValue) < FLT_EPSILON && fabs(maximumValue - _maximumValue) < FLT_EPSILON ) {
        return;
    }
    
    if(minimumValue < _minimumRange) {
        minimumValue = _minimumRange;
    }
    
    if(maximumValue > _maximumRange) {
        maximumValue = _maximumRange;
    }
    
    _minimumValue = minimumValue;
    _maximumValue = maximumValue;
    
    [self setNeedsUpdateConstraints];
}

#pragma mark - Asset generator
#pragma mark -

- (void)updateThumbImages {
    self.minimumRangeView.image = [self thumbImageWithFillColor:self.tintColor];
    self.maximumRangeView.image = [self thumbImageWithFillColor:self.tintColor];
}

- (UIImage *)thumbImageWithFillColor:(UIColor *)fillColor {
    CGSize size = CGSizeMake(kThumbDimension, kThumbDimension);
    CGFloat radius = size.width * 0.5;
    CGFloat shadowBlur = 2.0;
    UIColor *shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    size.width += shadowBlur * 2;
    size.height += shadowBlur * 2 + kShadowVerticalOffset;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(size.width * 0.5, size.height * 0.5) radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShadowWithColor(context, CGSizeMake(0, kShadowVerticalOffset), shadowBlur, shadowColor.CGColor);
    
    [fillColor setFill];
    [bezierPath fill];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)trackImageWithFillColor:(UIColor *)fillColor
                         strokeColor:(UIColor *)strokeColor
                         strokeWidth:(CGFloat)strokeWidth
{
    CGSize size = CGSizeMake(kTrackDimension, kTrackDimension);
    CGFloat radius = size.width * 0.5 - strokeWidth * 0.5;
    CGPoint arcCenter = CGPointMake(size.width * 0.5, size.height * 0.5);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    bezierPath.lineWidth = strokeWidth;
    
    if(fillColor) {
        [fillColor setFill];
        [bezierPath fill];
    }
    
    if(strokeColor) {
        [strokeColor setStroke];
        [bezierPath stroke];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIEdgeInsets stretchInsets = UIEdgeInsetsMake(0, size.width * 0.5, 0, size.width * 0.5);
    
    return [image resizableImageWithCapInsets:stretchInsets resizingMode:UIImageResizingModeTile];
}

- (UIImage *)trackImage {
    return [self trackImageWithFillColor:nil strokeColor:self.tintColor strokeWidth:1];
}

- (UIImage *)filledTrackImage {
    return [self trackImageWithFillColor:self.tintColor strokeColor:nil strokeWidth:0];
}

#pragma mark - Events handling
#pragma mark -

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    /*
     Find topmost range view
     */
    for(NSInteger i = self.subviews.count - 1; i >= 0; i--) {
        UIView *view = self.subviews[i];
        
        if(view != self.minimumRangeView && view != self.maximumRangeView) {
            continue;
        }
        
        CGPoint point = [touch locationInView:view];
        
        if([view pointInside:point withEvent:event]) {
            self.draggingViewTouchPoint = point;
            self.draggingView = view;
            
            [self bringSubviewToFront:view];
            
            return YES;
        }
    }
    
    return NO;
}

- (CGFloat)horizontalShadowOverlap {
    return (self.minimumRangeView.image.size.width - kThumbDimension) * 0.5;
}

- (CGFloat)minimumConstantForThumbLeadingConstraint {
    return [self horizontalShadowOverlap] * -1;
}

- (CGFloat)maximumConstantForThumbLeadingConstraint {
    return CGRectGetWidth(self.bounds) - kThumbDimension - [self horizontalShadowOverlap];
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = CGPointApplyAffineTransform([touch locationInView:self], CGAffineTransformMakeTranslation(-self.draggingViewTouchPoint.x, -self.draggingViewTouchPoint.y));
    
    CGFloat minConstraintRange = [self minimumConstantForThumbLeadingConstraint];
    CGFloat maxConstraintRange = [self maximumConstantForThumbLeadingConstraint];
    
    CGFloat fraction = (location.x - minConstraintRange ) / (maxConstraintRange - minConstraintRange);
    CGFloat value = self.minimumRange + (self.maximumRange - self.minimumRange) * fraction;

    if(self.draggingView == self.minimumRangeView) {
        self.minimumValue = value;
    }
    else if(self.draggingView == self.maximumRangeView) {
        self.maximumValue = value;
    }
    
    [self layoutIfNeeded];
    //sendActionsForControlEvents实现代码自动触发UIControlEventTouchUpInside事件。
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    self.draggingView = nil;
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    self.draggingView = nil;
}

@end
