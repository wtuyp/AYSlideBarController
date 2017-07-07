//
//  AYSlideBarController.m
//  REFrostedViewControllerExample
//
//  Created by alpha yu on 2017/7/7.
//  Copyright © 2017年 Roman Efimov. All rights reserved.
//

#import "AYSlideBarController.h"

@interface AYSlideBarController ()

@property (nonatomic, assign) BOOL automaticSize;
@property (nonatomic, assign) CGSize calculatedMenuViewSize;

@property (nonatomic, strong) NSMutableArray *backgroundViews;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, assign) CGPoint containerOrigin;

@end

@implementation AYSlideBarController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithContentViewController:(UIViewController *)contentViewController
                           menuViewController:(UIViewController *)menuViewController {
    self = [super init];
    if (self) {
        [self commonInit];
        _contentViewController = contentViewController;
        _menuViewController = menuViewController;
    }
    return self;
}

- (void)commonInit {
    _panGestureEnabled = YES;
    _backgroundColor = [UIColor blackColor];
    _backgroundAlpha = 0.3f;
    _animationDuration = 0.27f;
    _menuViewSize = CGSizeZero;
    _automaticSize = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ay_addController:_contentViewController frame:self.view.bounds];
    
    self.backgroundViews = [NSMutableArray array];
    for (NSInteger i = 0; i < 4; i++) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectNull];
        backgroundView.backgroundColor = _backgroundColor;
        backgroundView.alpha = 0.0f;
        [self.view addSubview:backgroundView];
        [self.backgroundViews addObject:backgroundView];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
        [backgroundView addGestureRecognizer:tapRecognizer];
    }
    
    self.containerView = [[UIView alloc] initWithFrame:self.view.bounds];
    _containerView.clipsToBounds = YES;
    [self.view addSubview:_containerView];
    [self updateContainerFrame];
    
    if (_menuViewController) {
        [self addChildViewController:_menuViewController];
        _menuViewController.view.frame = self.containerView.bounds;
        [self.containerView addSubview:_menuViewController.view];
        [_menuViewController didMoveToParentViewController:self];
    }

    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    [_contentViewController.view addGestureRecognizer:_panGestureRecognizer];
}

- (void)setContainerFrame:(CGRect)frame {
    UIView *leftBackgroundView = _backgroundViews[0];
    UIView *topBackgroundView = _backgroundViews[1];
    UIView *bottomBackgroundView = _backgroundViews[2];
    UIView *rightBackgroundView = _backgroundViews[3];
    
    leftBackgroundView.frame = CGRectMake(0, 0, frame.origin.x, self.view.frame.size.height);
    rightBackgroundView.frame = CGRectMake(frame.size.width + frame.origin.x, 0, self.view.frame.size.width - frame.size.width - frame.origin.x, self.view.frame.size.height);
    
    topBackgroundView.frame = CGRectMake(frame.origin.x, 0, frame.size.width, frame.origin.y);
    bottomBackgroundView.frame = CGRectMake(frame.origin.x, frame.size.height + frame.origin.y, frame.size.width, self.view.frame.size.height);
    
    _containerView.frame = frame;
}

- (void)setBackgroundViewsAlpha:(CGFloat)alpha {
    for (UIView *view in self.backgroundViews) {
        view.alpha = alpha;
    }
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.contentViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.contentViewController;
}

#pragma mark - Setters
- (void)setContentViewController:(UIViewController *)contentViewController {
    if (!contentViewController) {
        return;
    }
    
    if (_contentViewController) {
        [self ay_removeController:_contentViewController];
    }
    
    _contentViewController = contentViewController;
    [self ay_addController:_contentViewController frame:self.view.bounds];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}

- (void)setMenuViewController:(UIViewController *)menuViewController {
    if (!menuViewController) {
        return;
    }
    
    if (_menuViewController) {
        [self ay_removeController:_menuViewController];
    }
    
    _menuViewController = menuViewController;
    
    [self addChildViewController:menuViewController];
    menuViewController.view.frame = self.containerView.frame;
    [self.containerView addSubview:menuViewController.view];
    [menuViewController didMoveToParentViewController:self];
}

- (void)setMenuViewWidth:(CGFloat)menuViewWidth {
    _menuViewWidth = menuViewWidth;
    self.menuViewSize = CGSizeMake(_menuViewWidth, self.containerView.bounds.size.height);
}

