//
//  PBBAPopupFooterView.m
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

#import "PBBAPopupFooterView.h"
#import "UIImage+ZPMLib.h"

static const CGFloat kTitleImageSpace = 3.0f;


@interface PBBATellMeMoreButton : UIButton

@end

@implementation PBBATellMeMoreButton

- (void)layoutSubviews
{
    CGFloat centerAdjustment = (self.titleLabel.frame.size.height - self.imageView.frame.size.height) / 2;
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -self.imageView.frame.size.width - kTitleImageSpace, 0, self.imageView.frame.size.width + kTitleImageSpace);
    self.imageEdgeInsets = UIEdgeInsetsMake(centerAdjustment, self.titleLabel.frame.size.width + kTitleImageSpace, 0, -self.titleLabel.frame.size.width - kTitleImageSpace);
    
    [super layoutSubviews];
}

@end



@interface PBBAPopupFooterView ()

@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet PBBATellMeMoreButton *tellMeMoreButton;

@end

@implementation PBBAPopupFooterView

- (void)setAppearance:(PBBAAppearance *)appearance
{
    [super setAppearance:appearance];
    
    [self.tellMeMoreButton setTitleColor:appearance.foregroundColor forState:UIControlStateNormal];
    self.tellMeMoreButton.tintColor = appearance.foregroundColor;
    UIImage *templateImage = [[self.tellMeMoreButton imageForState:UIControlStateNormal] pbba_templateImage];
    [self.tellMeMoreButton setImage:templateImage forState:UIControlStateNormal];
    self.separatorView.backgroundColor = [appearance.foregroundColor colorWithAlphaComponent:0.15f];
}

- (NSString *)tellMeMoreMessage
{
    return [self.tellMeMoreButton titleForState:UIControlStateNormal];
}

- (void)setTellMeMoreMessage:(NSString *)message
{
    [self.tellMeMoreButton setTitle:message forState:UIControlStateNormal];
}

- (IBAction)didPressWhatIsPBBAButton:(id)sender
{
    if (self.tellMeMoreButtonTapHandler) {
        self.tellMeMoreButtonTapHandler();
    }
}

@end
