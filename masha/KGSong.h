//
//  KGSong.h
//  masha
//
//  Created by Igor Vedeneev on 01.03.17.
//  Copyright © 2017 AsmoMediaGroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KGSongModel.h"

@interface KGSong : NSObject <KGSongModel>

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *localPath;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger length;

@end
