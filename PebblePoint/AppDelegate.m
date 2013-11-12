//
//  AppDelegate.m
//  PebblePoint
//
//  Created by Shabbir Vijapura on 10/5/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

NSString * const kDidPressForward = @"kDidPressForward";
NSString * const kDidPressBackward = @"kDidPressBackward";
NSString * const kShouldDisableControls = @"kShouldDisableControls";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    [self.window setRootViewController:nv];
    
    [self.window makeKeyAndVisible];
    
    // We'd like to get called when Pebbles connect and disconnect, so become the delegate of PBPebbleCentral:
    [[PBPebbleCentral defaultCentral] setDelegate:self];
    
    // Initialize with the last connected watch:
    [self setTargetWatch:[[PBPebbleCentral defaultCentral] lastConnectedWatch]];
    
    return YES;
}

- (void)setCurrentSlideshow:(SlideShow *)currentSlideshow {
    _currentSlideshow = currentSlideshow;
    if (currentSlideshow == nil) {
        NSString *text = @"No Slideshow selected";
        [[[PBPebbleCentral defaultCentral] lastConnectedWatch] appMessagesPushUpdate:@{@(0): text} onSent:^(PBWatch *watch, NSDictionary *update, NSError *error) {
            NSLog(@"%@", update);
        }];
    }
}

- (void)setTargetWatch:(PBWatch*)watch {
    targetWatch = watch;

    // NOTE:
    // For demonstration purposes, we start communicating with the watch immediately upon connection,
    // because we are calling -appMessagesGetIsSupported: here, which implicitely opens the communication session.
    
    // Test if the Pebble's firmware supports AppMessages :
    [watch appMessagesGetIsSupported:^(PBWatch *watch, BOOL isAppMessagesSupported) {
        if (isAppMessagesSupported) {
            // Configure our communications channel
            uint8_t bytes[] = { 0x04, 0xC4, 0xE9, 0x83, 0xF7, 0x76, 0x41, 0x8F, 0x8D, 0x15, 0xDC, 0xAB, 0x23, 0x56, 0xDA, 0x8B };
            NSData *uuid = [NSData dataWithBytes:bytes length:sizeof(bytes)];
            [watch appMessagesSetUUID:uuid];
            
            [self addUpdateHandler];
        } else {
            
            NSString *message = [NSString stringWithFormat:@"Blegh... %@ does NOT support AppMessages :'(", [watch name]];
            [[[UIAlertView alloc] initWithTitle:@"Connected..." message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

- (void)addUpdateHandler {
    [[PBPebbleCentral defaultCentral].lastConnectedWatch appMessagesAddReceiveUpdateHandler:^BOOL(PBWatch *w2, NSDictionary *update) {
        NSUInteger value = [[update objectForKey:[[update allKeys] lastObject]] intValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_currentSlideshow == nil) {
                return;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kShouldDisableControls object:@(YES)];
            [[PebbleEngine sharedEngine] changeSlideDirection:value eventId:_currentSlideshow.eventId forSlideShow:_currentSlideshow.slideshowId];
        });
        
        return YES;
    }];
}

- (void)pebbleCentral:(PBPebbleCentral *)central watchDidConnect:(PBWatch *)watch isNew:(BOOL)isNew {
    NSLog(@"watch connected");
}

- (void)pebbleCentral:(PBPebbleCentral *)central watchDidDisconnect:(PBWatch *)watch {
    NSLog(@"watch disconnected");
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    backgroundTask = [application beginBackgroundTaskWithExpirationHandler: ^ {
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        localNotif.fireDate = [NSDate date];
        localNotif.timeZone = [NSTimeZone defaultTimeZone];
        localNotif.alertBody = [NSString stringWithFormat:@"Your background session has ended. Open the app to restart it."];
        localNotif.soundName = nil;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
        [application endBackgroundTask: backgroundTask];
        backgroundTask = UIBackgroundTaskInvalid;
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    if (backgroundTask != UIBackgroundTaskInvalid) {
        [application endBackgroundTask:backgroundTask];
        backgroundTask = UIBackgroundTaskInvalid;
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
