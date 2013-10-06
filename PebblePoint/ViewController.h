//
//  ViewController.h
//  Group Picture App
//
//  Created by Shabbir Vijapura on 9/20/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatUIKit.h"
#import "PhotoCollectionViewCell.h"
#import "PebbleEngine.h"
#import "ChooseSlideShowViewController.h"

@interface ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    IBOutlet UICollectionView *cView;
    NSMutableArray *events;    
}

@end
