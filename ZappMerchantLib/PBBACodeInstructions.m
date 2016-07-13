//
//  PBBACodeInstructions.m
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

#import "PBBACodeInstructions.h"
#import "NSAttributedString+ZPMLib.h"
#import "UIFont+ZPMLib.h"
#import "NSBundle+ZPMLib.h"

@implementation PBBACodeInstructions

- (instancetype)init
{
    if (self = [super init]) {
        
        NSString *boldFragment = PBBALocalizedString(@"com.zapp.view.codeInstructionsStep1Bold");
        NSAttributedString *step1 = [NSAttributedString pbba_highlightFragments:@[boldFragment]
                                                                        inText:PBBALocalizedString(@"com.zapp.view.codeInstructionsStep1")
                                                                      withFont:[UIFont pbba_regularFontWithSize:16.0f]
                                                                hightlightFont:[UIFont pbba_boldFontWithSize:16.0f]
                                                                     alignment:NSTextAlignmentLeft];
        
        boldFragment = PBBALocalizedString(@"com.zapp.view.codeInstructionsStep2Bold");
        NSAttributedString *step2 = [NSAttributedString pbba_highlightFragments:@[boldFragment]
                                                                        inText:PBBALocalizedString(@"com.zapp.view.codeInstructionsStep2")
                                                                      withFont:[UIFont pbba_regularFontWithSize:16.0f]
                                                                hightlightFont:[UIFont pbba_boldFontWithSize:16.0f]
                                                                     alignment:NSTextAlignmentLeft];
        
        
        boldFragment = PBBALocalizedString(@"com.zapp.view.codeInstructionsStep3Bold");
        NSAttributedString *step3 = [NSAttributedString pbba_highlightFragments:@[boldFragment]
                                                                        inText:PBBALocalizedString(@"com.zapp.view.codeInstructionsStep3")
                                                                      withFont:[UIFont pbba_regularFontWithSize:16.0f]
                                                                hightlightFont:[UIFont pbba_boldFontWithSize:16.0f]
                                                                     alignment:NSTextAlignmentLeft];
        
        boldFragment = PBBALocalizedString(@"com.zapp.view.codeInstructionsStep4Bold");
        NSAttributedString *step4A = [NSAttributedString pbba_highlightFragments:@[boldFragment]
                                                                         inText:PBBALocalizedString(@"com.zapp.view.codeInstructionsStep4A")
                                                                       withFont:[UIFont pbba_regularFontWithSize:16.0f]
                                                                 hightlightFont:[UIFont pbba_boldFontWithSize:16.0f]
                                                                      alignment:NSTextAlignmentLeft];
        
        NSAttributedString *step4B = [NSAttributedString pbba_highlightFragments:nil
                                                                         inText:PBBALocalizedString(@"com.zapp.view.codeInstructionsStep4B")
                                                                       withFont:[UIFont pbba_regularFontWithSize:16.0f]
                                                                 hightlightFont:nil
                                                                      alignment:NSTextAlignmentLeft];
        
        self.instructionStep1 = step1;
        self.instructionStep2 = step2;
        self.instructionStep3 = step3;
        self.instructionStep4A = step4A;
        self.instructionStep4B = step4B;
    }
    
    return self;
}

@end
