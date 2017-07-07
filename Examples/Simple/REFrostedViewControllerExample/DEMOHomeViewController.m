//
//  DEMOHomeViewController.m
//  REFrostedViewControllerExample
//
//  Created by Roman Efimov on 9/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOHomeViewController.h"
#import "DEMONavigationController.h"
#import "DEMOSecondViewController.h"
#import "REFrostedViewController.h"

@interface DEMOHomeViewController ()

@end

@implementation DEMOHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"Home Controller";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:(DEMONavigationController *)self.navigationController
                                                                            action:@selector(showMenu)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"Balloon"];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"next" forState:UIControlStateNormal];
    [btn sizeToFit];
    btn.center = self.view.center;
    [btn addTarget:self action:@selector(nextBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
//    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];

}

- (void)nextBtnDidClick:(UIButton *)sender {
//    [self.navigationController pushViewController:[[DEMOSecondViewController alloc] init] animated:YES];
//    self.frostedViewController.menuViewController = [[DEMOSecondViewController alloc] init];
//    self.frostedViewController.contentViewController = [[DEMONavigationController alloc] initWithRootViewController:[[DEMOSecondViewController alloc] init]];
    
//    [self.frostedViewController setMenuViewSize:CGSizeMake(100, 200)];
//    self.frostedViewController.menuViewWidth = 100;
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController panGestureRecognized:sender];
}

@end
