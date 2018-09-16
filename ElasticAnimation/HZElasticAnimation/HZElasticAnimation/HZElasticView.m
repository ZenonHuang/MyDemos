//
//  HZElasticView.m
//  HZElasticAnimation
//
//  Created by mewe on 2017/8/1.
//  Copyright © 2017年 zenon. All rights reserved.
//

#import "HZElasticView.h"


@interface HZElasticView ()
@property (nonatomic,strong) UIView *topControlPointView;
@property (nonatomic,strong) UIView *leftControlPointView;
@property (nonatomic,strong) UIView *bottomControlPointView;
@property (nonatomic,strong) UIView *rightControlPointView;
@property (nonatomic,strong) CAShapeLayer  *elasticShape;
@property (nonatomic,strong) CADisplayLink *displayLink;
@end

@implementation HZElasticView
#pragma mark - life cycle
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    self.overshootAmount=10;
    [self setupComponents];
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    self.overshootAmount=10;
    [self setupComponents];
    
    return self;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self startUpdateLoop];
    [self animateControlPoints];
}

#pragma mark - public
-(void) startUpdateLoop{
    self.displayLink.paused = NO;
}
-(void) stopUpdateLoop{
    self.displayLink.paused = YES;
}

-(void)animateControlPoints{
    //1
    CGFloat overshootAmount = self.overshootAmount;
    
    //2
    [UIView animateWithDuration:0.25 delay:0.0 usingSpringWithDamping:0.9 initialSpringVelocity:1.5 options:UIViewAnimationOptionCurveLinear animations:^{
        //3
        
//        self.topControlPointView.center.y  -= overshootAmount;
        CGPoint point= self.topControlPointView.center;
        point.y -=overshootAmount;
        self.topControlPointView.center = point;
        
//        self.leftControlPointView.center.x -= overshootAmount;
        point= self.leftControlPointView.center;
        point.x -=overshootAmount;
        self.leftControlPointView.center = point;
        
        
//        self.bottomControlPointView.center.y += overshootAmount;
        point= self.bottomControlPointView.center;
        point.y +=overshootAmount;
        self.bottomControlPointView.center = point;
        
//        self.rightControlPointView.center.x += overshootAmount;
        point= self.rightControlPointView.center;
        point.x +=overshootAmount;
        self.rightControlPointView.center = point;
        
        
    } completion:^(BOOL finished) {
        //4
        [UIView animateWithDuration:0.45 delay:0.0 usingSpringWithDamping:0.15 initialSpringVelocity:5.5 options:UIViewAnimationOptionCurveLinear animations:^{
            //5
            [self positionControlPoints];
        } completion:^(BOOL finished) {
            //6
            [self stopUpdateLoop];
        }];

    }];
    
//    UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1.5, options: UIViewAnimationOptions.curveLinear, animations: {
//        //3
//        self.topControlPointView.center.y -= overshootAmount
//        self.leftControlPointView.center.x -= overshootAmount
//        self.bottomControlPointView.center.y += overshootAmount
//        self.rightControlPointView.center.x += overshootAmount
//    }) { (_) in
//        //4
//        UIView.animate(withDuration: 0.45, delay: 0.0, usingSpringWithDamping: 0.15, initialSpringVelocity: 5.5, options: .curveLinear, animations: {
//            //5
//            self.positionControlPoints()
//        }, completion: { (_) in
//            //6
//            self.stopUpdateLoop()
//        })
//    }
    
}

#pragma mark - private
-(void)setupComponents{
    UIColor *bgColor = self.backgroundColor;
    self.backgroundColor = [UIColor clearColor];
    self.elasticShape.fillColor = bgColor.CGColor;
    self.elasticShape.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;//(rect: self.bounds).cgPath
    [self.layer addSublayer:self.elasticShape];
    

    
    for (UIView *controlPoint  in @[self.topControlPointView,self.leftControlPointView,self.bottomControlPointView,self.rightControlPointView] ){
        [self addSubview:controlPoint];
        controlPoint.frame = CGRectMake(0, 0, 5, 5);//CGRect(x: 0.0, y: 0.0, width: 5.0, height: 5.0)
        controlPoint.backgroundColor = [UIColor blueColor];
        //controlPoint.backgroundColor = UIColor.clear
    }
    
    [self positionControlPoints];
}

