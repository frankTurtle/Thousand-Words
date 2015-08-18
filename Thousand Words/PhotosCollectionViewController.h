//
//  PhotosCollectionViewController.h
//  Thousand Words
//
//  Created by OSX on 8/18/15.
//  Copyright (c) 2015 LebonTech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Album.h"

@interface PhotosCollectionViewController : UICollectionViewController

@property (strong,nonatomic) Album *album;

- (IBAction)cameraButtonPressed:(id)sender;

@end
