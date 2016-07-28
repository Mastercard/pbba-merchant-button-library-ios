//
//  PBBAPopupCoordinator.m
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

#import "PBBAPopupCoordinator.h"
#import "PBBALibraryUtils.h"

@interface PBBAPopupCoordinator ()

@property (nonatomic, readonly) BOOL isBankAppInstalled;

@end

@implementation PBBAPopupCoordinator

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    if (self = [super init]) {
        self.currentPopupLayout = NSNotFound;
        self.currentEComLayout = NSNotFound;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    }
    
    return self;
}

- (instancetype)initWithSecureToken:(NSString *)secureToken
                                brn:(nonnull NSString *)brn
{
    if (self = [self init]) {
        self.secureToken = secureToken;
        self.brn = brn;
    }
    
    return self;
}

- (instancetype)initWithErrorCode:(NSString *)errorCode
                       errorTitle:(NSString *)errorTitle
                     errorMessage:(NSString *)errorMessage
{
    if (self = [self init]) {
        self.errorCode = errorCode;
        self.errorTitle = errorTitle;
        self.errorMessage = errorMessage;
    }
    
    return self;
}

- (BOOL)isBankAppInstalled
{
    return [PBBALibraryUtils isCFIAppAvailable];
}

- (PBBAPopupEComLayoutType)requiredEComLayout
{
    return self.isBankAppInstalled ? PBBAPopupEComLayoutTypeDefault : PBBAPopupEComLayoutTypeNoBankApp;
}

- (void)updateLayout
{
    if (self.secureToken && self.brn) {
        
        if (self.isBankAppInstalled) {
            [self updateToLayout:PBBAPopupLayoutTypeMCom];
        } else {
            [self updateToLayout:PBBAPopupLayoutTypeECom];
        }
        
    } else if (self.errorMessage) {
        [self updateToLayout:PBBAPopupLayoutTypeError];
    }
}

- (void)updateToLayout:(PBBAPopupLayoutType)layoutType
{
    switch (layoutType) {
        case PBBAPopupLayoutTypeECom:
            [self updateToEComLayout];
            break;
        case PBBAPopupLayoutTypeMCom:
            [self updateToMComLayout];
            break;
        case PBBAPopupLayoutTypeError:
            [self updateToErrorLayout];
            break;
    }
    
    self.currentPopupLayout = layoutType;
}

- (void)updateToEComLayout
{
    if (self.currentPopupLayout == PBBAPopupLayoutTypeECom &&
        self.currentEComLayout == [self requiredEComLayout]) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(popupCoordinator:updateToEComLayout:)]) {
        self.currentEComLayout = [self requiredEComLayout];
        [self.delegate popupCoordinator:self updateToEComLayout:self.currentEComLayout];
    }
}

- (void)updateToMComLayout
{
    if (self.currentPopupLayout == PBBAPopupLayoutTypeMCom) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(popupCoordinatorUpdateToMComLayout:)]) {
        [self.delegate popupCoordinatorUpdateToMComLayout:self];
    }
}

- (void)updateToErrorLayout
{
    if ([self.delegate respondsToSelector:@selector(popupCoordinatorUpdateToErrorLayout:errorTitle:errorMessage:)]) {
        self.errorTitle = self.errorTitle ?: @"";
        self.errorCode = self.errorCode ?: @"";
        NSString *errorMessage = [NSString stringWithFormat:@"%@\n%@", self.errorCode, self.errorMessage];
        [self.delegate popupCoordinatorUpdateToErrorLayout:self errorTitle:self.errorTitle errorMessage:errorMessage];
    }
}

- (void)closePopupAnimated:(BOOL)animated
                 initiator:(PBBAPopupCloseActionInitiator)initiator
                completion:(dispatch_block_t)completion
{
    if ([self.delegate respondsToSelector:@selector(popupCoordinatorClosePopup:initiator:animated:completion:)]) {
        [self.delegate popupCoordinatorClosePopup:self initiator:initiator animated:animated completion:completion];
    }
}

- (void)openBankingApp
{
    [PBBALibraryUtils openBankingApp:self.secureToken];
}

- (void)registerCFIAppLaunch
{
    [PBBALibraryUtils registerCFIAppLaunch];
}

- (void)openTellMeMoreLink
{
    [PBBALibraryUtils openTellMeMoreLink];
}

- (void)retryPaymentRequest
{
    if ([self.delegate respondsToSelector:@selector(popupCoordinatorRetryPaymentRequest:)]) {
        [self.delegate popupCoordinatorRetryPaymentRequest:self];
    }
}

#pragma mark - Notifications

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    // Detect if bank app was installed/uninstalled until the app was in background and update to the proper layout
    if (self.currentPopupLayout != PBBAPopupLayoutTypeError) {
        [self updateLayout];
    }
}

@end
