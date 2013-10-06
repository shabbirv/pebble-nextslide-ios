//
//  ChooseSlideShowViewController.h
//  PebblePoint
//
//  Created by Shabbir Vijapura on 10/5/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utilities.h"
#import "FlatUIKit.h"
#import "PhotoCollectionViewCell.h"
#import "Event.h"
#import "PebbleEngine.h"
#import "ControlsViewController.h"

@interface ChooseSlideShowViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
        IBOutlet UICollectionView *cView;
        NSMutableArray *slideshows;
}

@property (nonatomic, weak) Event *event;

@end
