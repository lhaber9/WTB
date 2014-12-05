//
//  ModalActionVC.m
//  Walking The Border
//
//  Created by Lucas Haber on 12/3/14.
//  Copyright (c) 2014 IM2100. All rights reserved.
//

#import "ModalActionVC.h"
#import "ALView+PureLayout.h"

@interface ModalActionVC ()



@property (strong, nonatomic)IBOutlet UIView* mainView;
@property (strong, nonatomic)IBOutlet UIButton* closeButton;
@property (strong, nonatomic)IBOutlet UILabel* titleLabel;

@property (strong, nonatomic)IBOutlet UITextView* textView;

@end

@implementation ModalActionVC

- (void)viewDidLoad {
    [super viewDidLoad];

    
    // BIG if to do all the work ;)))
    
    if ([self.uniqueDescription isEqualToString:@"firstElement"]) {
        
        self.titleLabel.text = @"First Element";
        UILabel* label = [[UILabel alloc] initForAutoLayout];
        label.text = @"First Element!";
        label.textAlignment = NSTextAlignmentCenter;
        
        [self.mainView addSubview:label];
        [label autoCenterInSuperview];
    }
    else if ([self.uniqueDescription isEqualToString:@"friendshipCircle"]) {
        
        self.titleLabel.text = @"Friendship Circle";
        self.textView.hidden = NO;
        self.textView.text = @"The official name of this place is the \"Friendship Circle.\"\n\nA big marble obelisk stands in the center of the circle. There is a break in the southern fence to accommodate the obelisk, and some additional fencing around the break to keep anyone from trying to squeeze through.\n\nThe buffer zone between the two fences is reserved exclusively for the use of the U. S. Border Patrol, with one exception: At the top of the hill, there is a little door in the northern fence, and a sign informs that twice a week, Saturdays and Sundays from 10:00 A.M. until 2:00 P.M., U. S. citizens are allowed to enter. Then, if there happen to be Mexicans on the other side of the second, southern fence, the Americans are allowed to look at them and talk with them, though reaching through the fence or attempting \"physical contact with individuals in Mexico\" is prohibited. A portion of the American side of the visiting area has been paved with cement, in the shape of a semicircle, and there is an identical semicircle on the Mexican side of the fence.";
        
        [self.textView setContentOffset:CGPointZero
                               animated:YES];
    }
    else if ([self.uniqueDescription isEqualToString:@"fordTruck"]) {
        
        self.titleLabel.text = @"Ford Truck";
        
        
        
    }
    else if ([self.uniqueDescription isEqualToString:@"borderGuard"]) {
        self.titleLabel.text = @"Border Guard";
    }
    
    
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {
    [self.delegate didRequestClose];
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