-(void)positionControlPoints{
    
    self.topControlPointView.center    = CGPointMake(CGRectGetMidX(self.bounds), 0);//CGPoint.init(x: bounds.midX, y: 0.0)
    self.leftControlPointView.center   = CGPointMake(0.0                       , CGRectGetMidY(self.bounds));
    self.bottomControlPointView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));
    self.rightControlPointView.center  = CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMidY(self.bounds));
    
}


-(CGPathRef )bezierPathForControlPoints{
    //1
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    //2
    CGPoint top = self.topControlPointView.layer.presentationLayer.position;
    CGPoint left = self.leftControlPointView.layer.presentationLayer.position;
    CGPoint bottom = self.bottomControlPointView.layer.presentationLayer.position;
    CGPoint right = self.rightControlPointView.layer.presentationLayer.position;
    
    CGFloat width =  self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    //3
    [path moveToPoint:CGPointMake(0, 0)];//move(to:CGPoint.init(x: 0, y: 0))
    
    [path addQuadCurveToPoint:CGPointMake(width, 0) controlPoint:top];//(to: CGPoint.init(x: width, y: 0), controlPoint: top!)
    [path addQuadCurveToPoint:CGPointMake(width, height) controlPoint:right];//(to: CGPoint.init(x: width, y: height), controlPoint: right!)
    [path addQuadCurveToPoint:CGPointMake(0, height) controlPoint:bottom];//(to: CGPoint.init(x: 0, y: height), controlPoint: bottom!)
    [path addQuadCurveToPoint:CGPointMake(0, 0) controlPoint:left];//(to: CGPoint.init(x: 0, y: 0), controlPoint: left!)
    
    //4
    return path.CGPath;
}


#pragma mark - action
-(void)updateLoop{
    self.elasticShape.path = [self bezierPathForControlPoints];
    
}

#pragma mark - setter
-(void)setBackgroundColor:(UIColor *)backgroundColor{
    self.elasticShape.fillColor = backgroundColor.CGColor;
    super.backgroundColor =[UIColor clearColor];
}

#pragma mark - getter


-(UIView *)topControlPointView{
    if (!_topControlPointView) {
        _topControlPointView  =  ({
            UIView *view = [[UIView alloc] init];
//            view.backgroundColor = [UIColor whiteColor];
            view;
        });
    }
    return _topControlPointView;
}


-(UIView *)leftControlPointView{
    if (!_leftControlPointView) {
        _leftControlPointView =  ({
            UIView *view = [[UIView alloc] init];
//            view.backgroundColor = [UIColor whiteColor];
            view;
        });
    }
    return _leftControlPointView;
}

-(UIView *)bottomControlPointView{
    if (!_bottomControlPointView) {
        _bottomControlPointView =  ({
            UIView *view = [[UIView alloc] init];
//            view.backgroundColor = [UIColor whiteColor];
            view;
        });
    }
    return _bottomControlPointView;
}

-(UIView *)rightControlPointView{
    if (!_rightControlPointView) {
        _rightControlPointView =  ({
            UIView *view = [[UIView alloc] init];
//            view.backgroundColor = [UIColor whiteColor];
            view;
        });
    }
    return _rightControlPointView;
}

-(CAShapeLayer *)elasticShape{
    if (!_elasticShape) {
        _elasticShape = [[CAShapeLayer alloc] init];
    }
    return _elasticShape;
}

-(CADisplayLink *)displayLink{
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLoop)];
    }
    return _displayLink;
}
@end
