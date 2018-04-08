//
//  MasterViewController.m
//  Cake List
//
//  Created by Stewart Hart on 19/05/2015.
//  Copyright (c) 2015 Stewart Hart. All rights reserved.
//

#import "MasterViewController.h"
#import "CakeCell.h"

@interface MasterViewController ()

@property (strong, nonatomic) NSArray *cakes;

@end

@implementation MasterViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    [self startCakeDataConnection];
}

-(void) startCakeDataConnection {
    CakeDataDownloader *cakeDataDownloader = [[CakeDataDownloader alloc] initWithDataHandlerDelegate:self];
    [cakeDataDownloader getCakeData];
}

#pragma mark - Get Cake Images
-(void) downloadCakeImages {
    __weak MasterViewController *weakSelf = self;

    for (Cake *cake in weakSelf.cakes) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
       ^{
           NSData *imageData = [NSData dataWithContentsOfURL:cake.imageURL];
           
           dispatch_sync(dispatch_get_main_queue(), ^{
               UIImage *cakeImage;
               
               //Check if we've already downloaded a cake image for another cake. Reuse the one we already have to save downloading the same thing twice
               for (Cake *cakeWithPossibleDuplicateImage in weakSelf.cakes) {
                   if ([cake.imageURL isEqual:cakeWithPossibleDuplicateImage.imageURL] && cakeWithPossibleDuplicateImage.image) {
                       cakeImage = cakeWithPossibleDuplicateImage.image;
                       break;
                   }
               }
               
               if (!cakeImage) {
                   cakeImage = [UIImage imageWithData:imageData];
               }
               
               if (cakeImage) {
                   cake.image = cakeImage;
                   [self.cakeTableView reloadData];
               }
           });
       });
    }
}

#pragma mark - Cake Info Downloader Delegate Methods
-(void) cakeDataReceived:(NSDictionary *)cakeDictionary{
    @try {
        NSMutableArray *tempCakes = [[NSMutableArray alloc] init];
        for (NSDictionary *cake in cakeDictionary) {
            Cake *cakeObject = [[Cake alloc] init];
            cakeObject.title = cake[@"title"];
            cakeObject.details = cake[@"desc"];
            cakeObject.imageURL = [NSURL URLWithString: cake[@"image"]];
            
            [tempCakes addObject:cakeObject];
        }
        
        self.cakes = tempCakes;
        [self.cakeTableView reloadData];
        
        [self downloadCakeImages];
    }
    @catch(NSException *e) {
        [self displayErrorAlert];
    }
}

- (void)cakeDataDownloaderFailed {
    [self displayErrorAlert];
}

-(void)displayErrorAlert {
    UIAlertController *cakeDataDownloadFailedAlert = [UIAlertController alertControllerWithTitle: @"Failed to get cake data!"
                                                                                         message:@"Ensure connection to the internet and try again"
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
    __weak MasterViewController *weakSelf = self;
    
    UIAlertAction* retry = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * action) {
                                                      [weakSelf startCakeDataConnection];
                                                  }];
    
    [cakeDataDownloadFailedAlert addAction:retry];
    
    [self presentViewController:cakeDataDownloadFailedAlert animated:YES completion:nil];
}

#pragma mark - Table View Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cakes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CakeCell *cell = (CakeCell*)[tableView dequeueReusableCellWithIdentifier:@"CakeCell"];
    
    Cake *cake = self.cakes[indexPath.row];
    cell.titleLabel.text = cake.title;
    cell.descriptionLabel.text = cake.details;
    
    if (cake.image) {
        [cell.cakeImageView setImage:cake.image];
    } else {
        UIImage *defaultImage = [UIImage imageNamed:@"DefaultImage.jpg"];
        [cell.cakeImageView setImage:defaultImage];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
