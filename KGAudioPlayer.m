//
//  KGAudioPlayer.m
//  masha
//
//  Created by Igor Vedeneev on 01.03.17.
//  Copyright © 2017 AsmoMediaGroup. All rights reserved.
//

#import "KGAudioPlayer.h"
#import "KGAPCurrentTimeSlider.h"
#import "KGAPNavigationController.h"
@import AVFoundation;
@import AudioToolbox;
@import AVKit;
@import MediaPlayer;

#define SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)

static NSString *const kOutputVolumeSelectorName = @"outputVolume";

static NSString *const kPlayImageName = @"MusicPlayerControlPlay";
static NSString *const kPauseImageName = @"MusicPlayerControlPause";
static NSString *const kBackImageName = @"MusicPlayerControlBack";
static NSString *const kForvardImageName = @"MusicPlayerControlForward";

@interface KGAudioPlayer ()

@property (assign) BOOL isPlaying;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *currentPlayerItem;
@property (nonatomic, strong) AVAudioSession *audioSession;
@property (nonatomic, strong) id periodicTimeObserver;

@property (nonatomic, strong) UIImageView *coverImageView;

@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *forvardButton;
@property (nonatomic, strong) UIButton *loopButton;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;

@property (nonatomic, strong) UILabel *timeElapsedLabel;
@property (nonatomic, strong) UILabel *durationLabel;

@property (nonatomic, strong) KGAPCurrentTimeSlider *progressSlider;
@property (nonatomic, strong) UISlider *volumeSlider;

@property (nonatomic, strong) UIToolbar *bottomToolbar;

@property (nonatomic, strong) UIView *controlPanelContainerView;


@property (nonatomic, assign) BOOL userIsScrubbing;

@end

@implementation KGAudioPlayer


#pragma mark - Init

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self ap_commonInit];
    }
    
    return self;
}

- (instancetype)initWithSongs:(NSArray<id<KGSongModel>> *)songs
{
    self = [super init];
    if (self) {
        _songs = songs;
    }
    return self;
}


- (instancetype)initWithSongs:(NSArray<id<KGSongModel>> *)songs selectedSongIndex:(NSInteger)selectedSongIndex
{
    self = [super init];
    if (self) {
        _songs = songs;
        _selectedSongIndex = selectedSongIndex;
    }
    return self;
}

- (void)ap_commonInit {
    self.audioSession = [AVAudioSession sharedInstance];
    [self.audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    [self.audioSession addObserver:self
                        forKeyPath:kOutputVolumeSelectorName
                           options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                           context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ap_handleStall) name:AVPlayerItemPlaybackStalledNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ap_handleStall) name:AVAudioSessionInterruptionNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ap_currentSongDidFinishPlaying)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
    
    [self ap_setupCoverImageView];
    [self ap_setupProgressSlider];
    [self ap_setupTitleLabel];
    [self ap_setupSubtitleLabel];
    [self ap_setupControlPanelContainer];
    [self ap_setupVolumeSlider];
    [self ap_setupTimeElapsedLabel];
    [self ap_setupDurationLabel];
    [self ap_setupBottomToolbar];
}

- (void)ap_handleStall {
    [self.player pause];
    NSLog(@"YO");
}

- (void)ap_handleInterruption {
    NSLog(@"T_T");
}

#pragma mark - Dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Lifecycle

- (void)loadView {
    [super loadView];
    [self ap_commonInit];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    id<KGSongModel> firstSong = self.songs.firstObject;
    self.currentSong = firstSong;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}


#pragma mark - Setup

- (void)ap_setupBottomToolbar {
    _bottomToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ModernNavigationAddButtonIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(test)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ModernNavigationAddButtonIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(test)];
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ModernNavigationAddButtonIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(test)];
    UIBarButtonItem *item4 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ModernNavigationAddButtonIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(test)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    NSArray *items = @[item1, space, item2, space, item3,space, item4];
    _bottomToolbar.translucent = NO;
    _bottomToolbar.barTintColor = [UIColor whiteColor];
    [_bottomToolbar setItems:items];
    
    [self.view addSubview:_bottomToolbar];
}

