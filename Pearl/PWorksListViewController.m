//
//  PWorksListViewController.m
//  Pearl
//
//  Created by Maxthon Chan on 13-2-17.
//  Copyright (c) 2013年 Maxthon Chan. All rights reserved.
//

#import "PWorksListViewController.h"
#import "NSData+Gzip.h"
#import "PDecl.h"
#import "PDocumentPreviewViewController.h"

@interface PWorksListViewController ()

@property NSArray *contents;

- (IBAction)refresh:(id)sender;

@end

@implementation PWorksListViewController

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl beginRefreshing];
    [self refresh:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh:(id)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *compressedData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.maxius.tk/pearl/works/index.pgz"]];
        NSData *plistData = [compressedData gzipInflate];
        NSArray *articles = [NSPropertyListSerialization propertyListFromData:plistData
                                                             mutabilityOption:0
                                                                       format:NULL
                                                             errorDescription:NULL];
        if (articles)
            self.contents = [articles sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *object1, NSDictionary *object2) {
                NSString *name1 = object1[@"name"];
                NSString *name2 = object2[@"name"];
                return [name1 compare:name2 options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
            }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        });
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController respondsToSelector:@selector(setData:)] && [[self.tableView indexPathForSelectedRow] row] < [self.contents count])
    {
        id target = segue.destinationViewController;
        [target setData:self.contents[[[self.tableView indexPathForSelectedRow] row]]];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.contents)
        return [self.contents count];
    else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    // Configure the cell...
    
    if (self.contents)
    {
        NSDictionary *item = self.contents[[indexPath row]];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.textLabel.text = item[@"name"];
        cell.detailTextLabel.text = item[@"description"];
    }
    else
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = (!self.refreshControl.refreshing) ? NSLocalizedStringFromTable(@"tk.maxius.pearl.load-failed", @"status", @"Can not load the file.") : NSLocalizedStringFromTable(@"tk.maxius.pearl.loading", @"status", @"Loading");
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] < [self.contents count])
    {
        [self performSegueWithIdentifier:@"preview" sender:self];
    }
}

@end
