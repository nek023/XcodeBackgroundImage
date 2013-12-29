//
//  XBIImageView.h
//  XcodeBackgroundImage
//
//  Created by Tanaka Katsuma on 2013/12/27.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSUInteger, XBIImageViewImageAlignment) {
    XBIImageViewImageAlignmentCenter = 0,
    XBIImageViewImageAlignmentLeft,
    XBIImageViewImageAlignmentRight,
    XBIImageViewImageAlignmentTop,
    XBIImageViewImageAlignmentTopLeft,
    XBIImageViewImageAlignmentTopRight,
    XBIImageViewImageAlignmentBottom,
    XBIImageViewImageAlignmentBottomLeft,
    XBIImageViewImageAlignmentBottomRight,
    XBIImageViewImageAlignmentScaleToFill,
    XBIImageViewImageAlignmentAspectFit,
    XBIImageViewImageAlignmentAspectFill
};

@interface XBIImageView : NSView

@property (nonatomic, strong) NSColor *backgroundColor;
@property (nonatomic, strong) NSImage *image;
@property (nonatomic, assign) XBIImageViewImageAlignment imageAlignment;
@property (nonatomic, assign) CGFloat opacity;

@end
