//
//  PebbleEngine.h
//  PebblePoint
//
//  Created by Shabbir Vijapura on 10/5/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "Event.h"
#import "SlideShow.h"
#import "Slide.h"

#define BASE_URL @"http://nextslide.herokuapp.com"

typedef enum {
    PPSlideDirectionBackward,
    PPSlideDirectionForward
} PPSlideDirection;

@interface PebbleEngine : NSObject

+ (PebbleEngine *)sharedEngine;


- (void)changeSlideDirection:(PPSlideDirection)direction eventId:(int)eventId forSlideShow:(int)slideShowId;
- (void)getEvents:(void (^)(NSArray *results, NSError *error))completionBlock;
- (void)getSlideshowsForEvent:(int)eventId completion:(void (^)(NSArray *results, NSError *error))completionBlock;
- (void)selectSlideShow:(SlideShow *)slideShow;

@end
