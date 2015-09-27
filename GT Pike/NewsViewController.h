//
//  NewsViewController.h
//  GT Pike
//
//  Created by Kamen Tsvetkov on 4/11/15.
//  Copyright (c) 2015 Kamen Tsvetkov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsPostCell.h"

@interface NewsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) NSMutableArray *posts;

@end
