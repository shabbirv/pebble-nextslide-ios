//
//  AppDelegate.h
//  PebblePoint
//
//  Created by Shabbir Vijapura on 10/5/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import <PebbleKit/PebbleKit.h>
#import <PebbleKit/PBPebbleCentral.h>
#import "PebbleEngine.h"
#import "SlideShow.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, PBPebbleCentralDelegate, PBWatchDelegate> {
    PBWatch *targetWatch;
    UIBackgroundTaskIdentifier backgroundTask;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;
@property (nonatomic, weak) SlideShow *currentSlideshow;

@end
