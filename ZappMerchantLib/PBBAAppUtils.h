//
//  PBBAAppUtils.h
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

#import <UIKit/UIKit.h>
#import "PBBAPopupViewController.h"

/**
 *  The utils class with helper methods.
 */
@interface PBBAAppUtils : NSObject

/**
 *  Check if at least one PBBA enabled CFI app is installed on the current device.
 *
 *  @discussion You must whitelist first the 'zapp' scheme in your Info.plist file under the LSApplicationQueriesSchemes key.
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
 *  Show PBBA popup view controller.
 *
 *  @param presenter   The presenter controller which will present the popup view controller.
 *  @param secureToken The human friendly transaction retrieval identifier issued by Zapp.
 *  @param brn         The Basket Reference Number for entry in the CFI app on the consumer’s device.
 *  @param delegate    The popup view controller delegate.
 *
 *  @return An instance of PBBAPopupViewController which has been presented.
 */
+ (nullable PBBAPopupViewController *)showPBBAPopup:(nonnull UIViewController *)presenter
                                        secureToken:(nonnull NSString *)secureToken
                                                brn:(nonnull NSString *)brn
                                           delegate:(nullable id<PBBAPopupViewControllerDelegate>)delegate;

/**
 *  Show PBBA error popup view controller.
 *
 *  @param presenter    The presenter controller which will present the popup view controller.
 *  @param errorCode    The error code to be displayed inside the popup.
 *  @param errorTitle   The error title to be displayed inside the popup.
 *  @param errorMessage The error message to be displayed inside the popup.
 *  @param delegate     The popup view controller delegate.
 *
 *  @return An instance of PBBAPopupViewController which has been presented.
 */
+ (nullable PBBAPopupViewController *)showPBBAErrorPopup:(nonnull UIViewController *)presenter
                                               errorCode:(nullable NSString *)errorCode
                                              errorTitle:(nullable NSString *)errorTitle
                                            errorMessage:(nonnull NSString *)errorMessage
                                                delegate:(nullable id<PBBAPopupViewControllerDelegate>)delegate;

@end
