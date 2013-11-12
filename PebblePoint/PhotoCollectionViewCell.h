//
//  PhotoCollectionViewCell.h
//  Ask Away
//
//  Created by Shabbir Vijapura on 7/28/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollectionViewCell : UICollectionViewCell {
}

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@end
