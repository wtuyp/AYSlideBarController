//
//  DEMOSecondViewController.m
//  REFrostedViewControllerExample
//
//  Created by Roman Efimov on 9/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOSecondViewController.h"
#import "DEMOMenuViewController.h"
#import "DEMONavigationController.h"

@interface DEMOSecondViewController ()

@end

@implementation DEMOSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"Second Controller";
    self.view.backgroundColor = [UIColor orangeColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:(DEMONavigationController *)self.navigationController
                                                                            action:@selector(showMenu)];
    
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    label.text = @"Second Controller";
    [label sizeToFit];
    [self.view addSubview:label];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"reset menu" forState:UIControlStateNormal];
    [btn sizeToFit];
    btn.center = self.view.center;
    [btn addTarget:self action:@selector(nextBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)nextBtnDidClick:(UIButton *)sender {
    self.slideBarController.menuViewController = [[DEMOMenuViewController alloc] init];
}

@end
