//
//  XBIUserDefaultsManager.h
//  XcodeBackgroundImage
//
//  Created by Tanaka Katsuma on 2013/12/27.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import <Foundation/Foundation.h>

// Views
#import "XBIImageView.h"

@interface XBIUserDefaultsManager : NSObject

@property (nonatomic, assign, getter = isEnabled) BOOL enabled;
@property (nonatomic, assign) XBIImageViewImageAlignment imageAlignment;
@property (nonatomic, assign) CGFloat opacity;

+ (instancetype)sharedManager;

@end
