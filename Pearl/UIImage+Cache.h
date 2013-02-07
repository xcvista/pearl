//
//  UIImage+Cache.h
//  Pearl
//
//  Created by Maxthon Chan on 13-2-8.
//  Copyright (c) 2013年 Maxthon Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const UIImageCacheDefaultFolderName = @"UIImageCache";
extern NSString *UIImageCacheFolderName;

@interface UIImage (Cache)

+ (void)clearCache;
+ (NSString *)cacheFolderName;
+ (void)setCacheFolderName:(NSString *)folderName;

+ (UIImage *)cachedImageAtURL:(NSURL *)location;
- (id)initWithCachedImageAtURL:(NSURL *)location;

@end
