//
//  XBISettingsView.h
//  XcodeBackgroundImage
//
//  Created by Tanaka Katsuma on 2013/12/28.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// Views
#import "XBIImageView.h"

@class XBISettingsView;

@protocol XBISettingsViewDelegate <NSObject>

@optional
- (void)settingsView:(XBISettingsView *)settingsView didSelectImageAtPath:(NSString *)selectedFilePath;
- (void)settingsView:(XBISettingsView *)settingsView imageAlignmentDidChange:(XBIImageViewImageAlignment)imageAlignment;
- (void)settingsView:(XBISettingsView *)settingsView opacityDidChange:(CGFloat)opacity;

@end

@interface XBISettingsView : NSView

@property (nonatomic, weak) id<XBISettingsViewDelegate> delegate;
@property (nonatomic, assign) XBIImageViewImageAlignment imageAlignment;
@property (nonatomic, assign) CGFloat opacity;

@end
