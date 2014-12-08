//
//  ModalActionVC.h
//  Walking The Border
//
//  Created by Lucas Haber on 12/3/14.
//  Copyright (c) 2014 IM2100. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModalActionDelegate

- (void)didCloseWithoutCompletion;

- (void)didCompleteAction;

@end


@interface ModalActionVC : UIViewController


@property (weak, nonatomic)id<ModalActionDelegate> delegate;
@property (strong, nonatomic)NSString* uniqueDescription;
@property (strong, nonatomic)IBOutlet UITextView* textView;

@end
