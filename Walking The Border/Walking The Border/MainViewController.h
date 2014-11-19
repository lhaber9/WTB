//
//  MainViewController.h
//  Walking The Border
//
//  Created by Lucas Haber on 11/14/14.
//  Copyright (c) 2014 IM2100. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

- (NSInteger)moveLeftWithMultiplier:(NSInteger)mult shouldCountToOdo:(BOOL)shouldCount;
- (NSInteger)moveRightWithMultiplier:(NSInteger)mult shouldCountToOdo:(BOOL)shouldCount;

- (IBAction)leftTap:(id)sender;
- (IBAction)rightTap:(id)sender;

@end
