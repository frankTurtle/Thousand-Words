//
//  FiltersCollectionViewController.m
//  Thousand Words
//
//  Created by OSX on 8/18/15.
//  Copyright (c) 2015 LebonTech Solutions. All rights reserved.
//

#import "FiltersCollectionViewController.h"
#import "PhotoCollectionViewCell.h"
#import "Photo.h"

@interface FiltersCollectionViewController ()

@property (strong,nonatomic) NSMutableArray *filters; //.. property to hold all filter objects
@property (strong,nonatomic) CIContext *context; //....... property for the context

@end

@implementation FiltersCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register cell classes
    [self.collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.filters = [[[self class] photoFilters] mutableCopy]; //..................................................... call class method
    
    // Do any additional setup after loading the view.
}

-(NSMutableArray *)filters
{
    if (!_filters)
        _filters = [NSMutableArray new];
    
    return _filters;
}

-(CIContext *)context
{
    if(!_context) _context = [CIContext contextWithOptions:nil];
    return _context;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helpers
// Method to return ana rray full of different filters
+(NSArray *)photoFilters
{
    CIFilter *sepia =         [CIFilter filterWithName:@"CISepiaTone" keysAndValues:nil, nil];
//    CIFilter *blur =          [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:nil, nil];
//    CIFilter *colorClamp =    [CIFilter filterWithName:@"CIColorClamp" keysAndValues:@"inputMaxComponents", [CIVector vectorWithX:0.9 Y:0.9 Z:0.9 W:0.9],
//                                                                                     @"inputMinComponents", [CIVector vectorWithX:0.2 Y:0.2 Z:0.2 W:0.2], nil];
//    CIFilter *instance =      [CIFilter filterWithName:@"CIPhotoEffectInstant" keysAndValues:nil, nil];
//    CIFilter *noir =          [CIFilter filterWithName:@"CIPhotoEffectNoir"  keysAndValues:nil, nil];
//    CIFilter *vignette =      [CIFilter filterWithName:@"CIVignetteEffect" keysAndValues:nil, nil];
//    CIFilter *colorControls = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputSaturationKey, @0.5, nil];
//    CIFilter *transfer =      [CIFilter filterWithName:@"CIPhotoEffectTransfer" keysAndValues:nil, nil];
//    CIFilter *unsharpen =     [CIFilter filterWithName:@"CIUnsharpMask" keysAndValues:nil, nil];
//    CIFilter *monochrome =    [CIFilter filterWithName:@"CIColorMonochrome" keysAndValues:nil, nil];
//    
//    NSArray *allFilters = @[ sepia, blur, colorClamp, instance, noir, vignette, colorControls, transfer, unsharpen, monochrome ];
    
    NSArray *allFilters = @[sepia];
    
    return allFilters;
}

// Method to filter an image
// convert the image so we can apply the filter
// convert back to UIImage so we can use in the view
-(UIImage *)filterdImageFromImage:(UIImage *)image andFilter:(CIFilter *)filter
{
    CIImage *unfilteredImage = [[CIImage alloc] initWithCGImage:image.CGImage]; //...... convert UIImage into CGIMage
    
    [filter setValue:unfilteredImage forKey:kCIInputImageKey]; //....................... send image to filter using key kCIImageInputKey
    
    CIImage *filteredImage = [filter outputImage]; //................................... CIImage with filter applied
    
    CGRect extent = [filteredImage extent]; //.......................................... gets how large the image is
    CGImageRef cgImage = [self.context createCGImage:filteredImage fromRect:extent]; //. gives us a CGImage  to be able to convert into UIIMage
    
    UIImage *finalImage = [UIImage imageWithCGImage:cgImage]; //........................ create uIImage with CGImage we just created
    
    return finalImage;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.filters count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    cell.backgroundColor = [UIColor whiteColor];
    
    dispatch_queue_t filterQueue = dispatch_queue_create("filter queue", NULL); //...................................................... created queue named filter queue
    
    dispatch_async(filterQueue,
                   ^{
                        UIImage *filterImage = [self filterdImageFromImage:self.photo.image
                                                                 andFilter:self.filters[indexPath.row]]; //............................. create a temp UIImage on the other thread
                        
                        dispatch_async(dispatch_get_main_queue(), //.................................................................... go back to main thread to set the image
                        ^{
                            cell.imageView.image = filterImage; //...................................................................... set the image
                        });
        
                    });
    
    return cell;
}

#pragma mark UICollectionViewDelegate
// Method to handle what happens when we select a filter
// stores in core data
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *selectedCell = (PhotoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath]; //.. tells us which cell we've chosen
    
    self.photo.image = selectedCell.imageView.image; //....................................................................... set our image to the cell's image
    
    NSError *error = nil; //.................................................................................................. create an error if photo is full of lies
    
    if (![[self.photo managedObjectContext] save:&error]) //.................................................................. if it errors
        NSLog(@"%@", error);
    
    [self.navigationController popViewControllerAnimated:YES]; //............................................................. pop the VC
}

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

@end
