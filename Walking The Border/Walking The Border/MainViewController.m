//
//  MainViewController.m
//  Walking The Border
//
//  Created by Lucas Haber on 11/14/14.
//  Copyright (c) 2014 IM2100. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property (strong, nonatomic)IBOutlet UIView* rightButton;
@property (strong, nonatomic)IBOutlet UIView* leftButton;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer* rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightTap:)];
    UITapGestureRecognizer* leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftTap:)];
    
    [self.rightButton addGestureRecognizer:rightTap];
    [self.leftButton addGestureRecognizer:leftTap];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)leftTap:(id)sender {
    
    
    
    
}

- (IBAction)rightTap:(id)sender {
    
    
    
    
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
