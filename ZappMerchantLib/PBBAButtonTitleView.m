//
//  PBBAButtonTitleView.m
//  ZappMerchantLib
//
//  Created by Alexandru Maimescu on 7/20/15.
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

#import "PBBAButtonTitleView.h"
#import "UIImage+ZPMLib.h"

@implementation PBBAButtonTitleView
{
    UIImageView *_titleImageView;
    PBBASquiggleView *_squiggleView;
}

#pragma mark - UIView Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.userInteractionEnabled = YES;
    
    UIImage *titleImage = [UIImage pbba_templateImageNamed:@"button-title-base"];
    NSAssert(titleImage, @"ZappPaymentsButton assets not loaded. Make sure that ZappMerchantLib resources are being loaded.");
    _titleImageView = [[UIImageView alloc] initWithImage:titleImage];
    _titleImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _squiggleView = [[PBBASquiggleView alloc] initWithFrame:CGRectZero];
    [_titleImageView addSubview:_squiggleView];
    
    [self addSubview:_titleImageView];
}

- (void)updateConstraints
{
    NSDictionary *bindedViews = @{@"titleImageView": _titleImageView, @"squiggleView": _squiggleView};
    
    // Squiggle view aspect ratio 1:1
    [_squiggleView addConstraint:[NSLayoutConstraint constraintWithItem:_squiggleView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_squiggleView
                                                              attribute:NSLayoutAttributeWidth
                                                             multiplier:1
                                                               constant:0]];
    

    // Squiggle view height equal to title image view height
    [_titleImageView addConstraint:[NSLayoutConstraint constraintWithItem:_squiggleView
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_titleImageView
                                                                attribute:NSLayoutAttributeHeight
                                                               multiplier:1
                                                                 constant:0]];
    
    // Maximum height for title image view - keep default
    NSString *heightExpression = [NSString stringWithFormat:@"V:[titleImageView(<=%f)]", CGRectGetHeight(_titleImageView.bounds)];
    [_titleImageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightExpression
                                                                            options:0
                                                                            metrics:nil
                                                                              views:bindedViews]];
    
    // Title image view aspect ratio - keep default
    CGFloat multiplier = (CGRectGetHeight(_titleImageView.bounds) / CGRectGetWidth(_titleImageView.bounds)) ?: 1;
    [_titleImageView addConstraint:[NSLayoutConstraint constraintWithItem:_titleImageView
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_titleImageView
                                                                attribute:NSLayoutAttributeWidth
                                                               multiplier:multiplier
                                                                 constant:0]];
    
    // Align squiggle view in title image view
    [_titleImageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(-3)-[squiggleView]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:bindedViews]];
    
    [_titleImageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[squiggleView]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:bindedViews]];
    
    // Align title image view in self
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=5)-[titleImageView]-(>=5)-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:bindedViews]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=5)-[titleImageView]-(>=5)-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:bindedViews]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleImageView
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleImageView
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1
                                                      constant:0]];
    
    [super updateConstraints];
}

- (CGSize)intrinsicContentSize
{
    return _titleImageView.intrinsicContentSize;
}

- (void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
    
    _squiggleView.tintColor = tintColor;
    _titleImageView.tintColor = tintColor;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return NO;
}

#pragma mark - PBBAAnimatable

- (void)startAnimating
{
    [_squiggleView startAnimating];
}

- (void)stopAnimating
{
    [_squiggleView stopAnimating];
}

- (BOOL)isAnimating
{
    return [_squiggleView isAnimating];
}

@end
