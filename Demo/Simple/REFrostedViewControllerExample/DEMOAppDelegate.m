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
    AYSlideBarController *slideBarController = [[AYSlideBarController alloc] initWithContentViewController:navigationController menuViewController:menuController];
    slideBarController.position = AYSlideBarControllerPositionLeft;
    slideBarController.delegate = (id<AYSlideBarControllerDelegate>)self;
    
    // Make it a root controller
    //
    self.window.rootViewController = slideBarController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - AYSlideBarControllerDelegate
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
