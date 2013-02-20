//
//  PDocumentPreviewViewController.m
//  Pearl
//
//  Created by Maxthon Chan on 13-2-19.
//  Copyright (c) 2013年 Maxthon Chan. All rights reserved.
//

#import "PDocumentPreviewViewController.h"
#import "NSData+Cache.h"

@interface PDocumentPreviewViewController () <UIDocumentInteractionControllerDelegate>

@property UIDocumentInteractionController *documentController;
@property (weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak) IBOutlet UIBarButtonItem *actionButton;
@property (weak) IBOutlet UIView *previewView;
@property (weak) IBOutlet UIWebView *webView;
@property (weak) IBOutlet UINavigationItem *ipadTopBar;

@property NSURL *tempURL;

- (IBAction)actionClicked:(id)sender;

@end

@implementation PDocumentPreviewViewController

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
    
    // Generate the temporary file which contained the inflated document.
    NSURL *tempURL = [NSURL URLWithString:@"tmp"
                            relativeToURL:[NSURL URLWithString:[NSString stringWithFormat:@"file://localhost%@/", NSHomeDirectory()]]];
    self.navigationItem.title = self.data[@"name"];
    self.ipadTopBar.title = self.data[@"name"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *sourceURL = [NSURL URLWithString:self.data[@"file"]];
        NSData *cachedData = [NSData cachedDataAtURL:sourceURL];
        NSData *finalData;
        if ([[[sourceURL lastPathComponent] pathExtension] compare:@"gz" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            // Compressed
            self.tempURL = [NSURL URLWithString:[[sourceURL lastPathComponent] stringByDeletingPathExtension] relativeToURL:tempURL];
            finalData = [cachedData gzipInflate];
        }
        else
        {
            self.tempURL = [NSURL URLWithString:[sourceURL lastPathComponent] relativeToURL:tempURL];
            finalData = [NSData dataWithData:cachedData];
        }
        [finalData writeToURL:self.tempURL atomically:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.documentController = [UIDocumentInteractionController interactionControllerWithURL:self.tempURL];
            self.documentController.delegate = self;
            [self.activityIndicator stopAnimating];
            self.actionButton.enabled = YES;
            [self.webView loadRequest:[NSURLRequest requestWithURL:self.tempURL]];
        });
    });
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.documentController dismissPreviewAnimated:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // Kill the temporary file.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtURL:self.tempURL
                           error:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)actionClicked:(id)sender
{
    [self.documentController presentOptionsMenuFromBarButtonItem:self.actionButton
                                                        animated:YES];
}

@end
