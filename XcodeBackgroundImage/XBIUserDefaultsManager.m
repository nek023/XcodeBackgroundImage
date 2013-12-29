//
//  XBIUserDefaultsManager.m
//  XcodeBackgroundImage
//
//  Created by Tanaka Katsuma on 2013/12/27.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "XBIUserDefaultsManager.h"

@implementation XBIUserDefaultsManager

static NSString * const kXBIUserDefaultsManagerEnabledKey = @"jp.questbeat.XcodeBackgroundImage.enabled";
static NSString * const kXBIUserDefaultsManagerFileNameKey = @"jp.questbeat.XcodeBackgroundImage.fileName";
static NSString * const kXBIUserDefaultsManagerImageAlignmentKey = @"jp.questbeat.XcodeBackgroundImage.imageAlignment";
static NSString * const kXBIUserDefaultsManagerOpacityKey = @"jp.questbeat.XcodeBackgroundImage.opacity";

+ (instancetype)sharedManager
{
    static id _sharedManager;
	static dispatch_once_t _onceToken;
    
	dispatch_once(&_onceToken, ^{
		_sharedManager = [[[self class] alloc] init];
	});
    
    return _sharedManager;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        // Register defaults
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults registerDefaults:@{
                                         kXBIUserDefaultsManagerEnabledKey: @(YES),
                                         kXBIUserDefaultsManagerImageAlignmentKey: @(XBIImageViewImageAlignmentCenter),
                                         kXBIUserDefaultsManagerOpacityKey: @(1.0)
                                         }];
        [userDefaults synchronize];
    }
    
    return self;
}


#pragma mark - Accessors

- (void)setEnabled:(BOOL)enabled
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:enabled forKey:kXBIUserDefaultsManagerEnabledKey];
    [userDefaults synchronize];
}

- (BOOL)isEnabled
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:kXBIUserDefaultsManagerEnabledKey];
}

- (void)setImageAlignment:(XBIImageViewImageAlignment)imageAlignment
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@(imageAlignment) forKey:kXBIUserDefaultsManagerImageAlignmentKey];
    [userDefaults synchronize];
}

- (XBIImageViewImageAlignment)imageAlignment
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults objectForKey:kXBIUserDefaultsManagerImageAlignmentKey] unsignedIntegerValue];
}

- (void)setOpacity:(CGFloat)opacity
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@(opacity) forKey:kXBIUserDefaultsManagerOpacityKey];
    [userDefaults synchronize];
}

- (CGFloat)opacity
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults objectForKey:kXBIUserDefaultsManagerOpacityKey] doubleValue];
}

@end