- (void)test {
    NSLog(@"test");
}

- (void)ap_setupPlayButton {
    _playButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImage *playImage = [UIImage imageNamed:kPlayImageName];
    [_playButton setBackgroundImage:playImage forState:UIControlStateNormal];
    [_playButton addTarget:self action:@selector(ap_play) forControlEvents:UIControlEventTouchUpInside];
    _playButton.center = _controlPanelContainerView.center;
    
    [self.view addSubview:_playButton];
}

- (void)ap_setupBackButton {
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 55 - 35, 13, 30, 20)];
    UIImage *playImage = [UIImage imageNamed:kBackImageName];
    [_backButton setBackgroundImage:playImage forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(ap_backAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_controlPanelContainerView addSubview:_backButton];
    _backButton.center = CGPointMake(self.view.center.x - SCREEN_WIDTH * 0.25, _backButton.center.y);
}

- (void)ap_setupForwardButton {
    _forvardButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 + 55, 13, 30, 20)];
    UIImage *playImage = [UIImage imageNamed:kForvardImageName];
    [_forvardButton setBackgroundImage:playImage forState:UIControlStateNormal];
    [_forvardButton addTarget:self action:@selector(ap_forwardAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_controlPanelContainerView addSubview:_forvardButton];
    _forvardButton.center = CGPointMake(self.view.center.x + SCREEN_WIDTH * 0.25, _forvardButton.center.y);
}

- (void)ap_setupTitleLabel {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_progressSlider.frame) + 8, SCREEN_WIDTH * 0.75, 20)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.center = CGPointMake(self.view.center.x, _titleLabel.center.y);
    _titleLabel.font = [UIFont systemFontOfSize:17 weight:0.3];
    
    [self.view addSubview:_titleLabel];
}

- (void)ap_setupSubtitleLabel {
    _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_titleLabel.frame) + 8, SCREEN_WIDTH * 0.75, 20)];
    _subtitleLabel.textAlignment = NSTextAlignmentCenter;
    _subtitleLabel.font = [UIFont systemFontOfSize:14];
    _subtitleLabel.center = CGPointMake(self.view.center.x, _subtitleLabel.center.y);
    
    [self.view addSubview:_subtitleLabel];
}

- (void)ap_setupVolumeSlider {
    _volumeSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_controlPanelContainerView.frame) + 8, SCREEN_WIDTH * 0.82, 30)];
    
    _volumeSlider.center = CGPointMake(self.view.center.x, _volumeSlider.center.y);
    _volumeSlider.value = self.audioSession.outputVolume;
    _volumeSlider.minimumValueImage = [UIImage imageNamed:@"VolumeControlVolumeIcon"];
    _volumeSlider.maximumValueImage = [UIImage imageNamed:@"VolumeControlVolumeUpIcon"];
    [_volumeSlider setThumbImage:[UIImage imageNamed:@"VolumeControlSliderButton"] forState:UIControlStateNormal];
    _volumeSlider.tintColor = [UIColor grayColor];
    
    [_volumeSlider addTarget:self
                      action:@selector(ap_volumeSliderValueChanged)
            forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:_volumeSlider];
}

- (void)ap_setupProgressSlider {
    _progressSlider = [[KGAPCurrentTimeSlider alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_coverImageView.frame) + 8, SCREEN_WIDTH * 0.65, 30)];
//    [_progressSlider setThumbImage:[UIImage imageNamed:@"VideoSliderHandle"] forState:UIControlStateNormal];
    
    _progressSlider.center = CGPointMake(self.view.center.x, _progressSlider.center.y);
    
    [_progressSlider addTarget:self
                        action:@selector(ap_UserDidCHangeProgressValue:)
              forControlEvents:UIControlEventTouchDragInside | UIControlEventTouchDragOutside];
    
    [_progressSlider addTarget:self
                        action:@selector(ap_progressSliderDidEngScrubbing)
              forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    
    [self.view addSubview:_progressSlider];
}

