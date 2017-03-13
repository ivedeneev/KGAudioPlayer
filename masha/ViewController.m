//
//  ViewController.m
//  masha
//
//  Created by Igor Vedeneev on 28.02.17.
//  Copyright © 2017 AsmoMediaGroup. All rights reserved.
//

#import "ViewController.h"
@import AVFoundation;
@import AudioToolbox;
@import AVKit;


#import "KGAudioPlayer.h"
#import "KGSong.h"

@interface ViewController () <AVAudioPlayerDelegate>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playButton:(id)sender {
    KGSong *karenina = [KGSong new];
    karenina.url = @"https://s3.eu-central-1.amazonaws.com/karenina-dev/test/out.mp3";
    karenina.title = @"KareninaTest";
    karenina.length = 196;
    
    KGSong *serebro = [KGSong new];
    serebro.localPath = @"serebro-slomana.mp3";
    serebro.title = @"Сломана";
    serebro.length = 287;
    
    KGAudioPlayer *player = [[KGAudioPlayer alloc] initWithSongs:@[karenina, serebro]];
    [player presentFrom:self];
    
}

@end
