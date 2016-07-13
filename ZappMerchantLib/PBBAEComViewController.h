//
//  PBBAEComViewController.h
//  ZappMerchantLib
//
//  Created by Alexandru Maimescu on 3/8/16.
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

#import "PBBAPopupContentViewController.h"

/**
 *  Popup E-Comm layout view controller
 */
@interface PBBAEComViewController : PBBAPopupContentViewController

/**
 *  The Basket Reference Number for entry in the CFI app on the consumer’s device.
 */
@property (nonatomic, copy) NSString *brn;

/**
 *  Flag which sets if "No PBBA bank app installed" section should be visibile
 */
@property (nonatomic, assign, getter=isNoBankWarningHeaderHidden) BOOL hideNoBankWarningHeader;

/**
 *  Warning message in case if no bank app which support PBBA payments is installed
 */
@property (nonatomic, copy) NSString *noBankAppWarningMessage;

/**
 *  Advice message in case if no bank app which support PBBA payments is installed
 */
@property (nonatomic, copy) NSString *noBankAppAdviceMessage;

/**
 *  PBBA code instructions section title
 */
@property (nonatomic, copy) NSString *codeInstructionsTitle;

@end
