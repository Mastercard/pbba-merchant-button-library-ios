//
//  PBBAErrorViewController.m
//  ZappMerchantLib
//
//  Created by Alexandru Maimescu on 3/4/16.
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

#import "PBBAErrorViewController.h"
#import "PBBAButton.h"

@interface PBBAErrorViewController () <PBBAButtonDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet PBBAButton *pbbaButton;

@end

@implementation PBBAErrorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.headerView.type = PBBAPopupHeaderViewTypeError;
    
    self.errorTitle = self.errorTitle;
    self.errorMessage = self.errorMessage;
    
    self.pbbaButton.delegate = self;
}

- (void)setErrorTitle:(NSString *)errorTitle
{
    _errorTitle = errorTitle;
    self.titleLabel.text = errorTitle;
}

- (void)setErrorMessage:(NSString *)errorMessage
{
    _errorMessage = errorMessage;
    self.messageLabel.text = errorMessage;
}

- (void)setAppearance:(PBBAAppearance *)appearance
{
    [super setAppearance:appearance];
    
    self.titleLabel.textColor = appearance.foregroundColor;
    self.messageLabel.textColor = appearance.foregroundColor;
    self.headerView.logoImageView.tintColor = appearance.secondaryForegroundColor;
}

#pragma mark - PBBAButtonDelegate

- (BOOL)pbbaButtonDidPress:(PBBAButton *)paymentButton
{
    [self.popupCoordinator retryPaymentRequest];
    
    return YES;
}

@end
