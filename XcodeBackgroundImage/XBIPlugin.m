//
//  XBIPlugin.m
//  XcodeBackgroundImage
//
//  Created by Tanaka Katsuma on 2013/12/27.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "XBIPlugin.h"

// Xcode
#import "Xcode.h"

// Categories
#import "NSBundle+Additions.h"

// Shared
#import "XBIUserDefaultsManager.h"
#import "XBIImageManager.h"

// Views
#import "XBIImageView.h"

static id _sharedPlugin = nil;

@interface XBIPlugin ()

@property (nonatomic, strong) NSMenuItem *enableMenuItem;

@property (nonatomic, strong) DVTSourceTextView *sourceTextView;
@property (nonatomic, assign) NSRect sidebarRect;

@end

@implementation XBIPlugin

+ (void)pluginDidLoad:(NSBundle *)bundle
{
    static dispatch_once_t _onceToken;
    dispatch_once(&_onceToken, ^{
        _sharedPlugin = [[[self class] alloc] init];
    });
}

+ (instancetype)sharedPlugIn
{
    return _sharedPlugin;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        // Create menu items
        [self createMenuItems];
        
        // Start observing
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(menuDidChange:)
                                                     name:NSMenuDidChangeItemNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(viewFrameDidChange:)
                                                     name:NSViewFrameDidChangeNotification
                                                   object:nil];
        
        // Show the version information
        NSLog(@"XcodeBackgroundImage v%@ was successfully loaded.", [self.bundle shortVersionString]);
    }
    
    return self;
}

- (void)dealloc
{
    self.sourceTextView = nil;
    
    // Stop observing
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSMenuDidChangeItemNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSViewFrameDidChangeNotification
                                                  object:nil];
}


#pragma mark - Accessors

- (NSBundle *)bundle
{
    return [NSBundle bundleForClass:[self class]];
}


#pragma mark - Notifications

- (void)menuDidChange:(NSNotification *)notification
{
    // Create menu items
    [self createMenuItems];
}

- (void)viewFrameDidChange:(NSNotification *)notification
{
    // Get components
    if ([[notification object] isKindOfClass:[DVTSourceTextView class]]) {
        DVTSourceTextView *sourceTextView = (DVTSourceTextView *)[notification object];
        self.sourceTextView = sourceTextView;
    }
    else if ([[notification object] isKindOfClass:[DVTTextSidebarView class]]) {
        DVTTextSidebarView *textSidebarView = (DVTTextSidebarView *)[notification object];
        self.sidebarRect = textSidebarView.frame;
    }
    
    if (![[XBIImageManager sharedManager] isImageRegistered]) {
        return;
    }
    
    if ([[notification object] isKindOfClass:[DVTSourceTextView class]]) {
        // Show image view
        [self showImageView];
    }
    else if ([[notification object] isKindOfClass:[DVTSourceTextScrollView class]]) {
        // Update image view
        [self updateImageViewFrame];
    }
}


#pragma mark - Menu

- (void)createMenuItems
{
    NSMenuItem *editorMenuItem = [[NSApp mainMenu] itemWithTitle:@"Editor"];
    
    if (editorMenuItem && [[editorMenuItem submenu] itemWithTitle:@"Background Image"] == nil) {
        NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:@"Background Image" action:NULL keyEquivalent:@""];
        
        NSMenu *submenu = [[NSMenu alloc] initWithTitle:@"Background Image"];
        menuItem.submenu = submenu;
        
        // Enable Background Image
        NSMenuItem *enableMenuItem = [[NSMenuItem alloc] initWithTitle:@"Enable Background Image" action:@selector(toggleEnable:) keyEquivalent:@""];
        [enableMenuItem setTarget:self];
        enableMenuItem.state = [[XBIUserDefaultsManager sharedManager] isEnabled] ? NSOnState : NSOffState;
        
        [submenu addItem:enableMenuItem];
        self.enableMenuItem = enableMenuItem;
        
        // Separator
        [submenu addItem:[NSMenuItem separatorItem]];
        
        // Settings
        NSMenuItem *settingsMenuItem = [[NSMenuItem alloc] initWithTitle:@"Settings..." action:@selector(settings:) keyEquivalent:@""];
        [settingsMenuItem setTarget:self];
        
        [submenu addItem:settingsMenuItem];
        
        // Add menu items
        [[editorMenuItem submenu] addItem:[NSMenuItem separatorItem]];
        [[editorMenuItem submenu] addItem:menuItem];
    }
}

- (void)toggleEnable:(id)sender
{
    BOOL enabled = ![[XBIUserDefaultsManager sharedManager] isEnabled];
    [[XBIUserDefaultsManager sharedManager] setEnabled:enabled];
    
    self.enableMenuItem.state = enabled ? NSOnState : NSOffState;
    
    // Show/hide image view
    if (enabled) {
        [self showImageView];
    } else {
        [self hideImageView];
    }
}

- (void)settings:(id)sender
{
    // Show settings
    [self showSettingsView];
}


#pragma mark - Managing the Background View

- (XBIImageView *)findImageViewInView:(NSView *)view
{
    for (NSView *subview in view.subviews) {
        if ([subview isMemberOfClass:[XBIImageView class]]) {
            return (XBIImageView *)subview;
        }
    }
    
    return nil;
}

