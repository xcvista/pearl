//
//  UIViewController+Exit.m
//  Pearl
//
//  Created by Maxthon Chan on 13-2-7.
//  Copyright (c) 2013年 Maxthon Chan. All rights reserved.
//

#import "UIViewController+Exit.h"

@implementation UIViewController (Exit)

- (void)close:(id)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
