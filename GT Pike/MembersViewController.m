//
//  MembersViewController.m
//  GT Pike
//
//  Created by Kamen Tsvetkov on 4/15/15.
//  Copyright (c) 2015 Kamen Tsvetkov. All rights reserved.
//

#import "MembersViewController.h"
#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Member.h"
#import "UIImage+animatedGIF.h"
#import "myUtilities.h"
#import "MemberCardController.h"


@interface MembersViewController ()

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITableView *myTable1;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressBar;
@property (weak, nonatomic) IBOutlet UILabel *errorText;
@property (nonatomic) NSMutableArray *members;
@property (nonatomic) NSData *membersData;
@property (nonatomic) NSMutableArray *memberPics;
@property (nonatomic) NSMutableArray *picData;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backButtonHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backButtonWidth;
@property (retain, nonatomic) MemberCardController *memberCardController;
@property int numberOfThreads;



@end

@implementation MembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.numberOfThreads = 15;
    
    self.backButton.clipsToBounds = YES;
    
    int ROUND_BUTTON_WIDTH_HEIGHT = [[UIScreen mainScreen] bounds].size.height/7;
    self.backButtonHeight.constant = ROUND_BUTTON_WIDTH_HEIGHT;
    self.backButtonWidth.constant = ROUND_BUTTON_WIDTH_HEIGHT;
    self.backButton.layer.cornerRadius = ROUND_BUTTON_WIDTH_HEIGHT/2.0f;
    self.backButton.layer.borderColor=[UIColor redColor].CGColor;
    self.backButton.layer.borderWidth=0;
    self.backButton.titleLabel.font = [UIFont systemFontOfSize:ROUND_BUTTON_WIDTH_HEIGHT/3];
    
    self.backButton.layer.masksToBounds = NO;
    self.backButton.layer.shadowColor = [UIColor redColor].CGColor;
    self.backButton.layer.shadowOpacity = .8;
    self.backButton.layer.shadowRadius = 12;
    self.backButton.layer.shadowOffset = CGSizeMake(0, 0);
    
    self.errorText.hidden = YES;
    [self.progressBar startAnimating];
    self.progressBar.hidesWhenStopped = YES;

    
    self.myTable1.delegate=self;
    self.myTable1.dataSource=self;
    self.myTable1.tableFooterView = [UIView new];    
    [self.myTable1 setSeparatorInset:UIEdgeInsetsZero];
    [self.myTable1 setLayoutMargins:UIEdgeInsetsZero];

    [self getMembers];
}

-(void) getMemberPics: (int) memberNumber
{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

        Member *currentMember = self.members[memberNumber];
    
        NSString *urlString = [[@"http://graph.facebook.com/" stringByAppendingString:currentMember.fbID] stringByAppendingString:@"/picture?width=120&height=120"];
        NSURL *membersURL = [NSURL URLWithString: urlString];
        NSData *picData = [NSData dataWithContentsOfURL:membersURL];
        
        if (picData == nil) {
            currentMember.picture = [UIImage imageNamed:@"MemberDefaultIcon.jpg"];
        } else {
            currentMember.picture = [UIImage imageWithData:picData];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.myTable1 reloadData];
            
            if (memberNumber < [self.members count] - self.numberOfThreads) {
                [self getMemberPics: memberNumber + self.numberOfThreads];
            }
        
        });
    });

}

-(void) getMembers
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        self.members = [[NSMutableArray alloc] init];
        
        NSURL *membersURL = [NSURL URLWithString:@"https://docs.google.com/spreadsheets/d/1vCxruEpLacVnikpK4gFpIpqoVFVFQ9KWCCJyqAlbyQc/export?format=csv&id=1vCxruEpLacVnikpK4gFpIpqoVFVFQ9KWCCJyqAlbyQc&gid=0"];
        
        
        self.membersData = [NSData dataWithContentsOfURL:membersURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSData *dataToSet = self.membersData;
            
            if (dataToSet == nil) {
                self.errorText.hidden = NO;
            } else {
                
                NSString *fileContents = [[NSString alloc] initWithData:dataToSet encoding:NSASCIIStringEncoding];
                NSArray *memberRows = [fileContents componentsSeparatedByString:@"\n"];
                for (int i = 1; i < [memberRows count]; i++) {
                    NSArray *currentMember = [memberRows[i] componentsSeparatedByString:@","];
                    Member *newMember = [[Member alloc] init];
                    newMember.name = [[currentMember[1] stringByAppendingString:@" "]
                                                        stringByAppendingString:currentMember[2]];
                    newMember.fbID = currentMember[3];
                    newMember.number = currentMember[4];
                    [self.members addObject:newMember];
                }

                [self.myTable1 reloadData];
                for (int i = 0; i < self.numberOfThreads; i++) {
                    [self getMemberPics: i];
                }
            }
            [self.progressBar stopAnimating];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToMain {
    MainViewController *oView = [[MainViewController alloc] init];
    [self presentViewController:oView animated:NO completion:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger toReturn;
    if (self.members == nil || [self.members count] == 0) {
        toReturn = 0;
    } else {
        toReturn = [self.members count];
    }
    return toReturn;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    if (self.members == nil || [self.members count] == 0) {
        self.myTable1.hidden = YES;
    } else {
        Member *currentMember = self.members[indexPath.row];
        
        cell.textLabel.text = currentMember.name;
        
        if (currentMember.picture != nil) {
            cell.imageView.image = currentMember.picture;
            CGSize destinationSize = CGSizeMake(60, 60);
            UIGraphicsBeginImageContext(destinationSize);
            [cell.imageView.image drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
            cell.imageView.image =  UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        } else {
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"spinner_2" withExtension:@"gif"];
            cell.imageView.image = [UIImage animatedImageWithAnimatedGIFURL:url];
        }
        
        cell.imageView.layer.borderColor = [UIColor grayColor].CGColor;
        cell.imageView.layer.borderWidth = 1.0f;
        cell.imageView.layer.cornerRadius = 10;
        cell.imageView.clipsToBounds = YES;

    }
    [cell setLayoutMargins:UIEdgeInsetsZero];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.memberCardController = [[MemberCardController alloc] init];
    self.memberCardController.member = self.members[indexPath.row];
    [self.view addSubview: self.memberCardController.view];
}




@end
