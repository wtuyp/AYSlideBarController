//
// REFrostedViewController.h
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

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, REFrostedViewControllerDirection) {
    REFrostedViewControllerDirectionLeft,
    REFrostedViewControllerDirectionRight,
    REFrostedViewControllerDirectionTop,
    REFrostedViewControllerDirectionBottom
};

@class REFrostedViewController;
@protocol REFrostedViewControllerDelegate <NSObject>

@optional
- (void)frostedViewController:(REFrostedViewController *)frostedViewController willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
- (void)frostedViewController:(REFrostedViewController *)frostedViewController didRecognizePanGesture:(UIPanGestureRecognizer *)recognizer;
- (void)frostedViewController:(REFrostedViewController *)frostedViewController willShowMenuViewController:(UIViewController *)menuViewController;
- (void)frostedViewController:(REFrostedViewController *)frostedViewController didShowMenuViewController:(UIViewController *)menuViewController;
- (void)frostedViewController:(REFrostedViewController *)frostedViewController willHideMenuViewController:(UIViewController *)menuViewController;
- (void)frostedViewController:(REFrostedViewController *)frostedViewController didHideMenuViewController:(UIViewController *)menuViewController;

@end

@interface REFrostedViewController : UIViewController

@property (readonly, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (assign, nonatomic) BOOL panGestureEnabled;
@property (assign, nonatomic) REFrostedViewControllerDirection direction;

@property (assign, nonatomic) CGFloat backgroundAlpha;          //default : black 0.3
@property (assign, nonatomic) NSTimeInterval animationDuration;
@property (assign, nonatomic) BOOL limitMenuViewSize;
@property (assign, nonatomic) CGFloat menuViewWidth;
@property (assign, nonatomic) CGSize menuViewSize;

@property (weak, nonatomic) id<REFrostedViewControllerDelegate> delegate;
@property (strong, nonatomic) UIViewController *contentViewController;
@property (strong, nonatomic) UIViewController *menuViewController;

- (instancetype)initWithContentViewController:(UIViewController *)contentViewController menuViewController:(UIViewController *)menuViewController;
- (void)presentMenuViewController;
- (void)hideMenuViewController;
- (void)resizeMenuViewControllerToSize:(CGSize)size;
- (void)hideMenuViewControllerWithCompletionHandler:(void(^)(void))completionHandler;
- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer;

@end

@interface UIViewController (REFrostedViewController)

@property (readonly, nonatomic) REFrostedViewController *frostedViewController;

- (void)re_displayController:(UIViewController *)controller frame:(CGRect)frame;
- (void)re_hideController:(UIViewController *)controller;

@end
