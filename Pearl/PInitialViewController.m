//
//  PInitialViewController.m
//  Pearl
//
//  Created by Maxthon Chan on 13-2-6.
//  Copyright (c) 2013年 Maxthon Chan. All rights reserved.
//

#import "PInitialViewController.h"
#import "UIDevice+Resolutions.h"
#import "NSData+Gzip.h"

@interface PInitialViewController ()

@property (weak) IBOutlet UIImageView *imageView;
@property (weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak) IBOutlet UIButton *proceedButton;
@property (weak) IBOutlet UILabel *crisisLabel;
@property (weak) IBOutlet UIButton *addButton;
@property NSDictionary *crisis;
@property BOOL animating;
@property BOOL doneLoading;

- (IBAction)hideStuff:(id)sender;
- (IBAction)showStuff:(id)sender;
- (IBAction)saveImage:(id)sender;

@end

@implementation PInitialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIDeviceResolution resolution = [[UIDevice currentDevice] resolution];
    if (resolution == UIDeviceResolution_iPhoneRetina4)
    {
        self.imageView.image = [UIImage imageNamed:@"Default-568h"];
    }
    else
    {
        self.imageView.image = [UIImage imageNamed:@"Default"];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [UIView animateWithDuration:0.5
                     animations:^
    {
        self.activityIndicator.alpha = 1;
    }
                     completion:^(BOOL finished)
    {
        if (finished)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
            {
                // Do something
                if (!self.crisis)
                {
                    NSData *gzippedData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.maxius.tk/pearl/crisis.pgz"]];
                    NSData *uncompressedData = [gzippedData gzipInflate];
                    if ([uncompressedData length])
                        self.crisis = [NSPropertyListSerialization propertyListWithData:uncompressedData
                                                                                options:0
                                                                                 format:NULL
                                                                                  error:NULL];
                }
                if (!self.crisis)
                    self.crisis = @{@"show": @YES,
                               @"text": @"Max 有难！"};
                
                dispatch_async(dispatch_get_main_queue(), ^
                {
                    if (![self.crisis[@"closed"] boolValue])
                        self.proceedButton.enabled = YES;
                    if (self.crisis[@"show"])
                        self.crisisLabel.text = self.crisis[@"text"];
                    self.doneLoading = YES;
                    self.animating = NO;
                    [UIView animateWithDuration:0.5 animations:^
                    {
                        self.activityIndicator.alpha = 0;
                        if (![self.crisis[@"closed"] boolValue])
                            self.proceedButton.alpha = 1;
                        if (self.crisis[@"show"])
                            self.crisisLabel.alpha = 1;
                        self.addButton.alpha = 1;
                    }
                                     completion:^(BOOL finished)
                    {
                        if (finished)
                            self.animating = NO;
                    }];
                });
            });
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)hideStuff:(id)sender
{
    if (self.doneLoading && !self.animating)
    {
        self.animating = YES;
        [UIView animateWithDuration:0.5 animations:^
         {
             self.activityIndicator.alpha = 1;
             if (![self.crisis[@"closed"] boolValue])
                 self.proceedButton.alpha = 0;
             if ([self.crisis[@"show"] boolValue])
                 self.crisisLabel.alpha = 0;
         }
                         completion:^(BOOL finished)
         {
             if (finished)
                 self.animating = NO;
         }];
    }
}

- (void)showStuff:(id)sender
{
    if (self.doneLoading && !self.animating)
    {
        self.animating = YES; 
        [UIView animateWithDuration:0.5 animations:^
         {
             self.activityIndicator.alpha = 0;
             if (![self.crisis[@"closed"] boolValue])
                 self.proceedButton.alpha = 1;
             if (self.crisis[@"show"])
                 self.crisisLabel.alpha = 1;
         }
                         completion:^(BOOL finished)
         {
             if (finished)
                 self.animating = NO;
         }];
    }
}

- (void)saveImage:(id)sender
{
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, nil, nil, NULL);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
