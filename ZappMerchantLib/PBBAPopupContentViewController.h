//
//  PBBAPopupContentViewController.h
//  ZappMerchantLib
//
//  Created by Alexandru Maimescu on 3/7/16.
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

#import "PBBAPopupHeaderView.h"
#import "PBBAPopupFooterView.h"
#import "PBBAPopupCoordinator.h"
#import "PBBAAppearance.h"

/**
 *  The base class for all popup content view controllers (child view controllers)
 */
@interface PBBAPopupContentViewController : UIViewController

/**
 *  The appearance for view controller.
 */
@property (nonatomic, strong) PBBAAppearance *appearance;

/**
 *  The popup coordinator instance.
 */
@property (nonatomic, weak) PBBAPopupCoordinator *popupCoordinator;

/**
 *  The header view.
 */
@property (nonatomic, weak) IBOutlet PBBAPopupHeaderView *headerView;

/**
 *  The content view.
 */
@property (nonatomic, weak) IBOutlet UIView *contentView;

/**
 *  The footer view.
 */
@property (nonatomic, weak) IBOutlet PBBAPopupFooterView *footerView;

@end
