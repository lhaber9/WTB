//
//  MainViewController.m
//  Walking The Border
//
//  Created by Lucas Haber on 11/14/14.
//  Copyright (c) 2014 IM2100. All rights reserved.
//  TESTING OUT CHANGES

#import "MainViewController.h"

typedef NS_ENUM(NSInteger, Direction) {
    RIGHT,
    LEFT,
};

static CGFloat PRESS_AND_HOLD_MINIMUM_DURATION = 0.1;
static CGFloat PRESS_AND_HOLD_DELAY = 0.1;
static CGFloat ANIMATION_DURATION = 0.2;

static CGFloat GROUND_SIZE_PX = 10000;

static CGFloat SKY_SPEED = 0;
static CGFloat MOUNTAINS_SPEED = 15;
static CGFloat FENCE_SPEED = 35;
static CGFloat GROUND_SPEED = 50;

static NSString* POSTION_LABEL_STRING = @" Pixels from Start";
static NSString* DISTANCE_LABEL_STRING = @" Pixels Traveled";

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

@property (nonatomic)NSInteger pixelPosition;
@property (nonatomic)NSInteger pixelsTraveled;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pixelPosition = 0;
    self.pixelsTraveled = 0;
    
    self.distanceTraveledLabel.alpha = 0;
    
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

- (NSInteger)position {
    return self.pixelPosition * -1;
}

- (NSString*)positionString{
    return [[NSString stringWithFormat:@"%li", (long)[self position]] stringByAppendingString:POSTION_LABEL_STRING];
    
}

- (NSString*)distanceTraveledString {
    return [[NSString stringWithFormat:@"%li", (long)self.pixelsTraveled] stringByAppendingString:DISTANCE_LABEL_STRING];
}

- (void)switchInfoLabel: (UITapGestureRecognizer *)recognizer  {
    
    if (self.distanceTraveledLabel.alpha == 0) {
        [UIView animateWithDuration:0.25 animations:^{
            self.positionLabel.alpha = 0;
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.distanceTraveledLabel.alpha = 1;
        }];
    }
    else {
        [UIView animateWithDuration:0.25 animations:^{
            self.distanceTraveledLabel.alpha = 0;
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.positionLabel.alpha = 1;
        }];
    }
    
}

- (NSInteger)moveTo:(NSInteger)position shouldCountToOdo:(BOOL)shouldCount {
    if ([self position] > position){
        return [self moveRightWithMultiplier:(([self position] - position) / GROUND_SPEED) shouldCountToOdo:shouldCount];
    }
    else if ([self position] < position) {
        return [self moveLeftWithMultiplier:((position - [self position]) / GROUND_SPEED) shouldCountToOdo:shouldCount];
    }
    return position;
}

- (void)moveWorld:(Direction)direction withMultiplier:(NSInteger)mult shouldCountToOdo:(BOOL)shouldCount {
    
    NSInteger signedMult = mult;
    if (direction == LEFT) {
        signedMult *= -1;
    }
    
    NSInteger newSkyPosition = self.backgroundSkyConstraint.constant + (SKY_SPEED * signedMult);
    NSInteger newMountainPosition = self.backgroundMountainConstraint.constant + (MOUNTAINS_SPEED * signedMult);
    NSInteger newFencePosition = self.backgroundFenceConstraint.constant + (FENCE_SPEED * signedMult);
    NSInteger newDirtPosition = self.backgroundDirtConstraint.constant + (GROUND_SPEED * signedMult);
    
    NSInteger newPixelPosition = newDirtPosition * -1;
    
    if (newPixelPosition < 0) {
        return;
    }

    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        self.backgroundSkyConstraint.constant   = newSkyPosition;
        self.backgroundMountainConstraint.constant   = newMountainPosition;
        self.backgroundFenceConstraint.constant = newFencePosition;
        self.backgroundDirtConstraint.constant  = newDirtPosition;
        [self.view layoutIfNeeded];
    }completion:^(BOOL finished) {
        self.pixelPosition += (GROUND_SPEED * signedMult);
        
        if (shouldCount) {
            self.pixelsTraveled += (GROUND_SPEED * mult);
        }
        
        self.positionLabel.text = [self positionString];
        self.distanceTraveledLabel.text = [self distanceTraveledString];
    }];
}

- (NSInteger)moveLeftWithMultiplier:(NSInteger)mult shouldCountToOdo:(BOOL)shouldCount {
    [self moveWorld:LEFT withMultiplier:mult shouldCountToOdo:shouldCount];
    return self.pixelPosition;
}

- (NSInteger)moveRightWithMultiplier:(NSInteger)mult shouldCountToOdo:(BOOL)shouldCount{
    [self moveWorld:RIGHT withMultiplier:mult shouldCountToOdo:shouldCount];
    return self.pixelPosition;
}

- (IBAction)leftTap:(id)sender {
    [self moveLeftWithMultiplier:1 shouldCountToOdo:YES];
}

- (IBAction)rightTap:(id)sender {
    [self moveRightWithMultiplier:1 shouldCountToOdo:YES];
}

- (void) rightTapHold: (UILongPressGestureRecognizer *) gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.pressAndHoldTimer = [NSTimer scheduledTimerWithTimeInterval:PRESS_AND_HOLD_DELAY target:self selector:@selector(rightTap:) userInfo:nil repeats:YES];
        
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
         self.pressAndHoldTimer = [NSTimer scheduledTimerWithTimeInterval:PRESS_AND_HOLD_DELAY target:self selector:@selector(leftTap:) userInfo:nil repeats:YES];
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
