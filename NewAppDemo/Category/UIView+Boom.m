//
//  UIView+Boom.m
//  XNManager
//
//  Created by Carlson Lee on 2017/7/24.
//  Copyright © 2017年 Shanghai Xu Lu Information Technology Service Co., Ltd. All rights reserved.
//

#import "UIView+Boom.h"
#import "UIView+ColorOfPoint.h"

@implementation UIView (Boom)

- (void)boom:(CGPoint )point
{
    NSMutableArray* boomCells = [NSMutableArray array];
    [self setBackgroundColor:UIColorFromRGB(0xffffff)];
    dispatch_queue_t queue = dispatch_queue_create("view_boom", nil);
    dispatch_async(queue, ^{
        NSArray* colors = [self viewColors];
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat radius = 4.0;
            CGPoint pt = self.frame.origin;
            CGSize sz = self.frame.size;
            int w = (int)floorf(sz.width/radius);
            int h = (int)floorf(sz.height/radius);
            [self setHidden:YES];
            for(int i=0; i<w; i++){
                for(int j=0; j<h; j++){
                    CALayer *shape = [[CALayer alloc] init];
                    int idx = (int)floorf((i*w+h)*radius);
                    shape.backgroundColor = [colors[idx] CGColor];
                    shape.cornerRadius = radius/2;
                    shape.frame = CGRectMake(pt.x+i*radius, pt.y+j*radius, radius, radius);
                    [self.layer.superlayer addSublayer:shape];
                    [boomCells addObject:shape];
                }
            }
            
            for (CALayer *shape in boomCells) {
                
                CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animationWithKeyPath: @"position"];
                animation1.path = [self makeRandomPath: shape].CGPath;
                animation1.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
                animation1.duration = .5;
                
                CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath: @"opacity"];
                animation2.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
                animation2.fromValue = @1;
                animation2.toValue = @0;
                animation2.duration = .5;
                
                CAAnimationGroup* group = [CAAnimationGroup animation];
                group.animations = @[animation1, animation2];
                group.removedOnCompletion = NO;
                group.fillMode = kCAFillModeForwards;
                group.duration = .5;
                [shape addAnimation:group forKey:@"group_animatin"];
            }
            
        });
    });
}

- (UIBezierPath *) makeRandomPath: (CALayer *) alayer {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: alayer.position];
    
    CGPoint pod = CGPointZero;
    CGPoint cp = CGPointZero;
    
    CGPoint lpt = alayer.position;
    CGPoint pt = self.center;
    long widL = self.bounds.size.width;
    if(lpt.x<pt.x){
        pod = CGPointMake(lpt.x, 100);
        cp = CGPointMake(lpt.x-(random() % widL), 0);
    }else{
        pod = CGPointMake(lpt.x, 100);
        cp = CGPointMake(lpt.x+(random() % widL), 0);
    }
    
    [path addQuadCurveToPoint:pod controlPoint:CGPointMake(cp.x, cp.y)];
    return path;
}

@end
