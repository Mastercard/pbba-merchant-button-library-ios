//
//  PBBAPopupCoordinator.h
//  ZappMerchantLib
//
//  Created by Alexandru Maimescu on 3/9/16.
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
 *  The popup layout type
 */
typedef NS_ENUM(NSInteger, PBBAPopupLayoutType) {
    /**
     *  M-Comm layout
     */
    PBBAPopupLayoutTypeMCom,
    /**
     *  E-Comm layout
     */
    PBBAPopupLayoutTypeECom,
    /**
     *  Error layout
     */
    PBBAPopupLayoutTypeError
};

/**
 *  The popup E-Comm layout type
 */
typedef NS_ENUM(NSInteger, PBBAPopupEComLayoutType) {
    /**
     *  The default layout (when bank app is installed)
     */
    PBBAPopupEComLayoutTypeDefault,
    /**
     *  The layout for scenario when bank app is not installed
     */
    PBBAPopupEComLayoutTypeNoBankApp,
};

@class PBBAPopupCoordinator;

/**
 *  The popup coordinator delegate
 */
@protocol PBBAPopupCoordinatorDelegate <NSObject>

/**
 *  Tell the delegate to update to E-Comm layout.
 *
 *  @param coordinator The instance of popup coordinator.
 *  @param ecomLayout  The type of e-comm layout to update to.
 */
- (void)popupCoordinator:(nonnull PBBAPopupCoordinator *)coordinator
      updateToEComLayout:(PBBAPopupEComLayoutType)ecomLayout;

/**
 *  Tell the delegate to update to M-Comm layout.
 *
 *  @param coordinator The instance of popup coordinator.
 */
- (void)popupCoordinatorUpdateToMComLayout:(nonnull PBBAPopupCoordinator *)coordinator;

/**
 *  Tell the delegate to update to Error layout.
 *
 *  @param coordinator The instance of popup coordinator.
 *  @param title       The error title.
 *  @param message     The error message.
 */
- (void)popupCoordinatorUpdateToErrorLayout:(nonnull PBBAPopupCoordinator *)coordinator
                                 errorTitle:(nullable NSString *)title
                               errorMessage:(nonnull NSString *)message;

/**
 *  Tell the delegate to close the popup.
 *
 *  @param coordinator The instance of popup coordinator.
 *  @param completion  The completion handler.
 */
- (void)popupCoordinatorClosePopup:(nonnull PBBAPopupCoordinator *)coordinator
                        completion:(nullable dispatch_block_t)completion;

/**
 *  Tell the delegate to retry the payment request.
 *
 *  @param coordinator The instance of popup coordinator.
 */
- (void)popupCoordinatorRetryPaymentRequest:(nonnull PBBAPopupCoordinator *)coordinator;

@end


/**
 *  The popup coordinator which is responsible for the whole popup presentation logic.
 */
@interface PBBAPopupCoordinator : NSObject

/**
 *  The human friendly transaction retrieval identifier issued by Zapp.
 */
@property (nullable, nonatomic, copy) NSString *secureToken;

/**
 *  The Basket Reference Number for entry in the CFI app on the consumer’s device.
 */
@property (nullable, nonatomic, copy) NSString *brn;

/**
 *  The error code to be displayed inside the popup.
 */
@property (nullable, nonatomic, copy) NSString *errorCode;

/**
 *  The error title to be displayed inside the popup.
 */
@property (nullable, nonatomic, copy) NSString *errorTitle;

/**
 *  The error message to be displayed inside the popup.
 */
@property (nullable, nonatomic, copy) NSString *errorMessage;

/**
 *  The popup coordinator delegate.
 */
@property (nullable, nonatomic, weak) id<PBBAPopupCoordinatorDelegate> delegate;

/**
 *  The current popup layout.
 */
@property (nonatomic, assign) PBBAPopupLayoutType currentPopupLayout;

/**
 *  The current popup E-Comm layout in case if currentPopupLayout is PBBAPopupLayoutTypeECom.
 */
@property (nonatomic, assign) PBBAPopupEComLayoutType currentEComLayout;

/**
 *  Create an instance of PBBAPopupCoordinator.
 *
 *  @param secureToken   The human friendly transaction retrieval identifier issued by Zapp.
 *  @param brn           The Basket Reference Number for entry in the CFI app on the consumer’s device.
 *
 *  @return An instance of PBBAPopupCoordinator.
 */
- (nonnull instancetype)initWithSecureToken:(nonnull NSString *)secureToken
                                        brn:(nonnull NSString *)brn;

/**
 *  Create an instance of PBBAPopupCoordinator.
 *
 *  @param errorCode     The error code to be displayed inside the popup.
 *  @param errorTitle    The error title to be displayed inside the popup.
 *  @param errorMessage  The error message to be displayed inside the popup.
 *
 *  @return An instance of PBBAPopupCoordinator.
 */
- (nonnull instancetype)initWithErrorCode:(nullable NSString *)errorCode
                               errorTitle:(nullable NSString *)errorTitle
                             errorMessage:(nonnull NSString *)errorMessage;

/**
 *  Force coordinator to automatically update the layout.
 *
 *  @discussion The coordinator will decide to which layout to switch according to the current state of transaction / payment request.
 */
- (void)updateLayout;

/**
 *  Force coordinator to update to the given layout.
 *
 *  @param layoutType The layout type.
 */
- (void)updateToLayout:(PBBAPopupLayoutType)layoutType;

/**
 *  Tell coordinator to close the popup.
 *
 *  @param completion The completion handler.
 */
- (void)closePopupWithCompletion:(nullable dispatch_block_t)completion;

/**
 *  Open the bank app.
 */
- (void)openBankingApp;

/**
 *  Save that CFI app was launched.
 */
- (void)registerCFIAppLaunch;

/**
 *  Open information page about PBBA payments in browser.
 */
- (void)openTellMeMoreLink;

/**
 *  Retry the payment request.
 */
- (void)retryPaymentRequest;

@end
