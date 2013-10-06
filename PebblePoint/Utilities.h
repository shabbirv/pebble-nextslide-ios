//
//  Utilities.h
//  CustomerAssist
//
//  Created by Shabbir Vijapura on 8/16/12.
//  Copyright (c) 2012 Depaul University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface Utilities : NSObject

+ (Utilities *)sharedUtilities;

/*Formats inputted phone number*/
- (NSString *)formatPhoneNumber:(NSString *)phoneNumber;

/*Returns Custom Bar button Item*/
-(UIBarButtonItem *) barButtonWithTitle:(NSString *) title isDone:(BOOL) yesOrNo target:(id) target selector:(SEL) selector;

-(UIBarButtonItem *) barBUttonWithImage:(UIImage *) image target:(id) target selector:(SEL) selector;

/*Creates a Settings Button*/
-(UIBarButtonItem *) settingsButtonWithTarget:(id) target selector:(SEL) selector;

/*Formats Date into Readable String*/
-(NSString *) humanReadableDate:(NSDate *) date;

-(void) makeNavControllerRound:(UINavigationController *) nv;

- (UINavigationController *)navWithRootController:(UIViewController *)controller;

- (UILabel *)titleLabel;

- (NSString *)uuid;

+(NSString *) nonNull:(NSString *)s;

- (void)setTransparentNavigationBar:(UINavigationBar *)navigationBar;
- (void)setDefaultNavigationBar:(UINavigationBar *)navigationBar;

@end
