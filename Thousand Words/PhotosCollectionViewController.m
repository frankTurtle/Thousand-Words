//
//  PhotosCollectionViewController.m
//  Thousand Words
//
//  Created by OSX on 8/18/15.
//  Copyright (c) 2015 LebonTech Solutions. All rights reserved.
//

#import "PhotosCollectionViewController.h"
#import "PhotoCollectionViewCell.h"
#import "Photo.h"
#import "PictureDataTransformer.h"
#import "CoreDataHelper.h"

@interface PhotosCollectionViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong,nonatomic) NSMutableArray *photos; //.... holds UIImages

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

// if photos doesnt exist, fix it.
-(NSMutableArray *)photos
{
    if (!_photos)
        _photos = [NSMutableArray new];
    
    return _photos;
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
    return [self.photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    Photo *photo = self.photos[indexPath.row]; //.............. create photo from photo array
    cell.imageView.image = photo.image; //..................... set the cell imageview image to the photo image
    
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
    UIImage *image = info[UIImagePickerControllerEditedImage]; //..................................................... gets value from info dict for key UIImagePickerControllerEditedImage
    if (!image) //.................................................................................................... if image wasnt edited
        image = info[UIImagePickerControllerOriginalImage]; //........................................................ set it to the original
    
    [self.photos addObject:[self photoFromImage:image]]; //........................................................... add photo to photos array
    [self.collectionView reloadData]; //.............................................................................. reload collection view data
    
    [self dismissViewControllerAnimated:YES completion:nil]; //....................................................... dismiss VC
}

// Method to handle when you cancel in the picker
// logs it was pressed
// dismisses current VC
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"CANCEL!"); //............................................... log it was pressed
    [self dismissViewControllerAnimated:YES completion:nil]; //......... dismiss VC
}

#pragma mark - Helper
// Method to persist the photo to core data
// returns a photo object
-(Photo *)photoFromImage:(UIImage *)image
{
    Photo *photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo"
                                                 inManagedObjectContext:[CoreDataHelper managedObjectContext]];
    
    photo.image = image;
    photo.date = [NSDate date];
    photo.albumBook = self.album;
    
    NSError *error = nil;
    if (![[photo managedObjectContext] save:&error])
        NSLog(@"%@", error); //. print error
    
    return photo;
}

@end
