//
//  PBBAPopupHeaderView.h
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
#import "PBBAAutoLoadableView.h"

/**
 *  Popup header view type.
 */
typedef NS_ENUM(NSInteger, PBBAPopupHeaderViewType) {
    /**
     *  The default header type (where PBBA title is displayed)
     */
    PBBAPopupHeaderViewTypeDefault,
    /**
     *  The error header type (where error triangle image is displayed)
     */
    PBBAPopupHeaderViewTypeError
};

/**
 *  Popup header view.
 */
@interface PBBAPopupHeaderView : PBBAAutoLoadableView

/**
 *  The logo image view.
 */
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

/**
 *  The close button.
 */
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

/**
 *  The popup header type.
 */
@property (nonatomic, assign) PBBAPopupHeaderViewType type;

/**
 *  The close button tap handler.
 */
@property (nonatomic, copy) dispatch_block_t closeButtonTapHandler;

@end
