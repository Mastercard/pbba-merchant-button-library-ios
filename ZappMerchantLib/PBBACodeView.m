//
//  PBBACodeView.m
//  ZappMerchantLib
//
//  Created by Alexandru Maimescu on 15/07/2015.
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

#import "PBBACodeView.h"
#import "UIFont+ZPMLib.h"

@interface PBBACodeView()

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *zappCodeLabelCollection;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *zappCodeLabelMarginViewCollection;

@property (weak, nonatomic) IBOutlet UIView *groupOne;
@property (weak, nonatomic) IBOutlet UIView *groupTwo;

@end

@implementation PBBACodeView

- (void)setBrn:(NSString *)brn
{
    _brn = brn;
    
    __block NSRange range;
    
    range.length = 1;
    
    NSAssert(brn.length == self.zappCodeLabelCollection.count,
             @"PBBACodeView: Unbalanced BRN: %@ length with label outlet collection length: %tu", brn, self.zappCodeLabelCollection.count);
    
    UIFont *zappCodeFont = [UIFont pbba_semiBoldFontWithSize:17.0f];
    
    [self.zappCodeLabelCollection enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        
        range.location = idx;
        
        NSString *letter = [brn substringWithRange:range];
        
        label.text = letter;
        label.font = zappCodeFont;
        label.textAlignment = NSTextAlignmentCenter;
    }];
}

#pragma mark - UIAppearance

- (void)setAppearance:(PBBAAppearance *)appearance
{
    [super setAppearance:appearance];
    
    self.backgroundColor = appearance.backgroundColor;
    
    self.groupOne.layer.borderColor = appearance.secondaryForegroundColor.CGColor;
    self.groupTwo.layer.borderColor = appearance.secondaryForegroundColor.CGColor;
    self.groupOne.layer.cornerRadius = appearance.cornerRadius;
    self.groupTwo.layer.cornerRadius = appearance.cornerRadius;
    self.groupOne.layer.borderWidth = appearance.borderWidth;
    self.groupTwo.layer.borderWidth = appearance.borderWidth;
    
    for (UILabel *label in self.zappCodeLabelCollection) {
        label.backgroundColor = appearance.backgroundColor;
    }
    
    for (UILabel *label in self.zappCodeLabelCollection) {
        [label setTextColor:appearance.foregroundColor];
    }
    
    for (UIView *marginView in self.zappCodeLabelMarginViewCollection){
        marginView.backgroundColor = [appearance.foregroundColor colorWithAlphaComponent:0.15f];
    }
}

@end
