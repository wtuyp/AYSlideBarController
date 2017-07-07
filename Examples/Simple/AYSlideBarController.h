//
//  AYSlideBarController.h
//  REFrostedViewControllerExample
//
//  Created by alpha yu on 2017/7/7.
//  Copyright © 2017年 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AYSlideBarControllerPosition) {
    AYSlideBarControllerPositionLeft,
    AYSlideBarControllerPositionRight,
    AYSlideBarControllerPositionTop,
    AYSlideBarControllerPositionBottom
};

@class AYSlideBarController;
@protocol AYSlideBarControllerDelegate <NSObject>

@optional
- (void)slideBarController:(AYSlideBarController *)slideBarController willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
- (void)slideBarController:(AYSlideBarController *)slideBarController didRecognizePanGesture:(UIPanGestureRecognizer *)recognizer;
- (void)slideBarController:(AYSlideBarController *)slideBarController willShowMenuViewController:(UIViewController *)menuViewController;
- (void)slideBarController:(AYSlideBarController *)slideBarController didShowMenuViewController:(UIViewController *)menuViewController;
- (void)slideBarController:(AYSlideBarController *)slideBarController willHideMenuViewController:(UIViewController *)menuViewController;
- (void)slideBarController:(AYSlideBarController *)slideBarController didHideMenuViewController:(UIViewController *)menuViewController;

@end

@interface AYSlideBarController : UIViewController

@property (nonatomic, strong) UIViewController *contentViewController;
@property (nonatomic, strong) UIViewController *menuViewController;
@property (nonatomic, assign) AYSlideBarControllerPosition position;
@property (nonatomic, weak) id<AYSlideBarControllerDelegate> delegate;
@property (nonatomic, assign) BOOL isMenuViewVisible;

@property (nonatomic, assign) CGFloat menuViewWidth;
@property (nonatomic, assign) CGSize menuViewSize;

@property (nonatomic, readonly) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, assign) BOOL panGestureEnabled;

@property (nonatomic, strong) UIColor *backgroundColor;         //default : black
@property (nonatomic, assign) CGFloat backgroundAlpha;          //default :  0.3
@property (nonatomic, assign) NSTimeInterval animationDuration;

- (instancetype)initWithContentViewController:(UIViewController *)contentViewController
                           menuViewController:(UIViewController *)menuViewController;
- (void)showMenuViewController;
- (void)hideMenuViewController;
- (void)hideMenuViewControllerWithCompletionHandler:(void(^)(void))completionHandler;

@end

@interface UIViewController (AYSlideBarController)

@property (nonatomic, readonly) AYSlideBarController *slideBarController;

- (void)ay_addController:(UIViewController *)controller frame:(CGRect)frame;
- (void)ay_removeController:(UIViewController *)controller;

@end