- (void)ap_setupCoverImageView {
    _coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_WIDTH - 65)];
    _coverImageView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    _coverImageView.contentMode = UIViewContentModeCenter;
    //stab
    _coverImageView.image = [UIImage imageNamed:@"MusicPlayerAlbumArtPlaceholder"];
    [self.view addSubview:_coverImageView];
}

- (void)ap_setupControlPanelContainer {
    _controlPanelContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_subtitleLabel.frame) + 8, SCREEN_WIDTH, 50)];
    _controlPanelContainerView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_controlPanelContainerView];
    [self ap_setupPlayButton];
    [self ap_setupBackButton];
    [self ap_setupForwardButton];
}

- (void)ap_setupTimeElapsedLabel {
    _timeElapsedLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, CGRectGetMinX(_progressSlider.frame) - 16 - 5, 20)];
    _timeElapsedLabel.center = CGPointMake(_timeElapsedLabel.center.x, _progressSlider.center.y);
    _timeElapsedLabel.textAlignment = NSTextAlignmentRight;
    _timeElapsedLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:_timeElapsedLabel];
}

- (void)ap_setupDurationLabel {
    _durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_progressSlider.frame) + 5, 0, SCREEN_WIDTH -  CGRectGetMaxX(_progressSlider.frame) - 5 - 16, 20)];
    _durationLabel.center = CGPointMake(_durationLabel.center.x, _progressSlider.center.y);
    _durationLabel.textAlignment = NSTextAlignmentLeft;
    _durationLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:_durationLabel];
}


#pragma mark - Public setters

- (void)setCurrentSong:(id<KGSongModel>)currentSong {
    _currentSong = currentSong;
    
    self.progressSlider.value = 0;
    
    [self ap_configureTitleWithCurrentSongIndex];
    self.currentPlayerItem = [AVPlayerItem playerItemWithURL:[self.currentSong songURL]];
    self.player = [AVPlayer playerWithPlayerItem:self.currentPlayerItem];
    self.player.allowsExternalPlayback = YES;
    
    self.timeElapsedLabel.text = @"00:00";
    int pointMins = (int)([self.currentSong lengthInSeconds] / 60);
    int pointSec = (int)([self.currentSong lengthInSeconds] % 60);
    NSString *strMinlabel = [NSString stringWithFormat:@"%02d:%02d",pointMins,pointSec];
    self.durationLabel.text = strMinlabel;
    self.progressSlider.maximumValue = [self.currentSong lengthInSeconds];
    
    [self ap_play];
}

- (void)setSelectedSongIndex:(NSInteger)selectedSongIndex {
    _selectedSongIndex = selectedSongIndex;
    
    self.currentSong = self.songs[selectedSongIndex];
}


#pragma mark - Private

- (void)ap_play {
    self.isPlaying = !self.isPlaying;
    
    NSString *playButtonImageName = self.isPlaying ? kPauseImageName : kPlayImageName;
    UIImage *playButtonImage = [UIImage imageNamed:playButtonImageName];
    [self.playButton setBackgroundImage:playButtonImage forState:UIControlStateNormal];
    
    self.titleLabel.text = [self.currentSong songTitle];
    self.subtitleLabel.text = [self.currentSong author];
    
    if (self.isPlaying) {
        [self.player play];
        [self ap_startTimer];
    } else {
        [self.player pause];
        [self ap_invalidateTimer];
    }
}

- (void)ap_startTimer {
    CMTime time = CMTimeMakeWithSeconds(0.1, [self.currentSong lengthInSeconds]);
    __weak typeof(self) wSelf = self;
    self.periodicTimeObserver = [self.player addPeriodicTimeObserverForInterval:time queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        [wSelf ap_updatePlayingProgress];
    }];
}

- (void)ap_invalidateTimer {
//    [self.timer invalidate];
}

