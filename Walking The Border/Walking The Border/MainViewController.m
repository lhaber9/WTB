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

@property (strong, nonatomic)IBOutlet NSLayoutConstraint* backgroundConstraint;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)leftTap:(id)sender {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundConstraint.constant = self.backgroundConstraint.constant + 100;
        [self.view layoutIfNeeded];
    }];
    
    
    
}

- (IBAction)rightTap:(id)sender {
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundConstraint.constant = self.backgroundConstraint.constant - 100;
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
