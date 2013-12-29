//
//  XBIImageManager.h
//  XcodeBackgroundImage
//
//  Created by Tanaka Katsuma on 2013/12/29.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XBIImageManager : NSObject

+ (instancetype)sharedManager;

- (NSString *)registeredImagePath;
- (BOOL)isImageRegistered;
- (NSImage *)registeredImage;
- (BOOL)registerImageAtPath:(NSString *)selectedFilePath;
- (BOOL)removeImage;

@end
