//
//  Slide.h
//  PebblePoint
//
//  Created by Shabbir Vijapura on 10/6/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Slide : NSObject

@property (nonatomic, assign) int slideId;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, assign) int slideNumber;

@end