- (void)ap_volumeSliderValueChanged {
    AVURLAsset *asset = (AVURLAsset *) [[self.player currentItem] asset];
    NSArray *audioTracks = [asset tracksWithMediaType:AVMediaTypeAudio];
    
    NSMutableArray *allAudioParams = [NSMutableArray array];
    for (AVAssetTrack *track in audioTracks) {
        AVMutableAudioMixInputParameters *audioInputParams = [AVMutableAudioMixInputParameters audioMixInputParameters];
        [audioInputParams setVolume:self.volumeSlider.value atTime:kCMTimeZero];
        [audioInputParams setTrackID:[track trackID]];
        [allAudioParams addObject:audioInputParams];
    }
    AVMutableAudioMix *audioZeroMix = [AVMutableAudioMix audioMix];
    [audioZeroMix setInputParameters:allAudioParams];
    
    [[self.player currentItem] setAudioMix:audioZeroMix];
}

- (void)ap_updatePlayingProgress {
    if (self.userIsScrubbing || !self.player) {
        NSLog(@"SKIP UPDATING");
        return;
    }

    int currentPoint = (int)((self.player.currentTime.value)/self.player.currentTime.timescale);
    
    self.progressSlider.value = currentPoint;
    
    [self ap_updateTimeElapsedLabel:currentPoint];
}

- (void)ap_UserDidCHangeProgressValue:(id)sender {
    NSLog(@"%lld", self.player.currentItem.currentTime.value);
    int currentPoint = ceilf(self.progressSlider.value);
    [self ap_updateTimeElapsedLabel:currentPoint];
    [self.player pause];
    self.userIsScrubbing = YES;
}

- (void)ap_progressSliderDidEngScrubbing {
//    int32_t timeScale = self.player.currentItem.asset.duration.timescale;
    CMTime time = CMTimeMakeWithSeconds(self.progressSlider.value, 1);

    [self.player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self ap_updatePlayingProgress];
    
    self.userIsScrubbing = NO;
    
    if (self.isPlaying) {
        [self.player play];
    }
}

- (void)ap_updateTimeElapsedLabel:(int)value {
    int pointMins = (int)(value / 60);
    int pointSec = (int)(value % 60);
    NSString *strMinlabel = [NSString stringWithFormat:@"%02d:%02d",pointMins,pointSec];
    self.timeElapsedLabel.text = strMinlabel;
}

- (void)ap_currentSongDidFinishPlaying {
    if (self.songs.count == 1) {
        self.progressSlider.value = 0;
        [self ap_updateTimeElapsedLabel:0];
        
        [self ap_reloadPlayerWithCurrentSong];
        [self ap_play];
    }
}

- (void)ap_reloadPlayerWithCurrentSong {
    self.currentPlayerItem = [AVPlayerItem playerItemWithURL:[self.currentSong songURL]];
    [self.player replaceCurrentItemWithPlayerItem:self.currentPlayerItem];
}

- (void)ap_prepareForNextItem {
    self.progressSlider.value = 0;
    [self ap_updateTimeElapsedLabel:0];
    self.isPlaying = NO;
}

#pragma mark - Actions

- (void)ap_playAction {
    [self ap_play];
}

- (void)ap_backAction {
    if (self.selectedSongIndex >= 1) {
        [self ap_prepareForNextItem];
        self.selectedSongIndex--;
    }
}

- (void)ap_forwardAction {
    if (self.selectedSongIndex < self.songs.count - 1) {
        [self ap_prepareForNextItem];
        self.selectedSongIndex++;
    }
}

- (void)ap_dismissAction {
    [self.player pause];
    //refactor
    [self.player removeTimeObserver:self.periodicTimeObserver];
    self.player = nil;
    self.currentPlayerItem = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:kOutputVolumeSelectorName]) {
        self.volumeSlider.value = self.audioSession.outputVolume;
        return;
    }
}


#pragma mark - Helpers



- (void)ap_configureTitleWithCurrentSongIndex {
    NSString *navTitleString = [NSString stringWithFormat:@"%d из %ld", self.selectedSongIndex + 1, (unsigned long)self.songs.count];
    self.title = navTitleString;
}


#pragma mark - Public

- (void)presentFrom:(UIViewController *)fromViewController {
    KGAPNavigationController *nc = [[KGAPNavigationController alloc] initWithRootViewController:self];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(ap_dismissAction)];
    self.navigationItem.leftBarButtonItem = doneButton;
    
    [fromViewController presentViewController:nc animated:YES completion:nil];
}

@end
