//
//  CakeDataDownloader.h
//  Cake List
//
//  Created by Paul Foley on 06/04/2018.
//  Copyright © 2018 Paul Foley. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kCakeDataAddress = @"https://gist.githubusercontent.com/hart88/198f29ec5114a3ec3460/raw/8dd19a88f9b8d24c23d9960f3300d0c917a4f07c/cake.json";

#pragma mark - Fruit info Handler Delegate
@protocol CakeDataHandlerDelegate <NSObject>

-(void)cakeDataReceived: (NSDictionary *)cakeDictionary;
-(void)cakeDataDownloaderFailed;

@end


#pragma mark - CakeDataDownloader
@interface CakeDataDownloader : NSObject <NSURLSessionDataDelegate>

@property (strong, nonatomic) NSMutableData *dataFromCakeAPI;
@property (strong, nonatomic) NSDictionary *cakeDictionary;

@property (nonatomic, weak)  id<CakeDataHandlerDelegate> cakeDataHandlerDelegate;


-(instancetype) initWithDataHandlerDelegate: (id)cakeDataHandlerDelegate;

-(void)getCakeData;

@end

