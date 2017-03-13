//
//  KGAudioPlayer.h
//  masha
//
//  Created by Igor Vedeneev on 01.03.17.
//  Copyright © 2017 AsmoMediaGroup. All rights reserved.
//

@import UIKit;
#import "KGSongModel.h"

@protocol KGAudioPlayerDelegate <NSObject>
//set new current song
- (void)willLoadPreviousSong;
- (void)willLoadNextSong;
@end

@interface KGAudioPlayer : UIViewController

- (void)presentFrom:(UIViewController *)fromViewController;

- (instancetype)initWithSongs:(NSArray<id<KGSongModel>> *)songs;
- (instancetype)initWithSongs:(NSArray<id<KGSongModel>> *)songs selectedSongIndex:(NSInteger)selectedSongIndex;

@property (nonatomic, weak) id<KGAudioPlayerDelegate> kg_delegate;
@property (nonatomic, strong) id<KGSongModel> song;
@property (nonatomic, strong) NSArray<id<KGSongModel>> *songs;

/**
 -- if u init player with array of songs it will be set automatically
 -- set new song @ delegate methods
 */
@property (nonatomic, strong) id<KGSongModel> currentSong;
@property (nonatomic, assign) int selectedSongIndex;

@end
