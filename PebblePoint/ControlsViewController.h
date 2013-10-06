//
//  ControlsViewController.h
//  PebblePoint
//
//  Created by Shabbir Vijapura on 10/6/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideShow.h"
#import "PebbleEngine.h"
#import "ControlsView.h"
#import <PebbleKit/PBPebbleCentral.h>
#import <PebbleKit/PebbleKit.h>
#import "AppDelegate.h"

@interface ControlsViewController : UIViewController {
    IBOutlet ControlsView *controlsView;
    IBOutlet UITextView *slideTextView;
    int currentPage;
}

@property (nonatomic, weak) SlideShow *slideshow;

@end
