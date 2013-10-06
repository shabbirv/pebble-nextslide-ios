//
//  Event.h
//  PebblePoint
//
//  Created by Shabbir Vijapura on 10/5/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (nonatomic, strong) NSString *eventName;
@property (nonatomic, assign) int eventId;
@property (nonatomic, strong) NSString *imageUrl;

@end
