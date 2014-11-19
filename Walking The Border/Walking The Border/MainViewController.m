//
//  MainViewController.m
//  Walking The Border
//
//  Created by Lucas Haber on 11/14/14.
//  Copyright (c) 2014 IM2100. All rights reserved.
//  TESTING OUT CHANGES

#import "MainViewController.h"

static CGFloat PRESS_AND_HOLD_MINIMUM_DURATION = 0.1;
static CGFloat PRESS_AND_HOLD_DELAY = 0.08;
static CGFloat ANIMATION_DURATION = 0.2;


static CGFloat SKY_SPEED = 0;
static CGFloat MOUNTAINS_SPEED = 25;
static CGFloat FENCE_SPEED = 75;
static CGFloat GROUND_SPEED = 100;

static NSString* POSTION_LABEL_STRING = @" pixels from start";
static NSString* DISTANCE_LABEL_STRING = @" pixels traveled";

@interface MainViewController ()

@property (strong, nonatomic)IBOutlet UIButton* rightButton;
@property (strong, nonatomic)IBOutlet UIButton* leftButton;

@property (strong, nonatomic)IBOutlet UILabel* positionLabel;
@property (strong, nonatomic)IBOutlet UILabel* distanceTraveledLabel;

@property (strong, nonatomic)IBOutlet NSLayoutConstraint* backgroundSkyConstraint;
@property (strong, nonatomic)IBOutlet NSLayoutConstraint* backgroundMountainConstraint;
@property (strong, nonatomic)IBOutlet NSLayoutConstraint* backgroundFenceConstraint;
@property (strong, nonatomic)IBOutlet NSLayoutConstraint* backgroundDirtConstraint;

@property (strong, nonatomic)NSTimer* pressAndHoldTimer;

@property (nonatomic)int pixelPosition;
@property (nonatomic)int pixelsTraveled;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pixelPosition = 0;
    self.pixelsTraveled = 0;
    
    UILongPressGestureRecognizer* rightHold = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(rightTapHold:)];
    UILongPressGestureRecognizer* leftHold = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(leftTapHold:)];
    
    
    self.positionLabel.text = [@"0" stringByAppendingString:POSTION_LABEL_STRING];
    self.distanceTraveledLabel.text = [@"0" stringByAppendingString:DISTANCE_LABEL_STRING];
    
    self.positionLabel.userInteractionEnabled = YES;
    
    [self.positionLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchInfoLabel:)]];
    [self.distanceTraveledLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchInfoLabel:)]];
    
    rightHold.minimumPressDuration = PRESS_AND_HOLD_MINIMUM_DURATION;
    leftHold.minimumPressDuration = PRESS_AND_HOLD_MINIMUM_DURATION;
    
    [self.rightButton addGestureRecognizer:rightHold];
    [self.leftButton addGestureRecognizer:leftHold];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int)position {
    return self.pixelPosition * -1;
}

- (NSString*)positionString{
    return [[NSString stringWithFormat:@"%i", [self position]] stringByAppendingString:POSTION_LABEL_STRING];
    
}

- (NSString*)distanceTraveledString {
    return [[NSString stringWithFormat:@"%i", self.pixelsTraveled] stringByAppendingString:DISTANCE_LABEL_STRING];
}

- (void)switchInfoLabel: (UITapGestureRecognizer *)recognizer  {
    
    if (self.distanceTraveledLabel.hidden) {
        [UIView animateWithDuration:0.25 animations:^{
            self.distanceTraveledLabel.hidden = NO;
            self.positionLabel.hidden = YES;
            [self.view layoutIfNeeded];
        }];
    }
    else {
        [UIView animateWithDuration:0.25 animations:^{
            self.distanceTraveledLabel.hidden = YES;
            self.positionLabel.hidden = NO;
            [self.view layoutIfNeeded];
        }];
    }
    
}

- (CGFloat)moveLeft:(id)sender {
    self.backgroundSkyConstraint.constant   = self.backgroundSkyConstraint.constant - SKY_SPEED;
    self.backgroundMountainConstraint.constant   = self.backgroundMountainConstraint.constant - MOUNTAINS_SPEED;
    self.backgroundFenceConstraint.constant = self.backgroundFenceConstraint.constant - FENCE_SPEED;
    self.backgroundDirtConstraint.constant  = self.backgroundDirtConstraint.constant - GROUND_SPEED;
    
    self.pixelPosition -= GROUND_SPEED;
    self.pixelsTraveled += GROUND_SPEED;
    
    self.positionLabel.text = [self positionString];
    self.distanceTraveledLabel.text = [self distanceTraveledString];
    
    return self.pixelPosition;
}

- (CGFloat)moveRight:(id)sender {
    if ([self position] <= 0) {
        return 0;
    }
    
    self.backgroundSkyConstraint.constant   = self.backgroundSkyConstraint.constant + SKY_SPEED;
    self.backgroundMountainConstraint.constant   = self.backgroundMountainConstraint.constant + MOUNTAINS_SPEED;
    self.backgroundFenceConstraint.constant = self.backgroundFenceConstraint.constant + FENCE_SPEED;
    self.backgroundDirtConstraint.constant  = self.backgroundDirtConstraint.constant + GROUND_SPEED;
    
    self.pixelPosition += GROUND_SPEED;
    self.pixelsTraveled += GROUND_SPEED;
    
    self.positionLabel.text = [self positionString];
    self.distanceTraveledLabel.text = [self distanceTraveledString];
    
    return self.pixelPosition;
}

- (IBAction)leftTap:(id)sender {
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        [self moveLeft:sender];
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)rightTap:(id)sender {
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        [self moveRight:sender];
        [self.view layoutIfNeeded];
    }];
}

- (void) rightTapHold: (UILongPressGestureRecognizer *) gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.pressAndHoldTimer = [NSTimer scheduledTimerWithTimeInterval:PRESS_AND_HOLD_DELAY target:self selector:@selector(moveRight:) userInfo:nil repeats:YES];
        
    }
    else if (gesture.state == UIGestureRecognizerStateEnded){
        if (self.pressAndHoldTimer != nil) {
            [self.pressAndHoldTimer invalidate];
            self.pressAndHoldTimer = nil;
        }
    }
}

- (void) leftTapHold: (UILongPressGestureRecognizer *) gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
         self.pressAndHoldTimer = [NSTimer scheduledTimerWithTimeInterval:PRESS_AND_HOLD_DELAY target:self selector:@selector(moveLeft:) userInfo:nil repeats:YES];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded){
        if (self.pressAndHoldTimer != nil) {
            [self.pressAndHoldTimer invalidate];
            self.pressAndHoldTimer = nil;
        }
    }
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