- (void)showImageView
{
    if (![[XBIUserDefaultsManager sharedManager] isEnabled]) {
        return;
    }
    
    DVTSourceTextView *sourceTextView = self.sourceTextView;
    DVTSourceTextScrollView *scrollView = (DVTSourceTextScrollView *)[sourceTextView enclosingScrollView];
    NSView *superview = [scrollView superview];
    XBIImageView *imageView = [self findImageViewInView:superview];
    
    if (imageView) {
        imageView.image = [[XBIImageManager sharedManager] registeredImage];
    } else {
        if (NSEqualRects(self.sidebarRect, NSZeroRect)) {
            return;
        }
        
        // Clear the background color of text view
        NSColor *backgroundColor = sourceTextView.backgroundColor;
        scrollView.drawsBackground = NO;
        sourceTextView.backgroundColor = [NSColor clearColor];
        
        // Create a image view
        NSRect imageViewFrame = NSMakeRect(self.sidebarRect.size.width,
                                           0,
                                           scrollView.bounds.size.width - self.sidebarRect.size.width,
                                           self.sidebarRect.size.height);
        
        XBIImageView *imageView = [[XBIImageView alloc] initWithFrame:imageViewFrame];
        imageView.backgroundColor = backgroundColor;
        imageView.image = [[XBIImageManager sharedManager] registeredImage];
        imageView.imageAlignment = [[XBIUserDefaultsManager sharedManager] imageAlignment];
        imageView.opacity = [[XBIUserDefaultsManager sharedManager] opacity];
        
        // Add the image view to the editor
        [superview addSubview:imageView positioned:NSWindowBelow relativeTo:nil];
    }
}

- (void)hideImageView
{
    DVTSourceTextView *sourceTextView = self.sourceTextView;
    DVTSourceTextScrollView *scrollView = (DVTSourceTextScrollView *)[sourceTextView enclosingScrollView];
    NSView *superview = [scrollView superview];
    XBIImageView *imageView = [self findImageViewInView:superview];
    
    while (imageView) {
        sourceTextView.backgroundColor = imageView.backgroundColor;
        [imageView removeFromSuperview];
        
        imageView = [self findImageViewInView:superview];
    }
}

- (void)updateImageViewFrame
{
    DVTSourceTextView *sourceTextView = self.sourceTextView;
    DVTSourceTextScrollView *scrollView = (DVTSourceTextScrollView *)[sourceTextView enclosingScrollView];
    NSView *superview = [scrollView superview];
    XBIImageView *imageView = [self findImageViewInView:superview];
    
    if (imageView) {
        NSRect imageViewFrame = NSMakeRect(self.sidebarRect.size.width,
                                           0,
                                           scrollView.bounds.size.width - self.sidebarRect.size.width,
                                           self.sidebarRect.size.height);
        imageView.frame = imageViewFrame;
    }
}


#pragma mark - Settings View

- (void)showSettingsView
{
    // Load nib
    NSViewController *viewController = [[NSViewController alloc] initWithNibName:@"SettingsView" bundle:self.bundle];
    XBISettingsView *settingsView = (XBISettingsView *)viewController.view;
    settingsView.delegate = self;
    settingsView.imageAlignment = [[XBIUserDefaultsManager sharedManager] imageAlignment];
    settingsView.opacity = [[XBIUserDefaultsManager sharedManager] opacity];
    
    // Show modal
    NSAlert *alert = [NSAlert alertWithMessageText:@"Background Image Settings"
                                     defaultButton:@"OK"
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:@"Note: Selected image will be copied into the plug-in."];
    [alert setAccessoryView:settingsView];
    
    [alert beginSheetModalForWindow:[NSApp keyWindow]
                      modalDelegate:self
                     didEndSelector:NULL
                        contextInfo:nil];
}


#pragma mark - XBISettingsViewDelegate

- (void)settingsView:(XBISettingsView *)settingsView didSelectImageAtPath:(NSString *)selectedFilePath
{
    // Copy selected image into bundle
    [[XBIImageManager sharedManager] registerImageAtPath:selectedFilePath];
    
    // Toggle if not enabled
    if (![[XBIUserDefaultsManager sharedManager] isEnabled]) {
        [[XBIUserDefaultsManager sharedManager] setEnabled:YES];
        self.enableMenuItem.state = NSOnState;
    }
    
    // Show image view
    [self showImageView];
}

- (void)settingsView:(XBISettingsView *)settingsView imageAlignmentDidChange:(XBIImageViewImageAlignment)imageAlignment
{
    // Save settings
    [[XBIUserDefaultsManager sharedManager] setImageAlignment:imageAlignment];
    
    // Update image view
    DVTSourceTextView *sourceTextView = self.sourceTextView;
    DVTSourceTextScrollView *scrollView = (DVTSourceTextScrollView *)[sourceTextView enclosingScrollView];
    NSView *superview = [scrollView superview];
    XBIImageView *imageView = [self findImageViewInView:superview];
    
    if (imageView) {
        imageView.imageAlignment = imageAlignment;
    }
}

- (void)settingsView:(XBISettingsView *)settingsView opacityDidChange:(CGFloat)opacity
{
    // Save settings
    [[XBIUserDefaultsManager sharedManager] setOpacity:opacity];
    
    // Update image view
    DVTSourceTextView *sourceTextView = self.sourceTextView;
    DVTSourceTextScrollView *scrollView = (DVTSourceTextScrollView *)[sourceTextView enclosingScrollView];
    NSView *superview = [scrollView superview];
    XBIImageView *imageView = [self findImageViewInView:superview];
    
    if (imageView) {
        imageView.opacity = opacity;
    }
}

@end
