//
//  Utilities.m
//  CustomerAssist
//
//  Created by Shabbir Vijapura on 8/16/12.
//  Copyright (c) 2012 Depaul University. All rights reserved.
//

#import "Utilities.h"
#import <QuartzCore/QuartzCore.h>

@implementation Utilities

+ (Utilities *)sharedUtilities
{
	static Utilities *sharedUtilities = nil;
	
	@synchronized(self)
	{
		if (sharedUtilities == nil)
		{
			sharedUtilities = [[Utilities alloc] init];
		}
	}
	
	return sharedUtilities;
}

- (UILabel *)titleLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor]; // change this color
    return label;
}

@end
