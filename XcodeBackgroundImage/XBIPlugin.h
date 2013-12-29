//
//  XBIPlugin.h
//  XcodeBackgroundImage
//
//  Created by Tanaka Katsuma on 2013/12/27.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import <Foundation/Foundation.h>

// Views
#import "XBISettingsView.h"

@interface XBIPlugin : NSObject <XBISettingsViewDelegate>

@property (readonly) NSBundle *bundle;

+ (void)pluginDidLoad:(NSBundle *)bundle;
+ (instancetype)sharedPlugIn;

@end
