//
//  ChooseSlideShowViewController.m
//  PebblePoint
//
//  Created by Shabbir Vijapura on 10/5/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import "ChooseSlideShowViewController.h"

@interface ChooseSlideShowViewController ()

@end

@implementation ChooseSlideShowViewController

static NSString * const kCellReuseIdentifier = @"collectionViewCell";

- (void)viewDidLoad
{
    
    self.title = @"Slideshows";
    UILabel *label = [[Utilities sharedUtilities] titleLabel];
    self.navigationItem.titleView = label;
    label.text = self.title;
    [label sizeToFit];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor midnightBlueColor];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:111/255.0f green:116/255.0f blue:128/255.0f alpha:1.0];
    
    //Create array for events
    slideshows = [NSMutableArray new];
    
    //Setup Collection view
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(140, 130)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setSectionInset:UIEdgeInsetsMake(5, 10, 0, 10)];
    [cView setCollectionViewLayout:flowLayout];
    [cView setAllowsSelection:YES];
    [cView registerNib:[UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kCellReuseIdentifier];
    

    [[PebbleEngine sharedEngine] getSlideshowsForEvent:_event.eventId completion:^(NSArray *results, NSError *error) {
        [slideshows addObjectsFromArray:results];
        [cView reloadData];
    }];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - UICollectionViewDataSource methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return slideshows.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    SlideShow *slideshow = [slideshows objectAtIndex:indexPath.row];
    cell.nameLabel.text = slideshow.name;
    [cell.imageView setImageWithURL:[NSURL URLWithString:slideshow.imageUrl] placeholderImage:nil];
  
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SlideShow *slideshow = [slideshows objectAtIndex:indexPath.row];
    ControlsViewController *controlsView = [[ControlsViewController alloc] initWithNibName:@"ControlsViewController" bundle:nil];
    controlsView.slideshow = slideshow;
    [self.navigationController pushViewController:controlsView animated:YES];
    [[PebbleEngine sharedEngine] selectSlideShow:slideshow];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
