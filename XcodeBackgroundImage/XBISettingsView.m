//
//  XBISettingsView.m
//  XcodeBackgroundImage
//
//  Created by Tanaka Katsuma on 2013/12/28.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "XBISettingsView.h"

// Shared
#import "XBIImageManager.h"

@interface XBISettingsView ()

@property (weak) IBOutlet NSPopUpButton *positionButton;
@property (weak) IBOutlet NSSlider *opacitySlider;

@end

@implementation XBISettingsView

#pragma mark - Accessors

- (void)setImageAlignment:(XBIImageViewImageAlignment)imageAlignment
{
    [self.positionButton selectItemAtIndex:imageAlignment];
}

- (XBIImageViewImageAlignment)imageAlignment
{
    return [self.positionButton indexOfSelectedItem];
}

- (void)setOpacity:(CGFloat)opacity
{
    // Set value
    [self.opacitySlider setDoubleValue:opacity];
}

- (CGFloat)opacity
{
    return [self.opacitySlider doubleValue];
}


#pragma mark - Actions

- (IBAction)selectImage:(id)sender
{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseDirectories:NO];
    [openPanel setCanChooseFiles:YES];
    [openPanel setAllowedFileTypes:@[@"gif", @"jpg", @"jpeg", @"png"]];
    
    [openPanel beginSheetModalForWindow:[NSApp keyWindow]
                      completionHandler:^(NSInteger result) {
                          if (result == NSOKButton) {
                              NSString *selectedFilePath = [[[openPanel URLs] firstObject] path];
                              
                              // Delegate
                              if (self.delegate && [self.delegate respondsToSelector:@selector(settingsView:didSelectImageAtPath:)]) {
                                  [self.delegate settingsView:self didSelectImageAtPath:selectedFilePath];
                              }
                          }
                      }];
}

- (IBAction)positionDidChange:(id)sender
{
    NSInteger selectedIndex = [self.positionButton indexOfSelectedItem];
    XBIImageViewImageAlignment imageAlignment = (XBIImageViewImageAlignment)selectedIndex;
    
    // Delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(settingsView:imageAlignmentDidChange:)]) {
        [self.delegate settingsView:self imageAlignmentDidChange:imageAlignment];
    }
}

- (IBAction)opacityDidChange:(id)sender
{
    CGFloat opacity = [self.opacitySlider doubleValue];
    
    // Delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(settingsView:opacityDidChange:)]) {
        [self.delegate settingsView:self opacityDidChange:opacity];
    }
}

@end
