//
//  PBBAEComViewController.m
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

#import "PBBAEComViewController.h"
#import "PBBACodeInstructionsView.h"
#import "NSBundle+ZPMLib.h"

@interface PBBAEComViewController ()

@property (weak, nonatomic) IBOutlet PBBACodeInstructionsView *codeInstructionsView;
@property (weak, nonatomic) IBOutlet UIView *noBankAppInstructionsView;

@property (weak, nonatomic) IBOutlet UILabel *noBankAppWarningMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *noBankAppAdviceMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeInstructionsTitleLabel;

@property (weak, nonatomic) IBOutlet UIView *separatorView;

@end

@implementation PBBAEComViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.codeInstructionsTitle = PBBALocalizedString(@"com.zapp.ecom.codeInstructionsTitle");
    self.codeInstructionsView.instructions = [[PBBACodeInstructions alloc] init];
    self.codeInstructionsView.brn = self.brn;
    
    if (self.hideNoBankWarningHeader) {
        [self.noBankAppInstructionsView removeFromSuperview];
    }
    
    if (self.noBankAppInstructionsView) {
        self.noBankAppWarningMessage = PBBALocalizedString(@"com.zapp.ecom.noBankAppWarningMessage");
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    [super traitCollectionDidChange:previousTraitCollection];
    
    if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) {
        self.noBankAppAdviceMessage = PBBALocalizedString(@"com.zapp.ecom.noBankAppAdviceMessage");
    } else {
        self.noBankAppAdviceMessage = PBBALocalizedString(@"com.zapp.ecom.noBankAppAdviceMessage2");
    }
}

- (NSString *)noBankAppWarningMessage
{
    return self.noBankAppWarningMessageLabel.text;
}

- (void)setNoBankAppWarningMessage:(NSString *)message
{
    self.noBankAppWarningMessageLabel.text = message;
}

- (NSString *)noBankAppAdviceMessage
{
    return self.noBankAppAdviceMessageLabel.text;
}

- (void)setNoBankAppAdviceMessage:(NSString *)message
{
    self.noBankAppAdviceMessageLabel.text = message;
}

- (NSString *)codeInstructionsTitle
{
    return self.codeInstructionsTitleLabel.text;
}

- (void)setCodeInstructionsTitle:(NSString *)title
{
    self.codeInstructionsTitleLabel.text = title;
}

#pragma mark - UIAppearance

- (void)setAppearance:(PBBAAppearance *)appearance
{
    [super setAppearance:appearance];
    
    self.codeInstructionsView.appearance = appearance;
    
    self.noBankAppWarningMessageLabel.textColor = appearance.foregroundColor;
    self.noBankAppAdviceMessageLabel.textColor = appearance.foregroundColor;
    self.codeInstructionsTitleLabel.textColor = appearance.foregroundColor;
    self.separatorView.backgroundColor = [appearance.foregroundColor colorWithAlphaComponent:0.15f];
}

@end
