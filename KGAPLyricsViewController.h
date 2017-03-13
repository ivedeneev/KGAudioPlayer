//
//  KGAPLyricsViewController.h
//  masha
//
//  Created by Igor Vedeneev on 10.03.17.
//  Copyright © 2017 AsmoMediaGroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGSongModel.h"

@interface KGAPLyricsViewController : UIViewController
- (instancetype)initWithSong:(id<KGSongModel>)song;

@end
