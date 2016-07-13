//
//  PBBAPopupContainerController.m
//  ZappMerchantLib
//
//  Created by Alexandru Maimescu on 3/3/16.
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

#import "PBBAPopupContainerController.h"
#import "PBBAPopupContentViewControllerTransitionContext.h"
#import "PBBAPopupAnimator.h"
#import "UIView+ZPMLib.h"
#import "UIColor+ZPMLib.h"

@interface PBBAPopupContainerController ()

@end

@implementation PBBAPopupContainerController

- (instancetype)initWithContentViewController:(PBBAPopupContentViewController *)viewController
{
    if (self = [super init]) {
        self.activeViewController = viewController;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.view.clipsToBounds = YES;
}

- (void)pushViewController:(PBBAPopupContentViewController *)viewController
{
    if (self.activeViewController) {
        [self transitionFromViewController:self.activeViewController
                          toViewController:viewController];
        
        self.activeViewController = viewController;
    } else {
        self.activeViewController = viewController;
        [self addChildViewController:self.activeViewController];
        [self addContentView:self.activeViewController.view];
        [self.activeViewController didMoveToParentViewController:self];
    }
    
    self.activeViewController.appearance = self.appearance;
}

- (void)addContentView:(UIView *)view
{
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:view];
    [view pbba_pinToSuperviewEdges];
    
    [view setNeedsLayout];
    [view layoutIfNeeded];
}

- (void)setAppearance:(PBBAAppearance *)appearance
{
    _appearance = appearance;
    
    self.view.backgroundColor = self.appearance.backgroundColor;
    self.view.layer.cornerRadius = self.appearance.cornerRadius;
    self.view.layer.borderWidth = self.appearance.borderWidth;
    self.view.layer.borderColor = self.appearance.borderColor.CGColor;
    
    self.activeViewController.appearance = appearance;
}

#pragma mark - Transitions

- (void)transitionFromViewController:(UIViewController *)fromViewController
                    toViewController:(UIViewController *)toViewController
{
    PBBAPopupContentViewControllerTransitionContext *transitionContext =
        [[PBBAPopupContentViewControllerTransitionContext alloc] initWithFromViewController:fromViewController toViewController:toViewController];
    
    [fromViewController willMoveToParentViewController:nil];
    [fromViewController.view pbba_unpinFromSuperview:NSLayoutAttributeBottom];
    [fromViewController.view pbba_unpinFromSuperview:NSLayoutAttributeTrailing];
    [self addChildViewController:toViewController];
    [self addContentView:toViewController.view];
    
    transitionContext.completionBlock = ^(BOOL didComplete) {
        [fromViewController.view removeFromSuperview];
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];
    };
    
    PBBAPopupAnimator *transitionAnimator = [[PBBAPopupAnimator alloc] initWithAnimationType:PBBAPopupAnimationTypeContentTransition];
    [transitionAnimator animateTransition:transitionContext];
}

@end