- (void)setMenuViewSize:(CGSize)menuViewSize {
    _menuViewSize = menuViewSize;
    self.automaticSize = NO;
    [self updateContainerFrame];
}

- (void)updateContainerFrame {
    if (self.automaticSize) {
        if (self.position == AYSlideBarControllerPositionLeft || self.position == AYSlideBarControllerPositionRight)
            self.calculatedMenuViewSize = CGSizeMake(self.contentViewController.view.frame.size.width - 50.0f, _containerView.bounds.size.height);
        
        if (self.position == AYSlideBarControllerPositionTop || self.position == AYSlideBarControllerPositionBottom)
            self.calculatedMenuViewSize = CGSizeMake(self.contentViewController.view.frame.size.width, _containerView.bounds.size.height - 50.0f);
    } else {
        self.calculatedMenuViewSize = CGSizeMake(_menuViewSize.width > 0 ? _menuViewSize.width : self.contentViewController.view.frame.size.width,
                                                 _menuViewSize.height > 0 ? _menuViewSize.height : self.contentViewController.view.frame.size.height);
    }
    
    if (self.isMenuViewVisible) {
        [self updateMenuViewShowStatus];
    } else {
        [self updateMenuViewHideStatus];
    }
}

- (void)updateMenuViewHideStatus {
    if (self.position == AYSlideBarControllerPositionLeft) {
        [self setContainerFrame:CGRectMake(-self.calculatedMenuViewSize.width, 0, self.calculatedMenuViewSize.width, self.calculatedMenuViewSize.height)];
    }
    
    if (self.position == AYSlideBarControllerPositionRight) {
        [self setContainerFrame:CGRectMake(self.view.frame.size.width, 0, self.calculatedMenuViewSize.width, self.calculatedMenuViewSize.height)];
    }
    
    if (self.position == AYSlideBarControllerPositionTop) {
        [self setContainerFrame:CGRectMake(0, -self.calculatedMenuViewSize.height, self.calculatedMenuViewSize.width, self.calculatedMenuViewSize.height)];
    }
    
    if (self.position == AYSlideBarControllerPositionBottom) {
        [self setContainerFrame:CGRectMake(0, self.view.frame.size.height, self.calculatedMenuViewSize.width, self.calculatedMenuViewSize.height)];
    }
    [self setBackgroundViewsAlpha:0];
}

- (void)updateMenuViewShowStatus {
    if (self.position == AYSlideBarControllerPositionLeft) {
        [self setContainerFrame:CGRectMake(0, 0, self.calculatedMenuViewSize.width, self.calculatedMenuViewSize.height)];
    }
    
    if (self.position == AYSlideBarControllerPositionRight) {
        [self setContainerFrame:CGRectMake(self.view.frame.size.width - self.calculatedMenuViewSize.width, 0, self.calculatedMenuViewSize.width, self.calculatedMenuViewSize.height)];
    }
    
    if (self.position == AYSlideBarControllerPositionTop) {
        [self setContainerFrame:CGRectMake(0, 0, self.calculatedMenuViewSize.width, self.calculatedMenuViewSize.height)];
    }
    
    if (self.position == AYSlideBarControllerPositionBottom) {
        [self setContainerFrame:CGRectMake(0, self.view.frame.size.height - self.calculatedMenuViewSize.height, self.calculatedMenuViewSize.width, self.calculatedMenuViewSize.height)];
    }
    [self setBackgroundViewsAlpha:self.backgroundAlpha];
}

- (void)showMenuViewController {
    if (self.isMenuViewVisible) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(slideBarController:willShowMenuViewController:)]) {
        [self.delegate slideBarController:self willShowMenuViewController:self.menuViewController];
    }
    
    void (^completionHandler)(BOOL finished) = ^(BOOL finished) {
        self.isMenuViewVisible = YES;
        
        if ([self.delegate respondsToSelector:@selector(slideBarController:didShowMenuViewController:)]) {
            [self.delegate slideBarController:self didShowMenuViewController:self.menuViewController];
        }
    };
    
    [UIView animateWithDuration:self.animationDuration animations:^{
        [self updateMenuViewShowStatus];
    } completion:completionHandler];
}

- (void)hideMenuViewController {
    [self hideMenuViewControllerWithCompletionHandler:nil];
}

