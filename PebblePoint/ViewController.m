//
//  ViewController.m
//  Group Picture App
//
//  Created by Shabbir Vijapura on 9/20/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import "ViewController.h"
#import "Utilities.h"

@interface ViewController ()

@end

@implementation ViewController

static NSString * const kCellReuseIdentifier = @"collectionViewCell";


- (void)viewDidLoad
{
    
    self.title = @"Events";
    UILabel *label = [[Utilities sharedUtilities] titleLabel];
    self.navigationItem.titleView = label;
    label.text = self.title;
    [label sizeToFit];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor midnightBlueColor];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:111/255.0f green:116/255.0f blue:128/255.0f alpha:1.0];
    
    //Create array for events
    events = [NSMutableArray new];
    
    //Setup Collection view
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(140, 130)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setSectionInset:UIEdgeInsetsMake(5, 10, 0, 10)];
    [cView setCollectionViewLayout:flowLayout];
    [cView setAllowsSelection:YES];
    [cView registerNib:[UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kCellReuseIdentifier];
    
    
    [[PebbleEngine sharedEngine] getEvents:^(NSArray *results, NSError *error) {
        [events addObjectsFromArray:results];
        [cView reloadData];
    }];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:YES];
}

#pragma mark - UICollectionViewDataSource methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return events.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    Event *event = [events objectAtIndex:indexPath.row];
    cell.nameLabel.text = event.eventName;
    [cell.imageView setImageWithURL:[NSURL URLWithString:event.imageUrl] placeholderImage:nil];
    
    
    return cell;
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Event *event = [events objectAtIndex:indexPath.row];
    ChooseSlideShowViewController *choose = [[ChooseSlideShowViewController alloc] initWithNibName:@"ChooseSlideShowViewController" bundle:nil];
    choose.event = event;
    [self.navigationController pushViewController:choose animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
