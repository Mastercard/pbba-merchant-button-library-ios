//
//  PBBALibraryUtils.m
//  ZappMerchantLib
//
//  Created by Alexandru Maimescu on 6/27/16.
//  Copyright (c) 2020 Mastercard
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

#import <UIKit/UIKit.h>

#import "PBBALibraryUtils.h"

NSString * const kPBBACustomThemeKey = @"pbbaTheme";
NSString * const kPBBACFIAppNameKey = @"cfiAppName";
NSString * const kPBBACFILogosKey = @"showCFILogos";

static NSString * const kPBBACustomConfigFileName       = @"pbbaCustomConfig";
static NSString * const kPBBACFIAppUrlScheme            = @"zapp://";
static NSString * const kPBBAPaymentsInfoURLString      = @"http://www.paybybankapp.co.uk/how-it-works/the-experience/";
static NSString * const kPBBARememberCFIAppLaunchKey    = @"com.zapp.bankapp.remembered";

static NSDictionary *sPBBACustomConfig = nil;
static NSString *sPBBACustomScheme = nil;

@implementation PBBALibraryUtils

+ (NSDictionary *)pbbaCustomConfig
{
    if (sPBBACustomConfig == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:kPBBACustomConfigFileName ofType:@"plist"];
        sPBBACustomConfig = [NSDictionary dictionaryWithContentsOfFile:path];
        [self saveFlagValue:[sPBBACustomConfig [kPBBACFILogosKey] boolValue] forKey:kPBBACFILogosKey];
    }
    return sPBBACustomConfig;
}

+ (void)setPBBACustomConfig:(NSDictionary *)config
{
    sPBBACustomConfig = config;
}

+ (void)setPBBACustomScheme:(NSString *)customScheme
{
    sPBBACustomScheme = customScheme;
}

+ (NSString *)pbbaScheme
{
    return (sPBBACustomScheme) ? sPBBACustomScheme : kPBBACFIAppUrlScheme;
}

+ (BOOL)isCFIAppAvailable
{
    NSURL *urlToCheck = [NSURL URLWithString:[self pbbaScheme]];
    BOOL cfiAppAvailable = [[UIApplication sharedApplication] canOpenURL:urlToCheck];
    
    if (!cfiAppAvailable) {
        [self saveFlagValue:NO forKey:kPBBARememberCFIAppLaunchKey];
    }
    
    return cfiAppAvailable;
}

+ (BOOL)openBankingApp:(NSString *)secureToken
{
    if (secureToken) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self pbbaScheme], secureToken]];
        return [[UIApplication sharedApplication] openURL:url];
    }
    
    return NO;
}

+ (void)registerCFIAppLaunch
{
    [self saveFlagValue:YES forKey:kPBBARememberCFIAppLaunchKey];
}

+ (void)saveFlagValue:(BOOL)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)wasCFIAppLaunched
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kPBBARememberCFIAppLaunchKey];
}

+ (BOOL)shouldLaunchCFIApp {
    return [self wasCFIAppLaunched] && [self isCFIAppAvailable];
}


+(BOOL)shouldShowCFILogos
{
    if ([self pbbaCustomConfig]) {
        //make sure the configurations are loaded from the Appconfig.plist
    }
    return  [[NSUserDefaults standardUserDefaults] boolForKey:kPBBACFILogosKey];
}

@end
