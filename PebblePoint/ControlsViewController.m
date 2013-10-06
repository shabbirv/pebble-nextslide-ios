//
//  ControlsViewController.m
//  PebblePoint
//
//  Created by Shabbir Vijapura on 10/6/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import "ControlsViewController.h"

@interface ControlsViewController ()

@end

@implementation ControlsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidPressBackward object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidPressForward object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kShouldDisableControls object:nil];
}

- (void)viewDidLoad
{
    
    CGAffineTransform transform = CGAffineTransformMakeScale(0.0, 0.0);
    controlsView.transform = transform;
    controlsView.slideshow = _slideshow;
    [UIView animateWithDuration:0.4 delay:0.1 options:0 animations:^{
        controlsView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:NULL];
    
    [self setupControls];
    
    currentPage = 1;
    slideTextView.text = [self textFromSlides];
    [self showOnPebble];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shiftedForward) name:kDidPressForward object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shiftedBackward) name:kDidPressBackward object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldDisable:) name:kShouldDisableControls object:nil];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)shiftedForward {
    if ((currentPage + 1) <= _slideshow.numSlides) {
        currentPage++;
    } else {
        currentPage = 1;
    }
    slideTextView.text = [self textFromSlides];
    [self showOnPebble];
}

- (void)shiftedBackward {
    if ((currentPage - 1) >= 1) {
        currentPage--;
    } else {
        currentPage = _slideshow.numSlides;
    }
    slideTextView.text = [self textFromSlides];
    [self showOnPebble];
}

- (void)shouldDisable:(NSNotification *)notif {
    BOOL shouldDisable = [(NSNumber *)notif.object boolValue];
    controlsView.userInteractionEnabled = !shouldDisable;
}

- (NSString *)textFromSlides {
    for (Slide *slide in _slideshow.slides) {
        if (currentPage == slide.slideNumber) {
            return slide.note;
        }
    }
    return @"";
}

- (void)showOnPebble {
    [[[PBPebbleCentral defaultCentral] lastConnectedWatch] appMessagesPushUpdate:@{@(0): [self textFromSlides]} onSent:^(PBWatch *watch, NSDictionary *update, NSError *error) {
        NSLog(@"%@", update);
    }];

}

- (void)setupControls {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.currentSlideshow = _slideshow;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
