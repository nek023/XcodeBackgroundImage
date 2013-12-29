//
//  XBIImageManager.m
//  XcodeBackgroundImage
//
//  Created by Tanaka Katsuma on 2013/12/29.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "XBIImageManager.h"

@implementation XBIImageManager

+ (instancetype)sharedManager
{
    static id _sharedManager;
	static dispatch_once_t _onceToken;
    
	dispatch_once(&_onceToken, ^{
		_sharedManager = [[[self class] alloc] init];
	});
    
    return _sharedManager;
}


#pragma mark - Managing the Background Image

- (NSString *)registeredImagePath
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resourcePath = [bundle resourcePath];
    
    NSError *error = nil;
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:resourcePath error:&error];
    
    if (error) {
        NSAlert *alert = [NSAlert alertWithError:error];
        [alert runModal];
        
        return nil;
    }
    
    for (NSString *fileName in contents) {
        NSString *fileNameWithoutExtension = [fileName stringByDeletingPathExtension];
        
        if ([fileNameWithoutExtension isEqualToString:@"image"]) {
            return [resourcePath stringByAppendingPathComponent:fileName];
        }
    }
    
    return nil;
}

- (BOOL)isImageRegistered
{
    return ([self registeredImagePath] != nil);
}

- (NSImage *)registeredImage
{
    if ([self isImageRegistered]) {
        return [[NSImage alloc] initWithContentsOfFile:[self registeredImagePath]];
    }
    
    return nil;
}

- (BOOL)registerImageAtPath:(NSString *)selectedFilePath
{
    // Remove previous image
    [self removeImage];
    
    // Copy new image
    NSString *extension = [selectedFilePath pathExtension];
    NSString *fileName = [@"image" stringByAppendingPathExtension:extension];
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resourcePath = [bundle resourcePath];
    NSString *filePath = [resourcePath stringByAppendingPathComponent:fileName];
    
    NSError *error = nil;
    if (![[NSFileManager defaultManager] copyItemAtPath:selectedFilePath toPath:filePath error:&error]) {
        NSAlert *alert = [NSAlert alertWithError:error];
        [alert runModal];
        
        return NO;
    }
    
    return YES;
}

- (BOOL)removeImage
{
    if ([self isImageRegistered]) {
        NSString *filePath = [self registeredImagePath];
        
        NSError *error = nil;
        if (![[NSFileManager defaultManager] removeItemAtPath:filePath error:&error]) {
            NSAlert *alert = [NSAlert alertWithError:error];
            [alert runModal];
            
            return NO;
        }
        
        return YES;
    }
    
    return NO;
}

@end
