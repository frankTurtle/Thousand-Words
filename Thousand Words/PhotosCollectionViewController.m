//
//  PhotosCollectionViewController.m
//  Thousand Words
//
//  Created by OSX on 8/18/15.
//  Copyright (c) 2015 LebonTech Solutions. All rights reserved.
//

#import "PhotosCollectionViewController.h"
#import "PhotoCollectionViewCell.h"

@interface PhotosCollectionViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation PhotosCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    cell.imageView.image = [UIImage imageNamed:@"nysSignIcon.png"];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

#pragma mark - Buttons
// Method to handle the camera button being pressed
// goes to the camera or the photo library if camera is not available
- (IBAction)cameraButtonPressed:(id)sender
{
    UIImagePickerController *picker = [UIImagePickerController new]; //............................................ create UIPickerController object
    picker.delegate = self; //..................................................................................... assign its delegate
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) //................ if the camera is available
        picker.sourceType = UIImagePickerControllerSourceTypeCamera; //............................................ set sourceType to camera
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) //. if camera is not
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; //.................................. use saved photos
    
    [self presentViewController:picker animated:YES completion:nil]; //............................................ show picker modally
}

#pragma mark - Image Picker Delegate Methods
// Method to handle when you picked an image
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"Finished picking");
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Method to handle when you cancel in the picker
// logs it was pressed
// dismisses current VC
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"CANCEL!"); //............................................... log it was pressed
    [self dismissViewControllerAnimated:YES completion:nil]; //......... dismiss VC
}

@end
