//
//  PBBAPopupContentViewController.m
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

#import "PBBAPopupContentViewController.h"
#import "NSBundle+ZPMLib.h"

@implementation PBBAPopupContentViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [super initWithNibName:nibNameOrNil bundle:[NSBundle pbba_merchantResourceBundle]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __weak __typeof__(self) weakSelf = self;
    self.headerView.closeButtonTapHandler = ^{
        [weakSelf.popupCoordinator closePopupWithCompletion:nil];
    };
    
    self.footerView.tellMeMoreButtonTapHandler = ^{
        [weakSelf.popupCoordinator openTellMeMoreLink];
    };
    
    self.footerView.tellMeMoreMessage = PBBALocalizedString(@"com.zapp.view.tellMeMoreFooterMessage");
}

- (void)setAppearance:(PBBAAppearance *)appearance
{
    _appearance = appearance;
    
    self.view.backgroundColor = appearance.backgroundColor;
    self.contentView.backgroundColor = appearance.backgroundColor;
    self.headerView.appearance = appearance;
    self.footerView.appearance = appearance;
}

@end
