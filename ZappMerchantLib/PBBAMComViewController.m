//
//  PBBAMComViewController.m
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

#import "PBBAMComViewController.h"
#import "PBBACodeInstructionsView.h"
#import "PBBAPopupMessageView.h"
#import "PBBAPopupButton.h"
#import "PBBACodeInstructions.h"
#import "PBBALibraryUtils.h"
#import "PBBAButton.h"
#import "NSBundle+ZPMLib.h"

@interface PBBAMComViewController ()

@property (weak, nonatomic) IBOutlet PBBAPopupButton *openBankingAppButton;
@property (weak, nonatomic) IBOutlet PBBAPopupButton *getZappCodeButton;

@property (weak, nonatomic) IBOutlet UILabel *openBankingAppTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *openBankingAppMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *getZappCodeMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *getZappCodeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeInstructionsTitleLabel;

@property (weak, nonatomic) IBOutlet PBBACodeInstructionsView *codeInstructionsView;
@property (weak, nonatomic) IBOutlet PBBAPopupMessageView *openBankingAppMessageView;

@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet UIView *separatorView2;

@end

@implementation PBBAMComViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.openBankingAppTitle = PBBALocalizedString(@"com.zapp.mcom.openBankAppTitle");
    self.openBankingAppMessage = PBBALocalizedString(@"com.zapp.mcom.openBankAppMessage");
    self.openBankingAppButtonTitle = [self bankingAppTitle];
    
    if (self.getZappCodeTitleLabel) {
        self.getZappCodeTitle = PBBALocalizedString(@"com.zapp.mcom.getZappCodeTitle");
        self.getZappCodeMessage = PBBALocalizedString(@"com.zapp.mcom.getZappCodeMessage");
    }
    
    if (self.codeInstructionsView) {
        self.codeInstructionsTitle = PBBALocalizedString(@"com.zapp.mcom.codeInstructionsTitle");
        self.codeInstructionsView.instructions = [[PBBACodeInstructions alloc] init];
        self.codeInstructionsView.brn = self.brn;
    }
}

- (NSString *)openBankingAppTitle
{
    return self.openBankingAppTitleLabel.text;
}

- (void)setOpenBankingAppTitle:(NSString *)title
{
    self.openBankingAppTitleLabel.text = title;
}

- (NSString *)openBankingAppMessage
{
    return self.openBankingAppMessageLabel.text;
}

- (void)setOpenBankingAppMessage:(NSString *)message
{
    self.openBankingAppMessageView.message = message;
    self.openBankingAppMessageLabel.text = message;
}

- (NSString *)openBankingAppButtonTitle
{
    return [self.openBankingAppButton titleForState:UIControlStateNormal];
}

- (void)setOpenBankingAppButtonTitle:(NSString *)title
{
    [self.openBankingAppButton setTitle:title forState:UIControlStateNormal];
}

- (NSString *)getZappCodeTitle
{
    return self.getZappCodeTitleLabel.text;
}

- (void)setGetZappCodeTitle:(NSString *)title
{
    self.getZappCodeTitleLabel.text = title;
}

- (NSString *)getZappCodeMessage
{
    return self.getZappCodeMessageLabel.text;
}

- (void)setGetZappCodeMessage:(NSString *)message
{
    self.getZappCodeMessageLabel.text = message;
}

- (NSString *)codeInstructionsTitle
{
    return self.codeInstructionsTitleLabel.text;
}

- (void)setCodeInstructionsTitle:(NSString *)title
{
    self.codeInstructionsTitleLabel.text = title;
}

#pragma mark - Actions

- (IBAction)didPressOpenBankingApp:(id)sender
{
    [self.popupCoordinator closePopupAnimated:YES
                                    initiator:PBBAPopupCloseActionInitiatorSelf
                                   completion:^{
                                       [self.popupCoordinator registerCFIAppLaunch];
                                       [self.popupCoordinator openBankingApp];
                                   }];
}

- (IBAction)didPressGetZappCode:(id)sender
{    
    [self.popupCoordinator updateToLayout:PBBAPopupLayoutTypeECom];
}

#pragma mark - UIAppearance

- (void)setAppearance:(PBBAAppearance *)appearance
{
    [super setAppearance:appearance];
    
    self.codeInstructionsView.appearance = appearance;
    self.openBankingAppButton.appearance = appearance;
    self.getZappCodeButton.appearance = appearance;
    self.openBankingAppMessageView.appearance = appearance;
    
    self.openBankingAppTitleLabel.textColor = appearance.foregroundColor;
    self.openBankingAppMessageLabel.textColor = appearance.foregroundColor;
    self.getZappCodeMessageLabel.textColor = appearance.foregroundColor;
    self.getZappCodeTitleLabel.textColor = appearance.foregroundColor;
    self.codeInstructionsTitleLabel.textColor = appearance.foregroundColor;
    self.separatorView.backgroundColor = [appearance.foregroundColor colorWithAlphaComponent:0.15f];
    self.separatorView2.backgroundColor = [appearance.foregroundColor colorWithAlphaComponent:0.15f];
}

- (NSString *)bankingAppTitle
{
    NSDictionary *pbbaTheme = [PBBALibraryUtils pbbaCustomConfig];
    NSUInteger themeIndex = [pbbaTheme[kPBBACustomThemeKey] integerValue];
    NSString *bankTitle;
    
    switch (themeIndex) {
        case 2:
        case 3:
            bankTitle = PBBALocalizedString(@"com.zapp.mcom.openBankAppButtonTitleCustom");
            break;
        default:
            bankTitle = PBBALocalizedString(@"com.zapp.mcom.openBankAppButtonTitle");
            break;
    }
    
    return bankTitle;
}

@end
