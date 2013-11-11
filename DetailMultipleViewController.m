//
//  DetailMultipleViewController.m
//  DetectMe
//
//  Created by Josep Marc Mingot Hidalgo on 23/10/13.
//  Copyright (c) 2013 Josep Marc Mingot Hidalgo. All rights reserved.
//

#import "DetailMultipleViewController.h"
#import "Detector.h"
#import "ManagedDocumentHelper.h"
#import "User.h"
#import "DetailViewController.h"

@interface DetailMultipleViewController ()
{
    UIManagedDocument *_detectorDatabase;
    NSArray *_singleDetectors;
}
@end

@implementation DetailMultipleViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.nameLabel.text = self.multipleDetector.name;
    
    if(!_detectorDatabase)
        _detectorDatabase = [ManagedDocumentHelper sharedDatabaseUsingBlock:^(UIManagedDocument *document) {}];
    
    self.imageView.image = [UIImage imageWithData:self.multipleDetector.image];
    
    NSString *text = @"Detectors:";
    for(Detector *detector in self.multipleDetector.detectors)
        text = [text stringByAppendingString:[NSString stringWithFormat:@" - %@", detector.name]];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _singleDetectors = [self.multipleDetector.detectors allObjects];
}

#pragma mark -
#pragma mark IActions

- (IBAction)deleteAction:(id)sender
{
    [_detectorDatabase.managedObjectContext deleteObject:self.multipleDetector];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UITableViewDataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows;
    switch (section) {
        case 0:
            rows = 1;
            break;
            
        case 1:
            rows = _singleDetectors.count;
            break;
            
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"MultipleDetectorAction" forIndexPath:indexPath];
            break;
            
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"MultipleDetectorDetail" forIndexPath:indexPath];
            
            Detector *detector = [_singleDetectors objectAtIndex:indexPath.row];
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", detector.name, detector.serverDatabaseID];
            cell.textLabel.font = [UIFont systemFontOfSize:17];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"by %@", detector.user.username];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
            
            break;
            
    }
    
    
    return cell;
}

#pragma mark -
#pragma mark Segue


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ExecuteDetectorMultiple"]) {
        NSArray *detectors = [self.multipleDetector.detectors allObjects];
        [(ExecuteDetectorViewController *)segue.destinationViewController setDetectors:detectors];
        
    }else if([[segue identifier] isEqualToString:@"SingleDetectorDetail"]){
        DetailViewController *detailVC = (DetailViewController *) segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        detailVC.detector = [_singleDetectors objectAtIndex:indexPath.row];
    }
}



@end
