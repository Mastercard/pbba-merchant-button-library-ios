//
//  PBBAPopupViewController.m
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

#import "PBBAPopupViewController.h"
#import "PBBAPopupContainerController.h"
#import "PBBAPopupCoordinator.h"
#import "PBBAPopupScaleAspectFitAnimationContext.h"
#import "PBBAPopupAnimator.h"
#import "PBBAAppearanceProxy.h"
#import "PBBAAppearance.h"
#import "UIView+ZPMLib.h"

#import "PBBAErrorViewController.h"
#import "PBBAMComViewController.h"
#import "PBBAEComViewController.h"

static UIEdgeInsets const kScreenMargins = {0, 20, 0, 20};

@interface PBBAPopupViewController () <UIViewControllerTransitioningDelegate, PBBAPopupCoordinatorDelegate>

@property (nonatomic, readonly) UIInterfaceOrientation currentInterfaceOrientation;

@property (nonatomic, strong) PBBAPopupContainerController *containerViewController;
@property (nonatomic, strong) PBBAPopupCoordinator *popupCoordinator;
@property (nonatomic, strong) PBBAAppearance *appearance;

@end

@implementation PBBAPopupViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
    }
    
    return self;
}

- (instancetype)initWithSecureToken:(NSString *)secureToken
                                brn:(NSString *)brn
                           delegate:(id<PBBAPopupViewControllerDelegate>)delegate
{
    if (self = [self init]) {
        self.delegate = delegate;
        self.popupCoordinator = [[PBBAPopupCoordinator alloc] initWithSecureToken:secureToken brn:brn];
        self.popupCoordinator.delegate = self;
    }
    
    return self;
}

- (instancetype)initWithErrorCode:(NSString *)errorCode
                       errorTitle:(NSString *)errorTitle
                     errorMessage:(NSString *)errorMessage
                         delegate:(id<PBBAPopupViewControllerDelegate>)delegate
{
    if (self = [self init]) {
        self.delegate = delegate;
        self.popupCoordinator = [[PBBAPopupCoordinator alloc] initWithErrorCode:errorCode errorTitle:errorTitle errorMessage:errorMessage];
        self.popupCoordinator.delegate = self;
    }
    
    return self;
}

- (instancetype)updateWithSecureToken:(NSString *)secureToken
                                  brn:(NSString *)brn
{
    self.popupCoordinator.secureToken = secureToken;
    self.popupCoordinator.brn = brn;
    
    [self.popupCoordinator updateLayout];
    
    return self;
}

- (instancetype)updateWithErrorCode:(NSString *)errorCode
                         errorTitle:(NSString *)errorTitle
                       errorMessage:(NSString *)errorMessage
{
    self.popupCoordinator.secureToken = nil;
    self.popupCoordinator.brn = nil;
    
    self.popupCoordinator.errorCode = errorCode;
    self.popupCoordinator.errorTitle = errorTitle;
    self.popupCoordinator.errorMessage = errorMessage;
    
    [self.popupCoordinator updateLayout];
    
    return self;
}

#pragma mark - Accessors

- (NSString *)secureToken
{
    return self.popupCoordinator.secureToken;
}

- (NSString *)brn
{
    return self.popupCoordinator.brn;
}

- (NSString *)errorCode
{
    return self.popupCoordinator.errorCode;
}

- (NSString *)errorTitle
{
    return self.popupCoordinator.errorTitle;
}

- (NSString *)errorMessage
{
    return self.popupCoordinator.errorMessage;
}

