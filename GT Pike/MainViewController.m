//
//  MainViewController.m
//  GT Pike
//
//  Created by Kamen Tsvetkov on 4/11/15.
//  Copyright (c) 2015 Kamen Tsvetkov. All rights reserved.
//

#import "MainViewController.h"
#import "NewsViewController.h"
#import "MenuViewController.h"
#import "MembersViewController.h"
#import "myUtilities.h"
#import <QuartzCore/QuartzCore.h>

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *newsButton;
@property (weak, nonatomic) IBOutlet UIButton *membersButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *membersWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *membersHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *newsWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *newsHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *newsToMenSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menToMembSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToNewsSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *membToBottomSpace;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    double workingScreenHeight = [[UIScreen mainScreen] bounds].size.height-81;
    double buttonHeight = workingScreenHeight/4;
    double buttonPadding = workingScreenHeight / 16;
    
    self.topToNewsSpace.constant = buttonPadding + 81;
    self.newsToMenSpace.constant = buttonPadding;
    self.menToMembSpace.constant = buttonPadding;
    self.membToBottomSpace.constant = buttonPadding;
    
    
    self.menuHeight.constant = buttonHeight;
    self.menuWidth.constant = buttonHeight;
    self.menuButton.layer.cornerRadius = buttonHeight/2;
    self.menuButton.clipsToBounds = YES;
    self.menuButton.layer.borderColor=[UIColor grayColor].CGColor;
    self.menuButton.layer.borderWidth=1.0f;
    
    self.newsHeight.constant = buttonHeight;
    self.newsWidth.constant = buttonHeight;
    self.newsButton.layer.cornerRadius = buttonHeight/2;
    self.newsButton.clipsToBounds = YES;
    self.newsButton.layer.borderColor=[UIColor grayColor].CGColor;
    self.newsButton.layer.borderWidth=1.0f;
    
    self.membersHeight.constant = buttonHeight;
    self.membersWidth.constant = buttonHeight;
    self.membersButton.layer.cornerRadius = buttonHeight/2;
    self.membersButton.clipsToBounds = YES;
    self.membersButton.layer.borderColor=[UIColor grayColor].CGColor;
    self.membersButton.layer.borderWidth=1.0f;
}

- (IBAction)goToMenuView {
    MenuViewController *oView = [[MenuViewController alloc] init];
    [self presentViewController:oView animated:NO completion:nil];
}

- (IBAction)goToNewsView {
    NewsViewController *oView = [[NewsViewController alloc] init];
    [self presentViewController:oView animated:NO completion:nil];
}

- (IBAction)goToMembersView {
    MembersViewController *oView = [[MembersViewController alloc] init];
    [self presentViewController:oView animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
