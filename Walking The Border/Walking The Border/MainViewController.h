//
//  MainViewController.h
//  Walking The Border
//
//  Created by Lucas Haber on 11/14/14.
//  Copyright (c) 2014 IM2100. All rights reserved.
//

#import "InfiniteBackgroundElement.h"
#import "ModalActionVC.h"
#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <InfiniteBackgroundElementDelegate, ModalActionDelegate>

- (IBAction)leftTap:(id)sender;
- (IBAction)rightTap:(id)sender;

@end
