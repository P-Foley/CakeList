//
//  Cake.h
//  Cake List
//
//  Created by Paul Foley on 06/04/2018.
//  Copyright © 2018 Paul Foley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Cake : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *details;
@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) UIImage *image;

@end
