//
//  ControlsView.h
//  PebblePoint
//
//  Created by Shabbir Vijapura on 10/6/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideShow.h"
#import "PebbleEngine.h"

@interface ControlsView : UIView

@property (nonatomic, weak) SlideShow *slideshow;

- (IBAction)forwardAction;
- (IBAction)previousAction;

@end
