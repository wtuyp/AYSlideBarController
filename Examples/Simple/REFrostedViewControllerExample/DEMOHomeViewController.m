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
    
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 100)];
    view.contentSize = CGSizeMake(self.view.bounds.size.width * 20, view.bounds.size.height);
    view.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    view.bounces = NO;
    [self.view addSubview:view];

}

- (void)nextBtnDidClick:(UIButton *)sender {
//    [self.navigationController pushViewController:[[DEMOSecondViewController alloc] init] animated:YES];
    self.slideBarController.menuViewSize = CGSizeMake(100, 200);
}

@end
