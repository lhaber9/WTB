//
//  ModalActionVC.h
//  Walking The Border
//
//  Created by Lucas Haber on 12/3/14.
//  Copyright (c) 2014 IM2100. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModalActionDelegate

- (void)didRequestClose;

@end


@interface ModalActionVC : UIViewController

@property (weak, nonatomic)id<ModalActionDelegate> delegate;

@property (strong, nonatomic)NSString* uniqueDescription;
@end
