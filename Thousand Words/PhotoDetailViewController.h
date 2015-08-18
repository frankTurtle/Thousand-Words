//
//  PhotoDetailViewController.h
//  Thousand Words
//
//  Created by OSX on 8/18/15.
//  Copyright (c) 2015 LebonTech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Photo; //.. forward declaration

@interface PhotoDetailViewController : UIViewController

@property (strong,nonatomic) Photo *photo; //............ photo class object
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)addFilterButtonPressed:(id)sender;
- (IBAction)deleteButtonPressed:(id)sender;

@end
