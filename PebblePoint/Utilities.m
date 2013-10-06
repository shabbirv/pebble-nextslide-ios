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

-(UIBarButtonItem *) barButtonWithTitle:(NSString *)title isDone:(BOOL)yesOrNo target:(id)target selector:(SEL)selector {
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setTitle:title forState:UIControlStateNormal];
    [menuButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIImage* buttonImage = [[UIImage imageNamed:(yesOrNo)?@"blue_btn":@"darkbutton.png"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
    [menuButton setBackgroundColor:[UIColor clearColor]];
    menuButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
    [menuButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    
    CGSize stringSize = [title sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]
                               constrainedToSize:CGSizeMake(150, 9999)
                                   lineBreakMode:NSLineBreakByWordWrapping];

    menuButton.frame = CGRectMake(0, 0, stringSize.width + 20, 30);
    
    
    return [[UIBarButtonItem alloc] initWithCustomView:menuButton];
}

-(UIBarButtonItem *) barBUttonWithImage:(UIImage *) image target:(id) target selector:(SEL) selector {
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setTitle:@"" forState:UIControlStateNormal];
    [menuButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [menuButton setBackgroundColor:[UIColor clearColor]];
    [menuButton setBackgroundImage:image forState:UIControlStateNormal];
    menuButton.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    return [[UIBarButtonItem alloc] initWithCustomView:menuButton];

}

-(UIBarButtonItem *) settingsButtonWithTarget:(id) target selector:(SEL) selector {
    
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setTitle:@"" forState:UIControlStateNormal];
    menuButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20.0, 0, 0);
    [menuButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIImage* buttonImage = [[UIImage imageNamed:@"settings.png"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
    [menuButton setBackgroundColor:[UIColor clearColor]];
    menuButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [menuButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    menuButton.frame = CGRectMake(0, 0, 26, 26);
    return [[UIBarButtonItem alloc] initWithCustomView:menuButton];
}

- (UINavigationController *)navWithRootController:(UIViewController *)controller {
    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:controller];
    nv.navigationBar.barTintColor = [UIColor colorWithRed:230/255.0f green:233/255.0f blue:240/255.0f alpha:1.0];
    nv.navigationBar.tintColor = [UIColor colorWithRed:111/255.0f green:116/255.0f blue:128/255.0f alpha:1.0];
    nv.navigationBar.translucent = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    return nv;
}

- (void)setTransparentNavigationBar:(UINavigationBar *)navigationBar {
    navigationBar.tintColor = [UIColor whiteColor];
    navigationBar.translucent = YES;
    [navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[[UIImage alloc] init]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}

- (void)setDefaultNavigationBar:(UINavigationBar *)navigationBar {
    navigationBar.barTintColor = [UIColor colorWithRed:230/255.0f green:233/255.0f blue:240/255.0f alpha:1.0];
    navigationBar.tintColor = [UIColor colorWithRed:111/255.0f green:116/255.0f blue:128/255.0f alpha:1.0];
    navigationBar.translucent = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

+(NSString *) nonNull:(NSString *)s {
    

    
    if ([s isKindOfClass:[NSNull class]] || [s rangeOfString:@"null"].location != NSNotFound) {
        s = @"";
    }
    
    if (s == nil || !s) {
        return @"";
    }
    
    return s;
}

- (NSString *)uuid {
	CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
	NSString * str = CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
	CFRelease(uuid);
	return str;
}

- (UILabel *)titleLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor]; // change this color
    return label;
}

-(NSString *) humanReadableDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"LL/dd/yyyy hh:mm a"];
    return [dateFormatter stringFromDate:date];
}

//Format 10-digit phone number
- (NSString *)formatPhoneNumber:(NSString *)phoneNumber {
    
    NSArray *usFormats = [NSArray arrayWithObjects:
                               
                               @"+1 (###) ###-####",
                               
                               @"1 (###) ###-####",
                               
                               @"011 $",
                               
                               @"###-####",
                               
                               @"(###) ###-####", nil];
    if(usFormats == nil) return phoneNumber;
    
    NSString *output = [self strip:phoneNumber];
    
    for(NSString *phoneFormat in usFormats) {
        
        int i = 0;
        
        NSMutableString *temp = [[NSMutableString alloc] init];
        
        for(int p = 0; temp != nil && i < [output length] && p < [phoneFormat length]; p++) {
            
            char c = [phoneFormat characterAtIndex:p];
            
            BOOL required = [self canBeInputByPhonePad:c];
            
            char next = [output characterAtIndex:i];
            
            switch(c) {
                    
                case '$':
                    
                    p--;
                    
                    [temp appendFormat:@"%c", next]; i++;
                    
                    break;
                    
                case '#':
                    
                    if(next < '0' || next > '9') {
                        
                        temp = nil;
                        
                        break;
                        
                    }
                    
                    [temp appendFormat:@"%c", next]; i++;
                    
                    break;
                    
                default:
                    
                    if(required) {
                        
                        if(next != c) {
                            
                            temp = nil;
                            
                            break;
                            
                        }
                        
                        [temp appendFormat:@"%c", next]; i++;
                        
                    } else {
                        
                        [temp appendFormat:@"%c", c];
                        
                        if(next == c) i++;
                        
                    }
                    
                    break;
                    
            }
            
        }
        
        if(i == [output length]) {
            
            return temp;
            
        }
        
    }
    
    return output;
    
}



- (NSString *)strip:(NSString *)phoneNumber {
    
    NSMutableString *res = [[NSMutableString alloc] init];
    
    for(int i = 0; i < [phoneNumber length]; i++) {
        
        char next = [phoneNumber characterAtIndex:i];
        
        if([self canBeInputByPhonePad:next])
            
            [res appendFormat:@"%c", next];
        
    }
    
    return res;
    
}



- (BOOL)canBeInputByPhonePad:(char)c {
    
    if(c == '+' || c == '*' || c == '#') return YES;
    
    if(c >= '0' && c <= '9') return YES;
    
    return NO;
    
}

-(void) makeNavControllerRound:(UINavigationController *)nv {
    CALayer *capa = [nv navigationBar].layer;
    [capa setShadowColor: [[UIColor clearColor] CGColor]];
    [capa setShadowOpacity:0.85f];
    [capa setShadowOffset: CGSizeMake(0.0f, 1.5f)];
    [capa setShadowRadius:0.5f];
    [capa setShouldRasterize:YES];
    
    
    //Round
    CGRect bounds = capa.bounds;
    bounds.size.height += 10.0f;    //I'm reserving enough room for the shadow
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                   byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                         cornerRadii:CGSizeMake(8.0, 8.0)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    
    [capa addSublayer:maskLayer];
    capa.mask = maskLayer;
    
    [nv.view.layer setCornerRadius:8.0];
    nv.view.layer.masksToBounds = YES;
}

@end
