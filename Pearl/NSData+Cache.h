//
//  NSData+Cache.h
//  Pearl
//
//  Created by Maxthon Chan on 13-2-17.
//  Copyright (c) 2013年 Maxthon Chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+Gzip.h"

static NSString *const NSDataCacheDefaultFolderName = @"NSDataCache";
extern NSString *UIImageCacheFolderName;

@interface NSData (Cache)

+ (void)clearCache;
+ (NSString *)cacheFolderName;
+ (void)setCacheFolderName:(NSString *)folderName;

+ (NSData *)cachedDataAtURL:(NSURL *)location;
- (id)initWithCachedDataAtURL:(NSURL *)location;

@end
