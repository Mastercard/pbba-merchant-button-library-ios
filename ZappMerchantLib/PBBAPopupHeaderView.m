//
//  PBBAPopupHeaderView.m
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

#import "PBBAPopupHeaderView.h"
#import "UIImage+ZPMLib.h"
#import "UIColor+ZPMLib.h"

@interface PBBAPopupHeaderView ()

@end

@implementation PBBAPopupHeaderView

- (void)setType:(PBBAPopupHeaderViewType)type
{
    _type = type;
    
    switch (type) {
        case PBBAPopupHeaderViewTypeDefault:
            self.logoImageView.image = [UIImage pbba_pbbaTitleImage];
            break;
        case PBBAPopupHeaderViewTypeError:
            self.logoImageView.image = [UIImage pbba_errorImage];
            break;
            
        default:
            break;
    }
}

- (IBAction)didPressCloseButton:(id)sender
{
    if (self.closeButtonTapHandler) {
        self.closeButtonTapHandler();
    }
}

- (void)setAppearance:(PBBAAppearance *)appearance
{
    [super setAppearance:appearance];
    
    self.closeButton.tintColor = appearance.foregroundColor;
    self.logoImageView.tintColor = appearance.foregroundColor;
    
    // Ensure that all images are rendered as templates
    UIImage *templateImage = [[self.closeButton imageForState:UIControlStateNormal] pbba_templateImage];
    [self.closeButton setImage:templateImage forState:UIControlStateNormal];
    self.logoImageView.image = [self.logoImageView.image pbba_templateImage];
}

@end
