//
//  main.m
//  ImageSorter
//
//  Created by Maxthon Chan on 13-2-20.
//  Copyright (c) 2013年 Maxthon Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define panic(i, f, ...) { fprintf(stderr, f, ##__VA_ARGS__); exit(i); }
#define apanic(f, ...) { fprintf(stderr, f, ##__VA_ARGS__); abort(); }

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        NSArray *args = [[NSProcessInfo processInfo] arguments];
        if ([args count] < 4)
            panic(1, "USAGE: %s <source-name> <dest-name> <url-prefix>", argv[0]);
        
        NSString *source = args[1];
        NSString *dest = args[2];
        NSURL *baseURL = [NSURL URLWithString:([args[3] hasSuffix:@"/"]) ? args[3] : [args[3] stringByAppendingString:@"/"]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        ;
        
    }
    return 0;
}

