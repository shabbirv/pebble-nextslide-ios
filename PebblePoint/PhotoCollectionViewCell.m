//
//  PhotoCollectionViewCell.m
//  Ask Away
//
//  Created by Shabbir Vijapura on 7/28/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell

- (void)dealloc {
    _imageView = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *screens = [[NSBundle mainBundle] loadNibNamed:@"PhotoCollectionViewCell" owner: self options: nil];
        UIView *mainView = [screens objectAtIndex:0];
        [self addSubview:mainView];
        
    }
    return self;
}

- (void)awakeFromNib {
    self.layer.borderColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3].CGColor;
    self.layer.borderWidth = 0.8;
    self.layer.masksToBounds = YES;
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
