//
//  KGAPCurrentTimeSlider.m
//  masha
//
//  Created by Igor Vedeneev on 03.03.17.
//  Copyright © 2017 AsmoMediaGroup. All rights reserved.
//

#import "KGAPCurrentTimeSlider.h"

@implementation KGAPCurrentTimeSlider

#pragma mark - Override

//- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
//    CGRect defaultRect = [super thumbRectForBounds:bounds trackRect:rect value:value];
//    CGSize newSize = CGSizeMake(defaultRect.size.width * 0.5, defaultRect.size.height * 0.5);
//    CGPoint newOrigin = defaultRect.origin;
//    CGRect newRect = CGRectMake(newOrigin.x, newOrigin.y, newSize.width, newSize.height);
//    return newRect;
//}
//
//- (CGRect)trackRectForBounds:(CGRect)bounds {
//    
//}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    
    NSLog(@"CANCELLED");
//    NSLog(@"%f", self.value);
}
//

//this needed to receive touched outside slider bounds
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [super touchesMoved:touches withEvent:event];
//    
//    if ([self.delegate respondsToSelector:@selector(kg_sliderValueDidChanged:)]) {
//        [self.delegate kg_sliderValueDidChanged:self.value];
//    }
//}


//- (void)setValue:(float)value {
//    [super setValue:value];
//    
//    NSLog(@"%f", value);
//}

@end
