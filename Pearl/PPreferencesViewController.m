//
//  PPreferencesViewController.m
//  Pearl
//
//  Created by Maxthon Chan on 13-2-19.
//  Copyright (c) 2013年 Maxthon Chan. All rights reserved.
//

#import "PPreferencesViewController.h"
#import "UIImage+Cache.h"
#import "NSData+Cache.h"

@interface PPreferencesViewController ()

@end

@implementation PPreferencesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([tableView cellForRowAtIndexPath:indexPath].tag)
    {
        case 1:
            // Clean HTTP Cache
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
            [[[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"tk.maxius.pearl.cache-dumped", @"status", @"Cache cleared.")
                                        message:nil
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedStringFromTable(@"tk.maxius.pearl.ok", @"ui", @"OK")
                              otherButtonTitles:nil] show];
            break;
        case 2:
            // Clean local cache
            [UIImage clearCache];
            [NSData clearCache];
            [[[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"tk.maxius.pearl.cache-dumped", @"status", @"Cache cleared.")
                                        message:nil
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedStringFromTable(@"tk.maxius.pearl.ok", @"ui", @"OK")
                              otherButtonTitles:nil] show];
            break;
        case 3:
            // Go to homepage;
            [self dismissViewControllerAnimated:YES
                                     completion:nil];
            break;
    }
    [tableView selectRowAtIndexPath:nil
                           animated:YES
                     scrollPosition:UITableViewScrollPositionNone];
}

@end
