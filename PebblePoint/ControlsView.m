//
//  ControlsView.m
//  PebblePoint
//
//  Created by Shabbir Vijapura on 10/6/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import "ControlsView.h"

@implementation ControlsView

- (void)awakeFromNib {
    
    NSArray *screens = [[NSBundle mainBundle] loadNibNamed:@"ControlsView" owner:self options:nil];
    [self addSubview:[screens firstObject]];
}

- (IBAction)forwardAction {
    [[PebbleEngine sharedEngine] changeSlideDirection:PPSlideDirectionForward eventId:_slideshow.eventId forSlideShow:_slideshow.slideshowId];
    [[NSNotificationCenter defaultCenter] postNotificationName:kShouldDisableControls object:@(YES)];
}

- (IBAction)previousAction {
    [[PebbleEngine sharedEngine] changeSlideDirection:PPSlideDirectionBackward eventId:_slideshow.eventId forSlideShow:_slideshow.slideshowId];
    [[NSNotificationCenter defaultCenter] postNotificationName:kShouldDisableControls object:@(YES)];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
