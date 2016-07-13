//
//  PBBACodeInstructionsView.m
//  ZappMerchantLib
//
//  Created by Alexandru Maimescu on 21/07/2015.
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

#import "PBBACodeInstructionsView.h"
#import "PBBACodeView.h"
#import "UIFont+ZPMLib.h"
#import "UIImage+ZPMLib.h"
#import "UIColor+ZPMLib.h"

@interface PBBACodeInstructionsView()

@property (weak, nonatomic) IBOutlet UIView *bandOneView;
@property (weak, nonatomic) IBOutlet UIView *bandTwoView;
@property (weak, nonatomic) IBOutlet UIView *bandThreeView;
@property (weak, nonatomic) IBOutlet UIView *bandFourView;

@property (weak, nonatomic) IBOutlet UILabel *stepOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepThreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepFourALabel;
@property (weak, nonatomic) IBOutlet UILabel *stepFourBLabel;

@property (weak, nonatomic) IBOutlet UIImageView *stepFourImageView;

@property (weak, nonatomic) IBOutlet PBBACodeView *zappCodeView;

@end

@implementation PBBACodeInstructionsView

- (NSAttributedString *)instructionStep1
{
    return self.stepOneLabel.attributedText;
}

- (void)setInstructionStep1:(NSAttributedString *)message
{
    self.stepOneLabel.attributedText = message;
}

- (NSAttributedString *)instructionStep2
{
    return self.stepTwoLabel.attributedText;
}

- (void)setInstructionStep2:(NSAttributedString *)message
{
    self.stepTwoLabel.attributedText = message;
}

- (NSAttributedString *)instructionStep3
{
    return self.stepThreeLabel.attributedText;
}

- (void)setInstructionStep3:(NSAttributedString *)message
{
    self.stepThreeLabel.attributedText = message;
}

- (NSAttributedString *)instructionStep4A
{
    return self.stepFourALabel.attributedText;
}

- (void)setInstructionStep4A:(NSAttributedString *)messagePart
{
    self.stepFourALabel.attributedText = messagePart;
}

- (NSAttributedString *)instructionStep4B
{
    return self.stepFourBLabel.attributedText;
}

- (void)setInstructionStep4B:(NSAttributedString *)messagePart
{
    self.stepFourBLabel.attributedText = messagePart;
}

- (void)setInstructions:(PBBACodeInstructions *)instructions
{
    _instructions = instructions;
    
    self.instructionStep1 = instructions.instructionStep1;
    self.instructionStep2 = instructions.instructionStep2;
    self.instructionStep3 = instructions.instructionStep3;
    self.instructionStep4A = instructions.instructionStep4A;
    self.instructionStep4B = instructions.instructionStep4B;
}

- (NSString *)brn
{
    return self.zappCodeView.brn;
}

- (void)setBrn:(NSString *)brn
{
    self.zappCodeView.brn = brn;
}

#pragma mark - UIAppearance

- (void)setAppearance:(PBBAAppearance *)appearance
{
    [super setAppearance:appearance];
    
    self.zappCodeView.appearance = appearance;
    self.bandOneView.backgroundColor = appearance.secondaryForegroundColor;
    self.bandTwoView.backgroundColor = appearance.secondaryForegroundColor;
    self.bandThreeView.backgroundColor = appearance.secondaryForegroundColor;
    self.bandFourView.backgroundColor = appearance.secondaryForegroundColor;
    self.stepOneLabel.backgroundColor = appearance.backgroundColor;
    self.stepTwoLabel.backgroundColor = appearance.backgroundColor;
    self.stepThreeLabel.backgroundColor = appearance.backgroundColor;
    self.stepFourALabel.backgroundColor = appearance.backgroundColor;
    self.stepFourImageView.backgroundColor = appearance.backgroundColor;
    self.stepFourBLabel.backgroundColor = appearance.backgroundColor;
    self.zappCodeView.backgroundColor = appearance.backgroundColor;
    self.stepOneLabel.textColor = appearance.foregroundColor;
    self.stepTwoLabel.textColor = appearance.foregroundColor;
    self.stepThreeLabel.textColor = appearance.foregroundColor;
    self.stepFourALabel.textColor = appearance.foregroundColor;
    self.stepFourImageView.tintColor = appearance.foregroundColor;
    self.stepFourImageView.image = [self.stepFourImageView.image pbba_templateImage];
    self.stepFourBLabel.textColor = appearance.foregroundColor;
}

@end