#pragma mark - VC Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure main view
    self.view.backgroundColor = [UIColor clearColor];
    
    // Configure content view controller
    self.containerViewController = [PBBAPopupContainerController new];
    [self addChildViewController:self.containerViewController];
    self.containerViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.containerViewController.view];
    [self.containerViewController didMoveToParentViewController:self];
    
    UIView *contentView = self.containerViewController.view;
    [contentView pbba_centerInSuperview];
    [contentView pbba_leftAlignToView:self.view constant:kScreenMargins.left relation:NSLayoutRelationGreaterThanOrEqual];
    [contentView pbba_rightAlignToView:self.view constant:-kScreenMargins.right relation:NSLayoutRelationLessThanOrEqual];
    
    [self.popupCoordinator updateLayout];
    
    self.appearance = [PBBAAppearance new];
    [[PBBAAppearanceProxy appearanceForClass:[self class]] startForwarding:self];
    self.containerViewController.appearance = self.appearance;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.delegate respondsToSelector:@selector(pbbaPopupViewControllerWillAppear:)]) {
        [self.delegate pbbaPopupViewControllerWillAppear:self];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([self.delegate respondsToSelector:@selector(pbbaPopupViewControllerDidAppear:)]) {
        [self.delegate pbbaPopupViewControllerDidAppear:self];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([self.delegate respondsToSelector:@selector(pbbaPopupViewControllerWillDisappear:)]) {
        [self.delegate pbbaPopupViewControllerWillDisappear:self];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if ([self.delegate respondsToSelector:@selector(pbbaPopupViewControllerDidDisappear:)]) {
        [self.delegate pbbaPopupViewControllerDidDisappear:self];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self updateAspectFitIfNeeded];
}

- (UIInterfaceOrientation)currentInterfaceOrientation
{
    // Due to a bug on iOS 8 the value for self.interfaceOrientation doesn't reflect the real interface orientation during rotation.
    // Workaround: use system status bar orientation which always reflects proper interface orientation.
    return [[UIApplication sharedApplication] statusBarOrientation];
}

- (BOOL)deviceIsTablet
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

- (void)updateAspectFitIfNeeded
{
    if ([self deviceIsTablet]) {
        return;
    }
    
    PBBAPopupScaleAspectFitAnimationContext *scaleContext =
        [[PBBAPopupScaleAspectFitAnimationContext alloc] initWithPopupContainerController:self.containerViewController];
    
    PBBAPopupAnimator *animator = [[PBBAPopupAnimator alloc] initWithAnimationType:PBBAPopupAnimationTypeScaleAspectFit];
    [animator animateTransition:scaleContext];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if ([self deviceIsTablet]) {
        return;
    }
    
    UIView *targetView = self.containerViewController.activeViewController.contentView;
    UIView *contentViewSnapshot = [targetView snapshotViewAfterScreenUpdates:NO];
    [targetView addSubview:contentViewSnapshot];
    
    [UIView animateWithDuration:duration/2 animations:^{
        targetView.alpha = 0;
    } completion:^(BOOL finished) {
        [contentViewSnapshot removeFromSuperview];
        [self updateToMComLayoutIfNeeded];
    }];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if ([self deviceIsTablet]) {
        return;
    }
    
    [UIView animateWithDuration:.1 animations:^{
        self.containerViewController.activeViewController.contentView.alpha = 1;
    }];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    [super traitCollectionDidChange:previousTraitCollection];

    if ([self deviceIsTablet]) {
        return;
    }
    
    if (UIInterfaceOrientationIsLandscape(self.currentInterfaceOrientation)) {
        for (UIViewController *controller in self.childViewControllers) {
            
            UITraitCollection *regularHeightTraits = [UITraitCollection traitCollectionWithVerticalSizeClass:UIUserInterfaceSizeClassRegular];
            UITraitCollection *regularWidthTraits = [UITraitCollection traitCollectionWithHorizontalSizeClass:UIUserInterfaceSizeClassRegular];
            UITraitCollection *traits = [UITraitCollection traitCollectionWithTraitsFromCollections:@[regularWidthTraits, regularHeightTraits]];
            [self setOverrideTraitCollection:traits forChildViewController:controller];
        }
    } else {
        for (UIViewController *controller in self.childViewControllers) {
            [self setOverrideTraitCollection:self.traitCollection forChildViewController:controller];
        }
    }
}

- (void)updateToMComLayoutIfNeeded
{
    if (UIInterfaceOrientationIsLandscape(self.currentInterfaceOrientation) &&
        (self.popupCoordinator.currentPopupLayout == PBBAPopupLayoutTypeECom) &&
        (self.popupCoordinator.currentEComLayout == PBBAPopupEComLayoutTypeDefault)) {
            [self.popupCoordinator updateToLayout:PBBAPopupLayoutTypeMCom];
    }
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    return [[PBBAPopupAnimator alloc] initWithAnimationType:PBBAPopupAnimationTypePresention];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[PBBAPopupAnimator alloc] initWithAnimationType:PBBAPopupAnimationTypeDismissal];
}

#pragma mark - ZPMPopupCoordinatorDelegate

- (void)popupCoordinatorRetryPaymentRequest:(PBBAPopupCoordinator *)coordinator
{
    if ([self.delegate respondsToSelector:@selector(pbbaPopupViewControllerRetryPaymentRequest:)]) {
        [self.delegate pbbaPopupViewControllerRetryPaymentRequest:self];
    }
}

- (void)popupCoordinatorClosePopup:(PBBAPopupCoordinator *)coordinator
                         initiator:(PBBAPopupCloseActionInitiator)initiator
                          animated:(BOOL)animated
                        completion:(dispatch_block_t)completion
{
    [self dismissViewControllerAnimated:animated completion:^{
        
        if (initiator == PBBAPopupCloseActionInitiatorUser &&
            [self.delegate respondsToSelector:@selector(pbbaPopupViewControllerDidCloseByUser:)]) {
            [self.delegate pbbaPopupViewControllerDidCloseByUser:self];
        }
        
        if (completion) completion();
    }];
}

- (void)popupCoordinatorUpdateToMComLayout:(PBBAPopupCoordinator *)coordinator
{
    PBBAMComViewController *mComVC = [PBBAMComViewController new];
    mComVC.popupCoordinator = coordinator;
    mComVC.brn = self.brn;
    
    [self.containerViewController pushViewController:mComVC];
}

- (void)popupCoordinator:(PBBAPopupCoordinator *)coordinator updateToEComLayout:(PBBAPopupEComLayoutType)ecomLayout
{
    PBBAEComViewController *eComVC = [PBBAEComViewController new];
    eComVC.popupCoordinator = coordinator;
    eComVC.brn = self.brn;
    
    if (ecomLayout == PBBAPopupEComLayoutTypeDefault) {
        eComVC.hideNoBankWarningHeader = YES;
    }
    
    [self.containerViewController pushViewController:eComVC];
}

- (void)popupCoordinatorUpdateToErrorLayout:(PBBAPopupCoordinator *)coordinator
                                 errorTitle:(NSString *)title
                               errorMessage:(NSString *)message
{
    PBBAErrorViewController *errorVC = [PBBAErrorViewController new];
    errorVC.popupCoordinator = coordinator;
    errorVC.errorTitle = title;
    errorVC.errorMessage = message;
    [self.containerViewController pushViewController:errorVC];
}

#pragma mark - PBBAUIElementAppearance

+ (instancetype)appearance
{
    return [PBBAAppearanceProxy appearanceForClass:[self class]];
}

+ (instancetype)appearanceWhenContainedIn:(Class<UIAppearanceContainer>)ContainerClass, ...
{
    return [self appearance];
}

+ (instancetype)appearanceForTraitCollection:(UITraitCollection *)trait
{
    return [self appearance];
}

+ (instancetype)appearanceForTraitCollection:(UITraitCollection *)trait whenContainedIn:(Class<UIAppearanceContainer>)ContainerClass, ...
{
    return [self appearance];
}

- (UIColor *)borderColor
{
    return self.appearance.borderColor;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    self.appearance.borderColor = borderColor;
}

- (CGFloat)borderWidth
{
    return self.appearance.borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.appearance.borderWidth = borderWidth;
}

- (CGFloat)cornerRadius
{
    return self.appearance.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.appearance.cornerRadius = cornerRadius;
}

- (UIColor *)backgroundColor
{
    return self.appearance.backgroundColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    self.appearance.backgroundColor = backgroundColor;
}

- (UIColor *)foregroundColor
{
    return self.appearance.foregroundColor;
}

- (void)setForegroundColor:(UIColor *)foregroundColor
{
    self.appearance.foregroundColor = foregroundColor;
}

- (UIColor *)secondaryForegroundColor
{
    return self.appearance.secondaryForegroundColor;
}

- (void)setSecondaryForegroundColor:(UIColor *)secondaryForegroundColor
{
    self.appearance.secondaryForegroundColor = secondaryForegroundColor;
}

@end
