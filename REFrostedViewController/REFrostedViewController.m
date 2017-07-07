//
// REFrostedViewController.m
// REFrostedViewController
//
// Copyright (c) 2013 Roman Efimov (https://github.com/romaonthego)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "REFrostedViewController.h"

#import "REFrostedContainerViewController.h"

@interface REFrostedViewController ()

@property (nonatomic, assign) BOOL visible;
@property (nonatomic, strong) REFrostedContainerViewController *containerViewController;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, assign) BOOL automaticSize;
@property (nonatomic, assign) CGSize calculatedMenuViewSize;

@end

@implementation REFrostedViewController

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
    _animationDuration = 0.27f;
    _backgroundAlpha = 0.3f;
    _menuViewSize = CGSizeZero;
    _automaticSize = YES;
    
    _containerViewController = [[REFrostedContainerViewController alloc] init];
    _containerViewController.frostedViewController = self;
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:_containerViewController action:@selector(panGestureRecognized:)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self re_addController:self.contentViewController frame:self.view.bounds];
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
        [self re_removeController:_contentViewController];
    }
    
    _contentViewController = contentViewController;
    [self re_addController:_contentViewController frame:self.view.bounds];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}

- (void)setMenuViewController:(UIViewController *)menuViewController {
    if (!menuViewController) {
        return;
    }
    
    if (_menuViewController) {
        [self re_removeController:_menuViewController];
    }
    
    _menuViewController = menuViewController;
    
    [self.containerViewController addChildViewController:menuViewController];
    menuViewController.view.frame = self.containerViewController.containerView.bounds;
    [self.containerViewController.containerView addSubview:menuViewController.view];
    [menuViewController didMoveToParentViewController:self];
}

- (void)setMenuViewWidth:(CGFloat)menuViewWidth {
    _menuViewWidth = menuViewWidth;
    self.menuViewSize = CGSizeMake(_menuViewWidth, self.contentViewController.view.frame.size.height);
}

- (void)setMenuViewSize:(CGSize)menuViewSize {
    _menuViewSize = menuViewSize;
    self.automaticSize = NO;
}

#pragma mark -
- (void)presentMenuViewController {
    [self presentMenuViewControllerWithAnimatedApperance:YES];
}

- (void)presentMenuViewControllerWithAnimatedApperance:(BOOL)animateApperance {
    self.containerViewController.animateApperance = animateApperance;
    if (self.automaticSize) {
        if (self.direction == REFrostedViewControllerDirectionLeft || self.direction == REFrostedViewControllerDirectionRight)
            self.calculatedMenuViewSize = CGSizeMake(self.contentViewController.view.frame.size.width - 50.0f, self.contentViewController.view.frame.size.height);
        
        if (self.direction == REFrostedViewControllerDirectionTop || self.direction == REFrostedViewControllerDirectionBottom)
            self.calculatedMenuViewSize = CGSizeMake(self.contentViewController.view.frame.size.width, self.contentViewController.view.frame.size.height - 50.0f);
    } else {
        self.calculatedMenuViewSize = CGSizeMake(_menuViewSize.width > 0 ? _menuViewSize.width : self.contentViewController.view.frame.size.width,
                                                 _menuViewSize.height > 0 ? _menuViewSize.height : self.contentViewController.view.frame.size.height);
    }
    
    [self re_addController:self.containerViewController frame:self.contentViewController.view.frame];
}

- (void)hideMenuViewController {
    [self hideMenuViewControllerWithCompletionHandler:nil];
}

- (void)hideMenuViewControllerWithCompletionHandler:(void(^)(void))completionHandler {
    if (!self.visible) {//when call hide menu before menuViewController added to containerViewController, the menuViewController will never added to containerViewController
        return;
    }

    [self.containerViewController hideWithCompletionHandler:completionHandler];
}

- (void)resizeMenuViewControllerToSize:(CGSize)size {
    [self.containerViewController resizeToSize:size];
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer {
    if (!self.panGestureEnabled)
        return;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self presentMenuViewControllerWithAnimatedApperance:NO];
        if ([self.delegate respondsToSelector:@selector(frostedViewController:didRecognizePanGesture:)]) {
            [self.delegate frostedViewController:self didRecognizePanGesture:recognizer];
        }
    }
    
    [self.containerViewController panGestureRecognized:recognizer];
}

#pragma mark - Rotation handler
- (BOOL)shouldAutorotate {
    return self.contentViewController.shouldAutorotate;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    if ([self.delegate respondsToSelector:@selector(frostedViewController:willAnimateRotationToInterfaceOrientation:duration:)])
        [self.delegate frostedViewController:self willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if (self.visible) {
        if (self.automaticSize) {
            if (self.direction == REFrostedViewControllerDirectionLeft || self.direction == REFrostedViewControllerDirectionRight)
                self.calculatedMenuViewSize = CGSizeMake(self.view.bounds.size.width - 50.0f, self.view.bounds.size.height);
            
            if (self.direction == REFrostedViewControllerDirectionTop || self.direction == REFrostedViewControllerDirectionBottom)
                self.calculatedMenuViewSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height - 50.0f);
        } else {
            self.calculatedMenuViewSize = CGSizeMake(_menuViewSize.width > 0 ? _menuViewSize.width : self.view.bounds.size.width,
                                                     _menuViewSize.height > 0 ? _menuViewSize.height : self.view.bounds.size.height);
        }
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    if (!self.visible) {
        self.calculatedMenuViewSize = CGSizeZero;
    }
}

@end

@implementation UIViewController (REFrostedViewController)

- (void)re_addController:(UIViewController *)controller frame:(CGRect)frame {
    [self addChildViewController:controller];
    controller.view.frame = frame;
    [self.view addSubview:controller.view];
    [controller didMoveToParentViewController:self];
}

- (void)re_removeController:(UIViewController *)controller {
    [controller willMoveToParentViewController:nil];
    [controller removeFromParentViewController];
    [controller.view removeFromSuperview];
}

- (REFrostedViewController *)frostedViewController {
    UIViewController *iter = self.parentViewController;
    while (iter) {
        if ([iter isKindOfClass:[REFrostedViewController class]]) {
            return (REFrostedViewController *)iter;
        } else if (iter.parentViewController && iter.parentViewController != iter) {
            iter = iter.parentViewController;
        } else {
            iter = nil;
        }
    }
    return nil;
}

@end
