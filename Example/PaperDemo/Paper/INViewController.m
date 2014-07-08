//
//  INViewController.m
//  Paper
//
//  Created by Tom Li on 07/07/2014.
//  Copyright (c) 2014 Tom Li. All rights reserved.
//

#import "INViewController.h"
#import <Paper/Paper.h>
#import <UIKit+Material/UIColor+Material.h>

@interface INViewController ()

@property (strong, nonatomic) PaperToolbar *toolbar;
@property (assign, nonatomic) BOOL expanded;
@property (strong, nonatomic) PaperTextField *emailLabel;
@property (strong, nonatomic) PaperTextField *passwordLabel;
@property (strong, nonatomic) PaperTextField *disabledLabel;

@end

@implementation INViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.emailLabel = [[PaperTextField alloc] initWithFrame:CGRectMake(8, 64, CGRectGetWidth(self.view.bounds) - 16, 48)];
    self.emailLabel.floatingLabel = YES;
    [self.emailLabel setPlaceholder:@"Email"];
    [self.view addSubview:self.emailLabel];
    
    self.passwordLabel = [[PaperTextField alloc] initWithFrame:CGRectMake(8, 128, CGRectGetWidth(self.view.bounds) - 16, 48)];
    self.passwordLabel.floatingLabel = YES;
    [self.passwordLabel setPlaceholder:@"Password"];
    [self.view addSubview:self.passwordLabel];

    self.disabledLabel = [[PaperTextField alloc] initWithFrame:CGRectMake(8, 192, CGRectGetWidth(self.view.bounds) - 16, 48)];
    self.disabledLabel.floatingLabel = YES;
    self.disabledLabel.enabled = NO;
    [self.disabledLabel setPlaceholder:@"I'm disabled!"];
    [self.view addSubview:self.disabledLabel];

	// Do any additional setup after loading the view, typically from a nib.
 
    /*
    self.toolbar = [PaperToolbar toolbarWithStyle:PaperToolbarStyleFlexible parentView:self.view];
    [self.toolbar setBackgroundColor:[UIColor primaryColorForGroup:@"blue" alpha:1.0f]];
    [self.view addSubview:self.toolbar];
    
    [self.toolbar setBackgroundImage:[UIImage imageNamed:@"demo.jpg"] forState:PaperToolbarStateNormal];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self.view addGestureRecognizer:tapGesture];
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (void)onTap:(UIGestureRecognizer *)gesture
{
    if (!self.expanded) {
        [self.toolbar setHeight:240.f animated:YES];
        self.expanded = YES;
    } else {
        [self.toolbar setHeight:[PaperToolbar defaultToolbarHeight] animated:YES];
        self.expanded = NO;
    }
}
 */

@end
