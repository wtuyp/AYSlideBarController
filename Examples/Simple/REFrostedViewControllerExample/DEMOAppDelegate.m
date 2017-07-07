//
//  DEMOAppDelegate.m
//  REFrostedViewControllerExample
//
//  Created by Roman Efimov on 9/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOAppDelegate.h"
#import "DEMONavigationController.h"
#import "DEMOHomeViewController.h"
#import "DEMOMenuViewController.h"
#import "AYSlideBarController.h"

@implementation DEMOAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Create content and menu controllers
    //
    DEMONavigationController *navigationController = [[DEMONavigationController alloc] initWithRootViewController:[[DEMOHomeViewController alloc] init]];
    
    DEMOMenuViewController *menuController = [[DEMOMenuViewController alloc] initWithStyle:UITableViewStylePlain];
    
    // Create frosted view controller
    //
//    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
//    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
//    frostedViewController.delegate = self;
    
    AYSlideBarController *frostedViewController = [[AYSlideBarController alloc] initWithContentViewController:navigationController menuViewController:menuController];
    frostedViewController.position = AYSlideBarControllerPositionLeft;
    frostedViewController.delegate = (id<AYSlideBarControllerDelegate>)self;
    
    // Make it a root controller
    //
    self.window.rootViewController = frostedViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController didRecognizePanGesture:(UIPanGestureRecognizer *)recognizer
{
    NSLog(@"didRecognizePanGesture");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController willShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willShowMenuViewController");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController didShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didShowMenuViewController");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController willHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willHideMenuViewController");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController didHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didHideMenuViewController");
}

- (void)slideBarController:(AYSlideBarController *)slideBarController didRecognizePanGesture:(UIPanGestureRecognizer *)recognizer {
    NSLog(@"didRecognizePanGesture");
}
- (void)slideBarController:(AYSlideBarController *)slideBarController willShowMenuViewController:(UIViewController *)menuViewController {
    NSLog(@"willShowMenuViewController");
}
- (void)slideBarController:(AYSlideBarController *)slideBarController didShowMenuViewController:(UIViewController *)menuViewController {
    NSLog(@"didShowMenuViewController");
}
- (void)slideBarController:(AYSlideBarController *)slideBarController willHideMenuViewController:(UIViewController *)menuViewController {
    NSLog(@"willHideMenuViewController");
}
- (void)slideBarController:(AYSlideBarController *)slideBarController didHideMenuViewController:(UIViewController *)menuViewController {
    NSLog(@"didHideMenuViewController");
}
@end
