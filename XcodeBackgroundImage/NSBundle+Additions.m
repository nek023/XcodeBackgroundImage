//
//  NSBundle+Additions.m
//  XcodeBackgroundImage
//
//  Created by Tanaka Katsuma on 2013/12/27.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "NSBundle+Additions.h"

@implementation NSBundle (Additions)

- (NSString *)shortVersionString
{
    return [self objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

- (NSNumber *)buildNumber
{
    return [self objectForInfoDictionaryKey:@"CFBundleVersion"];
}

@end
