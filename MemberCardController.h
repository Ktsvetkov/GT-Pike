//
//  MemberInfoController.h
//  GT Pike
//
//  Created by Kamen Tsvetkov on 8/10/15.
//  Copyright (c) 2015 Kamen Tsvetkov. All rights reserved.
//

#import "PopUpView.h"
#import "Member.h"

@interface MemberCardController : PopUpView <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) Member *member;

@end
