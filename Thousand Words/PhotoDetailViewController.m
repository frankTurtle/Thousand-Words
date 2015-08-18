//
//  PhotoDetailViewController.m
//  Thousand Words
//
//  Created by OSX on 8/18/15.
//  Copyright (c) 2015 LebonTech Solutions. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "Photo.h"
#import "FiltersCollectionViewController.h"

@interface PhotoDetailViewController ()

@end

@implementation PhotoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// Method to update the image in the UIImageView
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.imageView.image = self.photo.image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toFilterSegue"])
    {
        if ([segue.destinationViewController isKindOfClass:[FiltersCollectionViewController class]])
        {
            FiltersCollectionViewController *targetVC = segue.destinationViewController;
            targetVC.photo = self.photo;
        }
    }
    
}

- (IBAction)addFilterButtonPressed:(id)sender
{
    
}

// Method to handle the delete button being pressed
- (IBAction)deleteButtonPressed:(id)sender
{
    NSError *error = nil;
    
    [[self.photo managedObjectContext] save:&error]; //............. not nessary if only deploying to device
    
    if (error)
        NSLog(@"%@", error);
    
    [[self.photo managedObjectContext] deleteObject:self.photo]; //.. delete the photo object
    [self.navigationController popViewControllerAnimated:YES]; //.... used a push segue to get here, pop the current one off stack
}
@end
