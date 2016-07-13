//
//  PBBALibraryUtils.h
//  ZappMerchantLib
//
//  Created by Alexandru Maimescu on 6/27/16.
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

#import <Foundation/Foundation.h>

/**
 *  The dictionary key to get the custom PBBA theme value.
 */
extern NSString * _Nonnull const kPBBACustomThemeKey;


/**
 *  The library utils class with helper methods.
 */
@interface PBBALibraryUtils : NSObject

/**
 *  Get the custom PBBA branding configuration.
 *
 *  @return The custom PBBA branding configuration.
 */
+ (nullable NSDictionary *)pbbaCustomConfig;

/**
 *  Set a custom PBBA branding configuration.
 *
 *  @param config The custom PBBA branding configuration.
 */
+ (void)setPBBACustomConfig:(nonnull NSDictionary *)config;

/**
 *  Check if at least one PBBA enabled CFI app is installed on the current device.
 *
 *  @return YES if CFI app is installed.
 */
+ (BOOL)isCFIAppAvailable;

/**
 *  Open the PBBA enabled CFI app.
 *
 *  @param secureToken The secure token to retrieve the transaction details.
 *
 *  @return YES if the process of hand-off to CFI app was successful.
 */
+ (BOOL)openBankingApp:(nonnull NSString *)secureToken;

/**
 *  Check if CFI app should be launched without showing the popup.
 *
 *  @return YES if CFI app should be launched without showing the popup.
 */
+ (BOOL)shouldLaunchCFIApp;

/**
 *  Check if a PBBA enabled CFI app was launched.
 *
 *  @return YES if a PBBA enabled CFI app was launched.
 */
+ (BOOL)wasCFIAppLaunched;

/**
 *  Save that PBBA enabled CFI app was launched.
 */
+ (void)registerCFIAppLaunch;

/**
 *  Open information page about PBBA payments in browser.
 *
 *  @return YES if Safari was launched.
 */
+ (BOOL)openTellMeMoreLink;

@end
