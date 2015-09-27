//
//  MenuViewController.m
//  GT Pike
//
//  Created by Kamen Tsvetkov on 4/15/15.
//  Copyright (c) 2015 Kamen Tsvetkov. All rights reserved.
//

#import "MenuViewController.h"
#import "MainViewController.h"
#import "myUtilities.h"
#import <QuartzCore/QuartzCore.h>

@interface MenuViewController ()

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backButtonHeight;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressBar;
@property (weak, nonatomic) IBOutlet UILabel *errorText;
@property (nonatomic, retain) NSData *pdfData;
@property (weak, nonatomic) IBOutlet UIWebView *pdfView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *pinchToZoomLabel;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.progressBar startAnimating];
    self.scrollView.hidden = YES;
    self.errorText.hidden = YES;
    self.progressBar.hidesWhenStopped = YES;
    self.scrollView.delegate = self;
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 4.0;
    self.scrollView.bouncesZoom = NO;
    

    
    self.pdfView.scalesPageToFit=YES;
    self.pdfView.scrollView.clipsToBounds = NO;
    [self.pdfView.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.pdfView.scrollView setShowsVerticalScrollIndicator:NO];
    self.pdfView.delegate = self;
    
    self.pinchToZoomLabel.layer.borderColor = [UIColor grayColor].CGColor;
    self.pinchToZoomLabel.layer.borderWidth = 2.0;
    self.pinchToZoomLabel.layer.cornerRadius = 7;
    self.pinchToZoomLabel.clipsToBounds = YES;
    
    int ROUND_BUTTON_WIDTH_HEIGHT = [[UIScreen mainScreen] bounds].size.height/7;
    self.backButtonHeight.constant = ROUND_BUTTON_WIDTH_HEIGHT;
    self.backButtonWidth.constant = ROUND_BUTTON_WIDTH_HEIGHT;
    self.backButton.layer.cornerRadius = ROUND_BUTTON_WIDTH_HEIGHT/2.0f;
    self.backButton.layer.borderColor = [UIColor redColor].CGColor;
    self.backButton.layer.borderWidth = 0;
    self.backButton.titleLabel.font = [UIFont systemFontOfSize:ROUND_BUTTON_WIDTH_HEIGHT/3];
    
    self.backButton.layer.masksToBounds = NO;
    self.backButton.layer.shadowColor = [UIColor redColor].CGColor;
    self.backButton.layer.shadowOpacity = .8;
    self.backButton.layer.shadowRadius = 12;
    self.backButton.layer.shadowOffset = CGSizeMake(0, 0);


    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

        NSURL *imageURL = [NSURL URLWithString:@"https://drive.google.com/uc?export=download&id=0B1r4kF70jTvVQVRMTUVqRGxoTnc"];
        self.pdfData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSData *dataToSet = self.pdfData;
            
            if (dataToSet == nil) {
                self.errorText.hidden = NO;
                [self.progressBar stopAnimating];
            } else {
                [_pdfView loadData:dataToSet MIMEType:@"application/pdf" textEncodingName:@"utf-8" baseURL:nil];
            }
        });
    });
    
}


//THIS ONE WORKS
/*
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    scale *= [[[self.scrollView window] screen] scale];
    [view setContentScaleFactor:scale];
    for (UIView *subview in view.subviews) {
        [subview setContentScaleFactor:scale];
    }
}
 */


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    double delayInSeconds = .2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.scrollView.hidden = NO;
        [self.progressBar stopAnimating];
    });
}


- (IBAction)backToMain {
    MainViewController *oView = [[MainViewController alloc] init];
    [self presentViewController:oView animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
