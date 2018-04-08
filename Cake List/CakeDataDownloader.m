//
//  CakeDataDownloader.m
//  Cake List
//
//  Created by Paul Foley on 06/04/2018.
//  Copyright © 2018 Paul Foley. All rights reserved.
//

#import "CakeDataDownloader.h"

@implementation CakeDataDownloader

-(instancetype) initWithDataHandlerDelegate:(id)cakeDataHandlerDelegate {
    if (self = [super init]) {
        self.cakeDataHandlerDelegate = cakeDataHandlerDelegate;
    }
    
    return self;
}

-(void)getCakeData {
    self.dataFromCakeAPI = [[NSMutableData alloc] init];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: kCakeDataAddress]];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:5];
    
    NSURLSession *cakeDataSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *getCakeDataTask = [cakeDataSession dataTaskWithRequest:request];
    
    [getCakeDataTask resume];
}
#pragma mark - NSURLSession Delegate Methods
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.dataFromCakeAPI appendData:data];
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    //TODO - Check for non 200 response here
    //NSLog(@"API Connection Did Receive Response %@", response);
    completionHandler(NSURLSessionResponseAllow);
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (!error) {
        NSError *jsonReadingError;
        self.cakeDictionary = [NSJSONSerialization JSONObjectWithData:self.dataFromCakeAPI options:NSJSONReadingAllowFragments error:&jsonReadingError];
        
        if (jsonReadingError) {
            [self.cakeDataHandlerDelegate cakeDataDownloaderFailed];
        }
        
        [self.cakeDataHandlerDelegate cakeDataReceived:self.cakeDictionary];
    } else {
        [self.cakeDataHandlerDelegate cakeDataDownloaderFailed];
    }
}

@end
