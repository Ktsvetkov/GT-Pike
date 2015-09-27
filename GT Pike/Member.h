//
//  Member.h
//  GT Pike
//
//  Created by Kamen Tsvetkov on 8/9/15.
//  Copyright (c) 2015 Kamen Tsvetkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Member : NSObject {}

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *fbID;
@property (nonatomic) UIImage *picture;
@property (copy, nonatomic) NSString *number;
@property (copy, nonatomic) NSString *bio;

@end
