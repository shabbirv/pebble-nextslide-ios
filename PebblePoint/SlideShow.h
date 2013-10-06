//
//  SlideShow.h
//  PebblePoint
//
//  Created by Shabbir Vijapura on 10/6/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SlideShow : NSObject

@property (nonatomic, assign) int slideshowId;
@property (nonatomic, assign) int eventId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, assign) int numSlides;
@property (nonatomic, strong) NSMutableArray *slides;

@end
