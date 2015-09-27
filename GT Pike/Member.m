//
//  Member.m
//  GT Pike
//
//  Created by Kamen Tsvetkov on 8/9/15.
//  Copyright (c) 2015 Kamen Tsvetkov. All rights reserved.
//

#import "Member.h"

@implementation Member

-(instancetype)init {
    self = [super init];
    
    if (self) {
        self.name = [[NSString alloc] init];
        self.fbID = [[NSString alloc] init];
        self.picture = nil;
        self.number = [[NSString alloc] init];
        self.bio = [[NSString alloc] init];
    }
    return self;
}

@end
