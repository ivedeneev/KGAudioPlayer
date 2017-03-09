//
//  KGSongModel.h
//  masha
//
//  Created by Igor Vedeneev on 01.03.17.
//  Copyright © 2017 AsmoMediaGroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KGSongModel <NSObject>
- (NSURL *)songURL;
- (NSString *)songTitle;
- (NSString *)author;
- (int)lengthInSeconds;
@end
