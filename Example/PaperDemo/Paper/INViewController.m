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
#import <PureLayout/PureLayout.h>

@interface INViewController ()

@property (strong, nonatomic) PaperToolbar *toolbar;
@property (assign, nonatomic) BOOL expanded;
@property (strong, nonatomic) PaperTextField *emailLabel;
@property (strong, nonatomic) PaperTextField *passwordLabel;
@property (strong, nonatomic) PaperTextField *disabledLabel;
@property (strong, nonatomic) PaperTextField *numericLabel;

@end

@implementation INViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.emailLabel = [[PaperTextField alloc] initWithFrame:CGRectMake(8, 64, CGRectGetWidth(self.view.bounds) - 16, 48)];
    self.emailLabel.floatingLabel = YES;
    self.emailLabel.placeholder = @"Email";
    self.emailLabel.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailLabel.validationBlock = PaperTextFieldEmailValidator;
    [self.view addSubview:self.emailLabel];
    
    self.passwordLabel = [[PaperTextField alloc] initWithFrame:CGRectMake(8, 128, CGRectGetWidth(self.view.bounds) - 16, 48)];
    self.passwordLabel.floatingLabel = YES;
    self.passwordLabel.secureTextEntry = YES;
    [self.passwordLabel setPlaceholder:@"Password"];
    [self.view addSubview:self.passwordLabel];

    self.disabledLabel = [[PaperTextField alloc] initWithFrame:CGRectMake(8, 192, CGRectGetWidth(self.view.bounds) - 16, 48)];
    self.disabledLabel.enabled = NO;
    [self.disabledLabel setPlaceholder:@"I'm disabled!"];
    [self.view addSubview:self.disabledLabel];

    self.numericLabel = [[PaperTextField alloc] initWithFrame:CGRectZero];
    self.numericLabel.floatingLabel = NO;
    self.numericLabel.placeholder = @"Type only numbers...";
    self.numericLabel.validationBlock = PaperTextFieldNumberValidator;
    self.numericLabel.keyboardType = UIKeyboardTypeDecimalPad;
    [self.view addSubview:self.numericLabel];
    
	// Do any additional setup after loading the view, typically from a nib.
 
    /*
    self.toolbar = [PaperToolbar toolbarWithStyle:PaperToolbarStyleFlexible parentView:self.view];
    [self.toolbar setBackgroundColor:[UIColor primaryColorForGroup:@"blue" alpha:1.0f]];
    [self.view addSubview:self.toolbar];
    
    [self.toolbar setBackgroundImage:[UIImage imageNamed:@"demo.jpg"] forState:PaperToolbarStateNormal];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self.view addGestureRecognizer:tapGesture];
     */
    
    // auto layout constrains
//    [self.emailLabel autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
    [self.emailLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:8.f];
    [self.emailLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-8.f];
    [self.emailLabel autoPinToTopLayoutGuideOfViewController:self withInset:16.0f];
    [self.emailLabel autoSetDimension:ALDimensionHeight toSize:44.f];
    
    [self.passwordLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:8.f];
    [self.passwordLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-8.f];
    [self.passwordLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.emailLabel withOffset:16.f];
    [self.passwordLabel autoSetDimension:ALDimensionHeight toSize:44.f];

    [self.disabledLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:8.f];
    [self.disabledLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-8.f];
    [self.disabledLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.passwordLabel withOffset:16.f];
    [self.disabledLabel autoSetDimension:ALDimensionHeight toSize:44.f];

    [self.numericLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:8.f];
    [self.numericLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-8.f];
    [self.numericLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.disabledLabel withOffset:16.f];
    [self.numericLabel autoSetDimension:ALDimensionHeight toSize:44.f];
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
