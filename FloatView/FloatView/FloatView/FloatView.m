//
//  FloatView.m
//  FloatView
//
//  Created by ZenonHuang on 2019/1/18.
//  Copyright © 2019年 ZenonHuang. All rights reserved.
//

#import "FloatView.h"

@interface FloatView ()<UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic,assign) CGPoint startPoint;

@end

@implementation FloatView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUp];
    }
    return self;
}

#pragma mark - override

-(void)layoutSubviews{
    [super layoutSubviews];
    if (self.freeRect.origin.x!=0||self.freeRect.origin.y!=0||self.freeRect.size.height!=0||self.freeRect.size.width!=0) {
        //设置了freeRect--活动范围
    }else{
        //没有设置freeRect--活动范围，则设置默认的活动范围为父视图的frame
        self.freeRect = (CGRect){CGPointZero,self.superview.bounds.size};
    }
    
}

#pragma mark - private

- (void)setUp
{
    self.isKeepBounds = NO;
    
    self.inDrag = NO;
    
    //添加移动手势可以拖动
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragAction:)];
    self.panGestureRecognizer.minimumNumberOfTouches = 1;
    self.panGestureRecognizer.maximumNumberOfTouches = 1;
    self.panGestureRecognizer.delegate = self;
    [self addGestureRecognizer:self.panGestureRecognizer];
}

/**
 拖动事件
 @param pan 拖动手势
 */
-(void)dragAction:(UIPanGestureRecognizer *)pan{
    
//    if(self.dragEnable==NO)return;
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{//开始拖动

            self.inDrag = YES;
            if ([self.delegate respondsToSelector:@selector(FloatViewDidBeginDrag:)]) {
                [self.delegate FloatViewDidBeginDrag:self];
            }
            //注意完成移动后，将translation重置为0十分重要。否则translation每次都会叠加
            [pan setTranslation:CGPointZero inView:self];
            //保存触摸起始点位置
            self.startPoint = [pan translationInView:self];
            break;
        }
        case UIGestureRecognizerStateChanged:{//拖动中
            //计算位移 = 当前位置 - 起始位置
            if ([self.delegate respondsToSelector:@selector(FloatViewDidInDrag:)]) {
                [self.delegate FloatViewDidInDrag:self];
            }
            
            CGPoint point = [pan translationInView:self];
            float dx;
            float dy;
            switch (self.dragDirection) {
                case HZDragDirectionAny:
                    dx = point.x - self.startPoint.x;
                    dy = point.y - self.startPoint.y;
                    break;
                case HZDragDirectionHorizontal:
                    dx = point.x - self.startPoint.x;
                    dy = 0;
                    break;
                case HZDragDirectionVertical:
                    dx = 0;
                    dy = point.y - self.startPoint.y;
                    break;
                default:
                    dx = point.x - self.startPoint.x;
                    dy = point.y - self.startPoint.y;
                    break;
            }
            
            //计算移动后的view中心点
            CGPoint newCenter = CGPointMake(self.center.x + dx, self.center.y + dy);
            //移动view
            self.center = newCenter;
            //  注意完成上述移动后，将translation重置为0十分重要。否则translation每次都会叠加
            [pan setTranslation:CGPointZero inView:self];
            break;
        }
        case UIGestureRecognizerStateEnded:{//拖动结束
            [self keepBounds];
            
            self.inDrag = NO;
            
            if ([self.delegate respondsToSelector:@selector(FloatViewDidStopDrag:)]) {
                [self.delegate FloatViewDidStopDrag:self];
            }
            

            break;
        }
        default:
            break;
    }
}

- (void)animateForFloatViewX:(CGFloat)originX
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut  animations:^{
        CGRect rect = self.frame;
        rect.origin.x = originX;
        self.frame = rect;
    } completion:nil];
}

- (void)animateForFloatViewY:(CGFloat)originY
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut  animations:^{
        CGRect rect = self.frame;
        rect.origin.y = originY;
        self.frame = rect;
    } completion:nil];
}

//边界判断
- (void)keepBounds{
    //中心点判断
    float centerX = self.freeRect.origin.x+(self.freeRect.size.width - self.frame.size.width)/2;
    
    if (self.isKeepBounds==NO) {//防止超出 freeRect 边界
        
        if (self.frame.origin.x < self.freeRect.origin.x) {

            [self animateForFloatViewX:self.freeRect.origin.x];
            
        } else if(self.freeRect.origin.x+self.freeRect.size.width < self.frame.origin.x+self.frame.size.width){

             CGFloat originX = self.freeRect.origin.x+self.freeRect.size.width-self.frame.size.width;
             [self animateForFloatViewX:originX];
        }
        
    }else if(self.isKeepBounds==YES){//自动粘边
        
        if (self.frame.origin.x< centerX) {

            CGFloat originX = self.freeRect.origin.x;
            [self animateForFloatViewX:originX];
            
        } else {

            CGFloat originX = self.freeRect.origin.x+self.freeRect.size.width - self.frame.size.width;
            [self animateForFloatViewX:originX];
        }
    }
    
    if (self.frame.origin.y < self.freeRect.origin.y) {

        [self animateForFloatViewY:self.freeRect.origin.y];
        
    } else if(self.freeRect.origin.y+self.freeRect.size.height< self.frame.origin.y+self.frame.size.height){
        
         CGFloat originY = self.freeRect.origin.y+self.freeRect.size.height-self.frame.size.height;
         [self animateForFloatViewY:originY];
    }
    
}

- (void)resetState
{
    if (self.inDrag) {
        return;
    }
    
    if (!self.isKeepBounds) {
        return;
    }
   
    [self keepBounds];
}
@end