- (void)hideMenuViewControllerWithCompletionHandler:(void(^)(void))completionHandler {
    if (!self.isMenuViewVisible) {
        [self updateMenuViewHideStatus];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(slideBarController:willHideMenuViewController:)]) {
        [self.delegate slideBarController:self willHideMenuViewController:self.menuViewController];
    }
    
    void (^completionHandlerBlock)(BOOL finished) = ^(BOOL finished) {
        self.isMenuViewVisible = NO;
        
        if ([self.delegate respondsToSelector:@selector(slideBarController:didHideMenuViewController:)]) {
            [self.delegate slideBarController:self didHideMenuViewController:self.menuViewController];
        }
        if (completionHandler) {
            completionHandler();
        }
    };
    
    [UIView animateWithDuration:self.animationDuration animations:^{
        [self updateMenuViewHideStatus];
    } completion:completionHandlerBlock];
}

#pragma mark - Rotation handler
- (BOOL)shouldAutorotate {
    return self.contentViewController.shouldAutorotate;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    if ([self.delegate respondsToSelector:@selector(slideBarController:willAnimateRotationToInterfaceOrientation:duration:)])
        [self.delegate slideBarController:self willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self updateContainerFrame];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

#pragma mark - Gesture recognizer
- (void)tapGestureRecognized:(UITapGestureRecognizer *)recognizer {
    [self hideMenuViewController];
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer {
    if (!self.panGestureEnabled)
        return;
    
    CGPoint point = [recognizer translationInView:self.view];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [recognizer.view endEditing:YES];

        self.containerOrigin = self.containerView.frame.origin;

        if ([self.delegate respondsToSelector:@selector(slideBarController:didRecognizePanGesture:)]) {
            [self.delegate slideBarController:self didRecognizePanGesture:recognizer];
        }
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGRect frame = self.containerView.frame;
        if (self.position == AYSlideBarControllerPositionLeft) {
            frame.origin.x = self.containerOrigin.x + point.x;
            if (frame.origin.x > 0) {
                frame.origin.x = 0;
            }
        }
        
        if (self.position == AYSlideBarControllerPositionRight) {
            frame.origin.x = self.containerOrigin.x + point.x;
            if (frame.origin.x < self.view.frame.size.width - self.calculatedMenuViewSize.width) {
                frame.origin.x = self.view.frame.size.width - self.calculatedMenuViewSize.width;
            }
        }
        
        if (self.position == AYSlideBarControllerPositionTop) {
            frame.origin.y = self.containerOrigin.y + point.y;
            if (frame.origin.y > 0) {
                frame.origin.y = 0;
            }
        }
        
        if (self.position == AYSlideBarControllerPositionBottom) {
            frame.origin.y = self.containerOrigin.y + point.y;
            if (frame.origin.y < self.view.frame.size.height - self.calculatedMenuViewSize.height) {
                frame.origin.y = self.view.frame.size.height - self.calculatedMenuViewSize.height;
            }
        }
        
        [self setContainerFrame:frame];
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        if (self.position == AYSlideBarControllerPositionLeft) {
            if ([recognizer velocityInView:self.view].x < 0) {
                [self hideMenuViewController];
            } else {
                [self showMenuViewController];
            }
        }
        
        if (self.position == AYSlideBarControllerPositionRight) {
            if ([recognizer velocityInView:self.view].x < 0) {
                [self showMenuViewController];
            } else {
                [self hideMenuViewController];
            }
        }
        
        if (self.position == AYSlideBarControllerPositionTop) {
            if ([recognizer velocityInView:self.view].y < 0) {
                [self hideMenuViewController];
            } else {
                [self showMenuViewController];
            }
        }
        
        if (self.position == AYSlideBarControllerPositionBottom) {
            if ([recognizer velocityInView:self.view].y < 0) {
                [self showMenuViewController];
            } else {
                [self hideMenuViewController];
            }
        }
    }
}

@end

@implementation UIViewController (AYSlideBarController)

- (void)ay_addController:(UIViewController *)controller frame:(CGRect)frame {
    [self addChildViewController:controller];
    controller.view.frame = frame;
    [self.view addSubview:controller.view];
    [controller didMoveToParentViewController:self];
}

- (void)ay_removeController:(UIViewController *)controller {
    [controller willMoveToParentViewController:nil];
    [controller removeFromParentViewController];
    [controller.view removeFromSuperview];
}

- (AYSlideBarController *)slideBarController {
    UIViewController *iter = self.parentViewController;
    while (iter) {
        if ([iter isKindOfClass:[AYSlideBarController class]]) {
            return (AYSlideBarController *)iter;
        }
        iter = iter.parentViewController;
    }
    return nil;
}

@end
