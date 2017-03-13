//
//  KGAPLyricsViewController.m
//  masha
//
//  Created by Igor Vedeneev on 10.03.17.
//  Copyright © 2017 AsmoMediaGroup. All rights reserved.
//

#import "KGAPLyricsViewController.h"

@interface KGAPLyricsViewController ()
@property (nonatomic, strong) id<KGSongModel> song;
@property (nonatomic, strong) UITextView *textView;
@end

@implementation KGAPLyricsViewController

#pragma mark - Init

- (instancetype)initWithSong:(id<KGSongModel>)song {
    self = [super init];
    if (self) {
        _song = song;
    }
    
    return self;
}


#pragma mark - Lifecycle

- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _textView.font = [UIFont systemFontOfSize:17];
    
    [self.view addSubview:_textView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(ap_dismissAction)];
    self.navigationItem.leftBarButtonItem = doneButton;
    _textView.text = [self.song lyrics];
}

- (void)ap_dismissAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
