//
//  KGAPCurrentTimeSlider.h
//  masha
//
//  Created by Igor Vedeneev on 03.03.17.
//  Copyright © 2017 AsmoMediaGroup. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KGAPCurrentTimeSliderDelegate <NSObject>

- (void)kg_sliderValueDidChanged:(float)value;

@end

@interface KGAPCurrentTimeSlider : UISlider
@property (nonatomic, weak) id<KGAPCurrentTimeSliderDelegate> delegate;
@end
