//
//  MemberInfoController.m
//  GT Pike
//
//  Created by Kamen Tsvetkov on 8/10/15.
//  Copyright (c) 2015 Kamen Tsvetkov. All rights reserved.
//

#import "MemberCardController.h"
#import "UIImage+animatedGIF.h"

@interface MemberCardController ()

@property (strong, nonatomic) UIImageView *currentPicture;
@property (strong, nonatomic) NSData *picData;
@property (strong, nonatomic) UITableView *infoTable;

@end

@implementation MemberCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpPicture];
    [self setUpName];
    [self setUpTable];
}

- (void)setUpPicture {

    int pictureX = self.containerWidth/2 - (self.containerHeight/2 - 30)/2;
    int pictureY = 5;
    int pictureHeight = self.containerHeight/2 - 30;
    int pictureWidth = pictureHeight;

    CGRect pictureFrame = CGRectMake(pictureX, pictureY, pictureWidth, pictureHeight);
    self.currentPicture = [[UIImageView alloc] initWithFrame:pictureFrame];
    self.currentPicture.contentMode = UIViewContentModeScaleAspectFit;
    
    self.currentPicture.layer.borderColor = [UIColor grayColor].CGColor;
    self.currentPicture.layer.borderWidth = 1.0f;
    self.currentPicture.layer.cornerRadius = 10;
    self.currentPicture.clipsToBounds = YES;
    
    if (self.member.picture == nil) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"spinner_2" withExtension:@"gif"];
        self.currentPicture.image = [UIImage animatedImageWithAnimatedGIFURL:url];
    } else {
        self.currentPicture.image = self.member.picture;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *urlString = [[@"http://graph.facebook.com/" stringByAppendingString:self.member.fbID] stringByAppendingString:@"/picture?width=999&height=999"];
        NSURL *membersURL = [NSURL URLWithString: urlString];
        self.picData = [NSData dataWithContentsOfURL:membersURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.picData == nil) {
                self.currentPicture.image = [UIImage imageNamed:@"MemberDefaultIcon.jpg"];
            } else {
                self.currentPicture.image = [UIImage imageWithData:self.picData];
            }
        });
    });
    
    [self.containerView addSubview:self.currentPicture];
}

- (void)setUpName {
    CGRect nameFrame = CGRectMake(-1, self.containerHeight/2 - 20, self.containerWidth + 2, 40);
    UILabel *currentName = [[UILabel alloc] initWithFrame:nameFrame];
    currentName.text = self.member.name;
    [currentName setTextColor:[UIColor blackColor]];
    currentName.textAlignment = NSTextAlignmentCenter;
    currentName.backgroundColor = [UIColor colorWithRed:238/255.0 green:232/255.0 blue:205/255.0 alpha:1.0];
    [currentName setFont:[UIFont systemFontOfSize:22]];
    currentName.layer.borderWidth = 1;
    currentName.layer.borderColor = [UIColor colorWithRed:.6 green:0.0 blue:0.07059 alpha:1.0f].CGColor;
    [self.containerView addSubview:currentName];
}

- (void)setUpTable {
    CGRect infoTabeFrame = CGRectMake(0, self.containerHeight/2 + 20, self.containerWidth, self.containerHeight/2 - 20);
    self.infoTable = [[UITableView alloc] initWithFrame:infoTabeFrame];
    self.infoTable.delegate = self;
    self.infoTable.dataSource = self;
    self.infoTable.tableFooterView = [UIView new];
    [self.infoTable setSeparatorInset:UIEdgeInsetsZero];
    [self.infoTable setLayoutMargins:UIEdgeInsetsZero];
    [self.containerView addSubview:self.infoTable];
}


// sections "should be 1"
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// height of a row
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return self.infoTable.frame.size.height/3;
}

// total rows in each section
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int toReturn = 0;
    if (![self.member.number isEqualToString:@""]) {
        toReturn++;
        toReturn++;
    }
    return toReturn;
}

//dataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    if (indexPath.row == 0) {
        NSString *postMessage = self.member.number;
        postMessage = [@"Call: " stringByAppendingString:postMessage];
    
        const CGFloat fontSize = 20;
        UIFont *regularFont = [UIFont systemFontOfSize:fontSize];
        NSDictionary * attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                regularFont,
                                NSFontAttributeName,
                                nil];
        NSMutableAttributedString *attributedPostMessage = [[NSMutableAttributedString alloc] initWithString:postMessage attributes:attrs];
        cell.textLabel.numberOfLines = 1;
        
        [attributedPostMessage addAttribute:NSForegroundColorAttributeName
                       value:[UIColor blueColor]
                       range: (NSRange){0, 5}];
        
        [cell.textLabel setAttributedText:attributedPostMessage];
    }
    
    if (indexPath.row == 1) {
        NSString *postMessage = self.member.number;
        postMessage = [@"Text: " stringByAppendingString:postMessage];
        
        const CGFloat fontSize = 20;
        UIFont *regularFont = [UIFont systemFontOfSize:fontSize];
        NSDictionary * attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                regularFont,
                                NSFontAttributeName,
                                nil];
        NSMutableAttributedString *attributedPostMessage = [[NSMutableAttributedString alloc] initWithString:postMessage attributes:attrs];
        cell.textLabel.numberOfLines = 1;
        
        [attributedPostMessage addAttribute:NSForegroundColorAttributeName
                                      value:[UIColor blueColor]
                                      range: (NSRange){0, 5}];
        
        [cell.textLabel setAttributedText:attributedPostMessage];
    }
    
    [cell setLayoutMargins:UIEdgeInsetsZero];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        NSString *formattedNumber = [self.member.number stringByReplacingOccurrencesOfString:@"-" withString:@""];
        formattedNumber = [@"telprompt:" stringByAppendingString:formattedNumber];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:formattedNumber]];
    }
    if (indexPath.row == 1) {
        NSString *formattedNumber = [self.member.number stringByReplacingOccurrencesOfString:@"-" withString:@""];
        formattedNumber = [@"sms:" stringByAppendingString:formattedNumber];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:formattedNumber]];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
