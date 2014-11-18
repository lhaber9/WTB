//
//  MainViewController.m
//  Walking The Border
//
//  Created by Lucas Haber on 11/14/14.
//  Copyright (c) 2014 IM2100. All rights reserved.
//  TESTING OUT CHANGES

#import "MainViewController.h"

@interface MainViewController ()

@property (strong, nonatomic)IBOutlet UIButton* rightButton;
@property (strong, nonatomic)IBOutlet UIButton* leftButton;

@property (strong, nonatomic)IBOutlet NSLayoutConstraint* backgroundSkyConstraint;
@property (strong, nonatomic)IBOutlet NSLayoutConstraint* backgroundMountainConstraint;
@property (strong, nonatomic)IBOutlet NSLayoutConstraint* backgroundFenceConstraint;
@property (strong, nonatomic)IBOutlet NSLayoutConstraint* backgroundDirtConstraint;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILongPressGestureRecognizer* rightHold = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(rightTap:)];
    
    
    UILongPressGestureRecognizer* leftHold = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(leftTap:)];
    
    rightHold.minimumPressDuration = 0.1;
    leftHold.minimumPressDuration = 0.1;
    
    [self.rightButton addGestureRecognizer:rightHold];
    [self.leftButton addGestureRecognizer:leftHold];
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)leftTap:(id)sender {
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundMountainConstraint.constant   = self.backgroundMountainConstraint.constant + 25;
        self.backgroundFenceConstraint.constant = self.backgroundFenceConstraint.constant + 75;
        self.backgroundDirtConstraint.constant  = self.backgroundDirtConstraint.constant + 100;
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)rightTap:(id)sender {
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundMountainConstraint.constant   = self.backgroundMountainConstraint.constant - 25;
        self.backgroundFenceConstraint.constant = self.backgroundFenceConstraint.constant - 75;
        self.backgroundDirtConstraint.constant  = self.backgroundDirtConstraint.constant - 100;
        [self.view layoutIfNeeded];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
