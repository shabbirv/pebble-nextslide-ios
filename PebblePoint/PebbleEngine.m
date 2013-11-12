//
//  PebbleEngine.m
//  PebblePoint
//
//  Created by Shabbir Vijapura on 10/5/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import "PebbleEngine.h"

@implementation PebbleEngine

+ (PebbleEngine *)sharedEngine {
    static PebbleEngine *sharedEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sharedEngine == nil) {
            sharedEngine = [[self alloc] init];
        }
    });
    return sharedEngine;
}

+ (AFHTTPClient *) client {
    static AFHTTPClient *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (client == nil) {
            client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
            [client setDefaultHeader:@"Accept" value:@"application/json"];
            [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
        }
    });
	return client;
}

- (void)changeSlideDirection:(PPSlideDirection)direction eventId:(int)eventId forSlideShow:(int)slideShowId {
    
    AFHTTPClient *client = [[self class] client];
    NSString *path = [NSString stringWithFormat:@"/events/%d/slideshows/%d/%@.json", eventId, slideShowId, (direction == PPSlideDirectionForward) ? @"forward" : @"backward"];
    [client getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[NSNotificationCenter defaultCenter] postNotificationName:(direction == PPSlideDirectionBackward) ? kDidPressBackward : kDidPressForward object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kShouldDisableControls object:@(NO)];        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR: %@", operation.responseString);
        [[NSNotificationCenter defaultCenter] postNotificationName:kShouldDisableControls object:@(NO)];
    }];
    
}

- (void)getEvents:(void (^)(NSArray *, NSError *))completionBlock {
    AFHTTPClient *client = [[self class] client];
    [client getPath:@"/events.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in responseObject) {
            Event *event = [[Event alloc] init];
            event.eventId = [dict[@"id"] intValue];
            event.eventName = dict[@"name"];
            event.imageUrl = dict[@"image"];
            [array addObject:event];
        }
        
        if (completionBlock) {
            completionBlock(array, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completionBlock) {
            completionBlock(nil, error);
        }
        NSLog(@"ERROR: %@", operation.responseString);
    }];
}

- (void)getSlideshowsForEvent:(int)eventId completion:(void (^)(NSArray *results, NSError *error))completionBlock {
    AFHTTPClient *client = [[self class] client];
    NSString *path = [NSString stringWithFormat:@"/events/%d/slideshows.json", eventId];
    [client getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *array = [NSMutableArray array];
        NSArray *responses = responseObject[@"response"];
        for (NSDictionary *dict in responses) {
            SlideShow *slideshow = [[SlideShow alloc] init];
            slideshow.eventId = [dict[@"event_id"] intValue];
            slideshow.name = dict[@"name"];
            slideshow.slideshowId = [dict[@"id"] intValue];
            slideshow.numSlides = [dict[@"slide_num"] intValue];
            slideshow.imageUrl = dict[@"first_image_url"];
            slideshow.slides = [NSMutableArray new];
            NSArray *slides = dict[@"slides"];
            for (NSDictionary *slideDict in slides) {
                Slide *slide = [[Slide alloc] init];
                slide.slideId = [slideDict[@"id"] intValue];
                SET_IF_NOT_NULL(slide.note, slideDict[@"note"]);
                slide.slideNumber = [slideDict[@"slide_number"] intValue];
                [slideshow.slides addObject:slide];
            }
            [array addObject:slideshow];
        }
        
        if (completionBlock) {
            completionBlock(array, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completionBlock) {
            completionBlock(nil, error);
        }
        NSLog(@"ERROR: %@", operation.responseString);
    }];
}

- (void)selectSlideShow:(SlideShow *)slideShow {
    AFHTTPClient *client = [[self class] client];
    NSString *path = [NSString stringWithFormat:@"/events/%d/slideshows/%d/choose.json", slideShow.eventId, slideShow.slideshowId];
    [client getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR: %@", operation.responseString);
        NSLog(@"%@", operation.request.URL);
        [[NSNotificationCenter defaultCenter] postNotificationName:kShouldDisableControls object:@(NO)];
    }];
}

@end
