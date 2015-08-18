//
//  AlbumTableViewController.m
//  Thousand Words
//
//  Created by OSX on 8/17/15.
//  Copyright (c) 2015 LebonTech Solutions. All rights reserved.
//

#import "AlbumTableViewController.h"
#import "Album.h"
#import "CoreDataHelper.h"
#import "PhotosCollectionViewController.h"

@interface AlbumTableViewController () <UIAlertViewDelegate>

@end

@implementation AlbumTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

// Method to fill the cellData with generated albums from core data
// after filling cellData it reloads the tableview
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated]; //......................................................... required
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Album"]; //..... creates a NSFetchRequest for all of our Albums
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date"
                                                                   ascending:YES]];  //......... way to sort the response back from core data by date
    
    NSError *error = nil; //.................................................................... variable to hold an error, use at fetch request
    
    NSArray *fetchedAlbums = [[CoreDataHelper managedObjectContext] executeFetchRequest:fetchRequest error:&error]; //........ create an array of albums from core data fetch request
    self.cellData = [fetchedAlbums mutableCopy]; //............................................. mutable copy that to our cellData array
    
    [self.tableView reloadData]; //............................................................. reload table with updated data
}

-(NSMutableArray *)cellData
{
    if (!_cellData)
        _cellData = [NSMutableArray new];
    
    return _cellData;
}

#pragma mark - Button
- (IBAction)addAlbumButtonPressed:(UIBarButtonItem *)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter new album name"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Add", nil];
    
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    [alert show];
}

#pragma mark - Alert View Delegate Method
// Method to deal with user adding a new album
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) //.................................................................................. if user clicks Add button
    {
        NSString *alertText = [alertView textFieldAtIndex:0].text; //......................................... gets the text from the text field
        [self.cellData addObject:[self albumWithName:alertText]]; //.......................................... create a new Album object, saved to CoreData with name from text field
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.cellData count] - 1 inSection:0]; //...... index path to insert
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade]; //. insert into table view cell
    }
}

#pragma mark - Helper
// Method to return an album object with the name
-(Album *)albumWithName:(NSString *)name
{
    NSManagedObjectContext *context = [CoreDataHelper managedObjectContext]; //...... get NSMAnaged context from app delegate
    
    Album *album = [NSEntityDescription insertNewObjectForEntityForName:@"Album"
                                                 inManagedObjectContext:context]; //. create new album object
    album.name = name; //............................................................ set name
    album.date = [NSDate date]; //................................................... set date
    
    NSError *error = nil; //......................................................... create an error object
    if (![context save:&error]) //................................................... if we get an error
        NSLog(@"%@", error); //...................................................... log it
    
    return album;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_cellData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"albumCell" forIndexPath:indexPath];
    
    Album *selectedAlbum = self.cellData[indexPath.row]; //...................................................... get the current album
    cell.textLabel.text = selectedAlbum.name; //................................................................. set the cell text label
    
    return cell;
}

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Album Chosen"])
    {
        if ([segue.destinationViewController isKindOfClass:[PhotosCollectionViewController class]])
        {
            NSIndexPath *index = [self.tableView indexPathForSelectedRow];
            
            PhotosCollectionViewController *targetVC = segue.destinationViewController;
            
            targetVC.album = self.cellData[index.row];
            
            NSLog(@"here");
        }
    }
}

@end
