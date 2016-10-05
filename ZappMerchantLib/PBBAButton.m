//
//  PBBAButton.m
//  ZappMerchant
//
//  Created by Alexandru Maimescu on 7/10/15.
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

#import "PBBAButton.h"
#import "PBBAButtonTitleView.h"
#import "PBBALibraryUtils.h"
#import "UIColor+ZPMLib.h"
#import "UIImage+ZPMLib.h"

typedef NS_ENUM(NSInteger, PBBAThemeType) {
    PBBAThemeTypePayByBankApp = 1,
    PBBAThemeTypePingitLight = 2,
    PBBAThemeTypePingitDark = 3
};

static NSTimeInterval const kPBBAButtonActivityTimerTimeInterval = 10;

@interface PBBAButton ()

@property (nonatomic, assign) PBBAThemeType currentThemeType;
@property (nonatomic, strong) PBBAButtonTitleView *originalPBBATitleView;
@property (nonatomic, readonly) UIView *currentPBBATitleView;

@property (nonatomic, strong) UIColor *originalBackgroundColor;
@property (nonatomic, strong) UIColor *highlightedBackgroundColor;

@property (nonatomic, weak) NSTimer *activityTimer;

@end

@implementation PBBAButton

@synthesize cornerRadius = _cornerRadius,
borderColor = _borderColor,
borderWidth = _borderWidth,
foregroundColor = _foregroundColor,
secondaryForegroundColor = _secondaryForegroundColor,
currentPBBATitleView = _currentPBBATitleView;

@dynamic backgroundColor;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    [self addTarget:self action:@selector(tapControl) forControlEvents:UIControlEventTouchUpInside];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    self.clipsToBounds = YES;
    self.userInteractionEnabled = YES;
    self.isAccessibilityElement = YES;
    
    self.accessibilityIdentifier = @"com.zapp.button";
    self.accessibilityLabel = @"Pay by bank app";
    
    [self addSubview:self.currentPBBATitleView];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.currentPBBATitleView
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.currentPBBATitleView
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0]];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    [self styleForTheme:self.currentThemeType];
}

- (void)styleForTheme:(PBBAThemeType)theme
{
    if (theme == PBBAThemeTypePayByBankApp) {
        self.backgroundColor = [UIColor pbba_buttonBackgroundColor];
        self.foregroundColor = [UIColor pbba_buttonForegroundColor];
        self.highlightedBackgroundColor = [UIColor pbba_buttonHighlightedColor];
        self.cornerRadius = 4.0f;
        self.borderWidth = 0;
    } else if (theme == PBBAThemeTypePingitLight) {
        self.backgroundColor = [UIColor whiteColor];
        self.highlightedBackgroundColor = [UIColor pbba_pingitLightHighlightedColor];
        self.borderColor = [UIColor pbba_pingitLightColor];
        self.cornerRadius = 5.0f;
        self.borderWidth = 2.0f;
    } else if (theme == PBBAThemeTypePingitDark) {
        self.backgroundColor = [UIColor pbba_pingitDarkColor];
        self.highlightedBackgroundColor = [UIColor pbba_pingitDarkHighlightedColor];
        self.cornerRadius = 4.0f;
        self.borderWidth = 0;
    }
    
    self.originalBackgroundColor = self.backgroundColor;
}

- (UIView *)currentPBBATitleView
{
    if (_currentPBBATitleView == nil) {
        NSDictionary *pbbaTheme = [PBBALibraryUtils pbbaCustomConfig];
        NSInteger themeIndex = [pbbaTheme[kPBBACustomThemeKey] integerValue];
        PBBAThemeType theme = [self themeTypeForIndex:themeIndex];
        self.currentThemeType = theme;
        _currentPBBATitleView = [self pbbaTitleViewForTheme:theme];
    }
    
    return _currentPBBATitleView;
}

- (PBBAThemeType)themeTypeForIndex:(NSInteger)index
{
    switch (index) {
        case 1:
        case 2:
        case 3:
            return (PBBAThemeType) index;
            
        default:
            break;
    }
    
    return PBBAThemeTypePayByBankApp;
}

- (UIView *)pbbaTitleViewForTheme:(PBBAThemeType)theme;
{
    UIView *titleView;
    
    switch (theme) {
        case PBBAThemeTypePingitLight:
        case PBBAThemeTypePingitDark:
            titleView = [self cobrandedTitleViewWithType:theme];
            break;
        case PBBAThemeTypePayByBankApp:
            titleView = self.originalPBBATitleView;
            break;
    }
    
    return titleView;
}

- (PBBAButtonTitleView *)originalPBBATitleView
{
    if (_originalPBBATitleView == nil) {
        _originalPBBATitleView = [[PBBAButtonTitleView alloc] initWithFrame:self.bounds];
    }
    
    return _originalPBBATitleView;
}

- (UIView *)cobrandedTitleViewWithType:(PBBAThemeType)themeType
{
    NSString *imageName;
    switch (themeType) {
        case PBBAThemeTypePingitLight:
            imageName = @"pbba-button-pingit-light";
            break;
        case PBBAThemeTypePingitDark:
            imageName = @"pbba-button-pingit-dark";
            break;
        default:
            break;
    }
    
    UIImage *paymarkImage = [UIImage pbba_imageNamed:imageName];
    UIImageView *paymarkImageView = [[UIImageView alloc] initWithImage:paymarkImage];
    paymarkImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    return paymarkImageView;
}

- (BOOL)tapControl
{    
    if (!self.enabled) return NO;
    
    if ([self.delegate respondsToSelector:@selector(pbbaButtonDidPress:)] &&
        [self.delegate pbbaButtonDidPress:self]) {
        
        self.enabled = NO;
        [self startActivityTimer];
        [self startAnimating];
        
        return YES;
    }
    
    return NO;
}

- (void)startActivityTimer
{
    self.activityTimer = [NSTimer scheduledTimerWithTimeInterval:kPBBAButtonActivityTimerTimeInterval
                                                          target:self
                                                        selector:@selector(activityTimerDidFire:)
                                                        userInfo:nil
                                                         repeats:NO];
}

- (void)activityTimerDidFire:(NSTimer *)activityTimer
{
    self.enabled = YES;
}

#pragma mark - PBBAAnimatable

- (void)startAnimating
{
    [self.originalPBBATitleView startAnimating];
}

- (void)stopAnimating
{
    [self.originalPBBATitleView stopAnimating];
}

- (BOOL)isAnimating
{
    return [self.originalPBBATitleView isAnimating];
}

#pragma mark - UIControlState

- (void)setHighlighted:(BOOL)highlighted
{
    if (self.highlighted == highlighted) return;
    
    [super setHighlighted:highlighted];
    
    if (self.enabled) {
        self.backgroundColor = (highlighted)
            ? self.highlightedBackgroundColor
            : self.originalBackgroundColor;
    }
}

- (void)setEnabled:(BOOL)enabled
{
    if (self.enabled == enabled) return;
    
    [super setEnabled:enabled];

    if (enabled) {
        [self stopAnimating];
        [self.activityTimer invalidate];
        [UIView animateWithDuration:0.2 animations:^{
            self.backgroundColor = self.originalBackgroundColor;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.backgroundColor = self.highlightedBackgroundColor;
        }];
    }
}

#pragma mark - UIAppearance

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = _cornerRadius;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}

- (void)setForegroundColor:(UIColor *)foregroundColor
{
    _foregroundColor = foregroundColor;
    self.tintColor = foregroundColor;
    self.currentPBBATitleView.tintColor = foregroundColor;
}

@end
