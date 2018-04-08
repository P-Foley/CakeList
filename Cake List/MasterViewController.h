//
//  MasterViewController.h
//  Cake List
//
//  Created by Stewart Hart on 19/05/2015.
//  Copyright (c) 2015 Stewart Hart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cake.h"
#import "CakeDataDownloader.h"

@interface MasterViewController : UITableViewController <CakeDataHandlerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *cakeTableView;


@end

