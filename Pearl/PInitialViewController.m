//
//  PInitialViewController.m
//  Pearl
//
//  Created by Maxthon Chan on 13-2-6.
//  Copyright (c) 2013年 Maxthon Chan. All rights reserved.
//

#import "PInitialViewController.h"
#import "UIDevice+Resolutions.h"

@interface PInitialViewController ()

@property (weak) IBOutlet UIImageView *imageView;
@property (weak) IBOutlet UIActivityIndicatorView *activityIndicator;

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
                sleep(1);
                
                dispatch_async(dispatch_get_main_queue(), ^
                {
                    [self performSegueWithIdentifier:@"proceed" sender:self];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
