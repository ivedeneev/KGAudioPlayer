//
//  KGSong.m
//  masha
//
//  Created by Igor Vedeneev on 01.03.17.
//  Copyright © 2017 AsmoMediaGroup. All rights reserved.
//

#import "KGSong.h"

@implementation KGSong

#pragma mark - KGSongModel

- (NSURL *)songURL {
    if (self.localPath) {
        return [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"serebro-slomana" ofType:@"mp3"]];
    }
    
    return [NSURL URLWithString:self.url];
}

- (NSString *)songTitle {
    return self.title;
}

- (NSString *)author {
    return @"Test Author inc.";
}

- (int)lengthInSeconds {
    return self.length;
}

- (NSString *)lyrics {
    return @"I`ve seen the worldDone it all, had my cake nowDiamonds, brilliant, and Bel-Air now Hot summer nights mid July When you and I were forever wildThe crazy days, the city lights The way youd play with me like a child";
}

@end
