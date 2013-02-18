//
//  PAboutPearlViewController.m
//  Pearl
//
//  Created by Maxthon Chan on 13-2-19.
//  Copyright (c) 2013年 Maxthon Chan. All rights reserved.
//

#import "PAboutPearlViewController.h"

@interface PAboutPearlViewController ()

@property (weak) IBOutlet UIWebView *webView;

@end

@implementation PAboutPearlViewController

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
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[[NSBundle mainBundle] URLForResource:@"about"
                                                                                   withExtension:@"html"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
