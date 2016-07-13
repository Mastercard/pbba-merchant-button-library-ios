//
//  UIFont+ZPMLib.m
//  ZappMerchantLib
//
//  Created by Alexandru Maimescu on 8/12/14.
//  Copyright 2016 IPCO 2012 Limited
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <CoreText/CoreText.h>
#import "NSBundle+ZPMLib.h"

static NSString * const kZPMBoldFont        = @"SourceSansPro-Bold";
static NSString * const kZPMLightFont       = @"SourceSansPro-Light";
static NSString * const kZPMRegularFont     = @"SourceSansPro-Regular";
static NSString * const kZPMSemiBoldFont    = @"SourceSansPro-Semibold";



@implementation UIFont (ZPMLib)

+ (void)load
{
    [self pbba_loadFonts];
}

+ (void)pbba_loadFonts
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        [self dynamicallyLoadFontNamed:kZPMBoldFont];
        [self dynamicallyLoadFontNamed:kZPMLightFont];
        [self dynamicallyLoadFontNamed:kZPMRegularFont];
        [self dynamicallyLoadFontNamed:kZPMSemiBoldFont];
    });
}

+ (UIFont *)pbba_boldFontWithSize:(CGFloat)size
{
    return [self pbba_fontWithName:kZPMBoldFont size:size];
}

+ (UIFont *)pbba_semiBoldFontWithSize:(CGFloat)size
{
    return [self pbba_fontWithName:kZPMSemiBoldFont size:size];
}

+ (UIFont *)pbba_regularFontWithSize:(CGFloat)size
{
    return [self pbba_fontWithName:kZPMRegularFont size:size];
}

+ (UIFont *)pbba_lightFontWithSize:(CGFloat)size
{
    return [self pbba_fontWithName:kZPMLightFont size:size];
}

+ (UIFont *)pbba_fontWithName:(NSString *)name size:(CGFloat)size
{
    UIFont *font = [UIFont fontWithName:name size:size];
    
    if (!font) {
        
        [[self class] dynamicallyLoadFontNamed:name];
        font = [UIFont fontWithName:name size:size];
        
        // Fallback
        if (!font) font = [UIFont systemFontOfSize:size];
    }
    
    return font;
}

+ (void)dynamicallyLoadFontNamed:(NSString *)name
{
    NSURL *url = [[NSBundle pbba_merchantResourceBundle] URLForResource:name withExtension:@"otf"];
    NSData *fontData = [NSData dataWithContentsOfURL:url];
    
    if (fontData) {
        
        CFErrorRef error;
        CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)fontData);
        CGFontRef font = CGFontCreateWithDataProvider(provider);
        
        if (! CTFontManagerRegisterGraphicsFont(font, &error)) {
            CFStringRef errorDescription = CFErrorCopyDescription(error);
            NSLog(@"Failed to load font: %@", errorDescription);
            CFRelease(errorDescription);
        }
        
        if (font) CFRelease(font);
        if (provider) CFRelease(provider);
    }
}

@end
