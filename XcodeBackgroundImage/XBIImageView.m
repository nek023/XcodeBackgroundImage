//
//  XBIImageView.m
//  XcodeBackgroundImage
//
//  Created by Tanaka Katsuma on 2013/12/27.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "XBIImageView.h"

@implementation XBIImageView

- (BOOL)isOpaque
{
    return YES;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Background
    [self.backgroundColor setFill];
    NSRectFill(self.bounds);
    
    // Calculate destination for image
    NSRect rect = NSZeroRect;
    
    switch (self.imageAlignment) {
        case XBIImageViewImageAlignmentCenter:
            rect = NSMakeRect((self.bounds.size.width - self.image.size.width) / 2.0,
                              (self.bounds.size.height - self.image.size.height) / 2.0,
                              self.image.size.width,
                              self.image.size.height);
            break;
            
        case XBIImageViewImageAlignmentLeft:
            rect = NSMakeRect(0,
                              (self.bounds.size.height - self.image.size.height) / 2.0,
                              self.image.size.width,
                              self.image.size.height);
            break;
            
        case XBIImageViewImageAlignmentRight:
            rect = NSMakeRect(self.bounds.size.width - self.image.size.width,
                              (self.bounds.size.height - self.image.size.height) / 2.0,
                              self.image.size.width,
                              self.image.size.height);
            break;
            
        case XBIImageViewImageAlignmentTop:
            rect = NSMakeRect((self.bounds.size.width - self.image.size.width) / 2.0,
                              self.bounds.size.height - self.image.size.height,
                              self.image.size.width,
                              self.image.size.height);
            break;
            
        case XBIImageViewImageAlignmentTopLeft:
            rect = NSMakeRect(0,
                              self.bounds.size.height - self.image.size.height,
                              self.image.size.width,
                              self.image.size.height);
            break;
            
        case XBIImageViewImageAlignmentTopRight:
            rect = NSMakeRect(self.bounds.size.width - self.image.size.width,
                              self.bounds.size.height - self.image.size.height,
                              self.image.size.width,
                              self.image.size.height);
            break;
            
        case XBIImageViewImageAlignmentBottom:
            rect = NSMakeRect((self.bounds.size.width - self.image.size.width) / 2.0,
                              0,
                              self.image.size.width,
                              self.image.size.height);
            break;
            
        case XBIImageViewImageAlignmentBottomLeft:
            rect = NSMakeRect(0,
                              0,
                              self.image.size.width,
                              self.image.size.height);
            break;
            
        case XBIImageViewImageAlignmentBottomRight:
            rect = NSMakeRect(self.bounds.size.width - self.image.size.width,
                              0,
                              self.image.size.width,
                              self.image.size.height);
            break;
            
        case XBIImageViewImageAlignmentScaleToFill:
            rect = NSMakeRect(0,
                              0,
                              self.bounds.size.width,
                              self.bounds.size.height);
            break;
            
        case XBIImageViewImageAlignmentAspectFit:
        {
            CGFloat viewRatio = self.bounds.size.width / self.bounds.size.height;
            CGFloat imageRatio = self.image.size.width / self.image.size.height;
            
            if (viewRatio < imageRatio) {
                rect.size.width = self.bounds.size.width;
                rect.size.height = self.image.size.height * (self.bounds.size.width / self.image.size.width);
                
                rect.origin.x = 0;
                rect.origin.y = (self.bounds.size.height - rect.size.height) / 2.0;
            } else {
                rect.size.width = self.image.size.width * (self.bounds.size.height / self.image.size.height);
                rect.size.height = self.bounds.size.height;
                
                rect.origin.x = (self.bounds.size.width - rect.size.width) / 2.0;
                rect.origin.y = 0;
            }
        }
            break;
            
        case XBIImageViewImageAlignmentAspectFill:
        {
            CGFloat viewRatio = self.bounds.size.width / self.bounds.size.height;
            CGFloat imageRatio = self.image.size.width / self.image.size.height;
            
            if (viewRatio < imageRatio) {
                rect.size.width = self.image.size.width * (self.bounds.size.height / self.image.size.height);
                rect.size.height = self.bounds.size.height;
                
                rect.origin.x = (self.bounds.size.width - rect.size.width) / 2.0;
                rect.origin.y = 0;
            } else {
                rect.size.width = self.bounds.size.width;
                rect.size.height = self.image.size.height * (self.bounds.size.width / self.image.size.width);
                
                rect.origin.x = 0;
                rect.origin.y = (self.bounds.size.height - rect.size.height) / 2.0;
            }
        }
            break;
    }
    
    // Test against coalesced rect
    if (NSIntersectsRect(rect, dirtyRect)) {
        // Test per dirty rect
        const NSRect *rects;
        NSInteger count;
        [self getRectsBeingDrawn:&rects count:&count];
        
        for (NSInteger i = 0; i < count; i++) {
            if (NSIntersectsRect(rect, rects[i])) {
                // Draw image
                [self.image drawInRect:rect
                              fromRect:NSZeroRect
                             operation:NSCompositeSourceOver
                              fraction:self.opacity];
                
                break;
            }
        }
    }
}


#pragma mark - Accessors

- (void)setBackgroundColor:(NSColor *)backgroundColor
{
    _backgroundColor = backgroundColor;
    
    // Redraw
    [self setNeedsDisplay:YES];
}

- (void)setImage:(NSImage *)image
{
    _image = image;
    
    // Redraw
    [self setNeedsDisplay:YES];
}

- (void)setImageAlignment:(XBIImageViewImageAlignment)imageAlignment
{
    _imageAlignment = imageAlignment;
    
    // Redraw
    [self setNeedsDisplay:YES];
}

- (void)setOpacity:(CGFloat)opacity
{
    _opacity = opacity;
    
    // Redraw
    [self setNeedsDisplay:YES];
}

@end
