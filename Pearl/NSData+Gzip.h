//
//  NSData+Gzip.h
//  Pearl
//
//  Created by Maxthon Chan on 13-2-8.
//  Copyright (c) 2013年 Maxthon Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Gzip)

- (NSData *) gzipInflate;
- (NSData *) gzipDeflate;

@end
