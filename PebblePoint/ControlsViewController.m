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
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.currentSlideshow = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidPressBackward object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidPressForward object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kShouldDisableControls object:nil];
}

- (void)viewDidLoad
{
    
    //Setup label
    self.title = _slideshow.name;
    UILabel *label = [[Utilities sharedUtilities] titleLabel];
    self.navigationItem.titleView = label;
    label.text = self.title;
    [label sizeToFit];
    
    //Animate controls view
    CGAffineTransform transform = CGAffineTransformMakeScale(0.0, 0.0);
    controlsView.transform = transform;
    controlsView.slideshow = _slideshow;
    controlsView.alpha = 0.8;
    [UIView animateWithDuration:0.4 delay:0.1 options:0 animations:^{
        controlsView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:NULL];
    
    //Delete the delegate about the change of slideshow
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.currentSlideshow = _slideshow;

    //Init first page
    currentPage = 1;
    slideTextView.text = [self textFromSlides];
    [self showOnPebble];
    
    //Add observers for shifts and disabling the button
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shiftedForward) name:kDidPressForward object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shiftedBackward) name:kDidPressBackward object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldDisable:) name:kShouldDisableControls object:nil];
    
    
    scroll.pagingEnabled = YES;
    
    //Add all the imageviews to the scrollview
    int i = 0;
    int x = 0;
    for (Slide *slide in _slideshow.slides) {
        NSString *imgUrl = [_slideshow.imageUrl stringByReplacingOccurrencesOfString:@"pagenumber=1" withString:[NSString stringWithFormat:@"pagenumber=%d", i + 1]];
        x = 20 + (i * 320);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 10, 280, 230)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil];
        [scroll addSubview:imageView];
        i++;
    }
    [scroll setContentSize:CGSizeMake(x + 320, 0)];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)shiftedForward {
    if ((currentPage + 1) <= _slideshow.numSlides) {
        currentPage++;
    } else {
        currentPage = 1;
    }
    [scroll setContentOffset:CGPointMake(320 * (currentPage - 1), 0) animated:YES];
    slideTextView.text = [self textFromSlides];
    [self showOnPebble];
}

- (void)shiftedBackward {
    if ((currentPage - 1) >= 1) {
        currentPage--;
    } else {
        currentPage = _slideshow.numSlides;
    }
    [scroll setContentOffset:CGPointMake(320 * (currentPage - 1), 0) animated:YES];
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
            if (slide.note.length == 0) {
                return @"No Notes";
            } else {
                return slide.note;
            }
        }
    }
    return @"No Notes";
}

- (void)showOnPebble {
    NSString *text = [self textFromSlides];
    [[[PBPebbleCentral defaultCentral] lastConnectedWatch] appMessagesPushUpdate:@{@(0): text} onSent:^(PBWatch *watch, NSDictionary *update, NSError *error) {
        NSLog(@"%@", update);
    }];

}

@end
