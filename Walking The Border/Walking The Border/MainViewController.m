//
//  MainViewController.m
//  Walking The Border
//
//  Created by Lucas Haber on 11/14/14.
//  Copyright (c) 2014 IM2100. All rights reserved.
//  TESTING OUT CHANGES

#import "MainViewController.h"
#import "InfiniteBackgroundElement.h"
#import "QuartzCore/QuartzCore.h"
#import "ALView+PureLayout.h"

typedef NS_ENUM(NSInteger, Direction) {
    RIGHT,
    LEFT,
};

static CGFloat PRESS_AND_HOLD_MINIMUM_DURATION = 0.1;
static CGFloat PRESS_AND_HOLD_DELAY = 0.1;
static CGFloat ANIMATION_DURATION = 0.2;

static CGFloat SKY_SPEED = 0;
static CGFloat MOUNTAINS_SPEED = 15;
static CGFloat FENCE_SPEED = 25;
static CGFloat GROUND_SPEED = 50;

static NSString* POSTION_LABEL_STRING = @" Pixels from Start";
static NSString* DISTANCE_LABEL_STRING = @" Pixels Traveled";

static CGFloat BUTTON_RED = 232;
static CGFloat BUTTON_GREEN = 100;
static CGFloat BUTTON_BLUE = 73;

@interface MainViewController ()

@property (nonatomic)Direction currentDirection;

@property (strong, nonatomic)IBOutlet UIView* backgroundContainer;
@property (strong, nonatomic)IBOutlet UIView* foregroundContainer;
@property (strong, nonatomic)IBOutlet UIView* controlbarContainer;

@property (strong, nonatomic)IBOutlet UIImageView* lukeImageView;
@property (strong, nonatomic)UIImage* lukeImage;
@property (strong, nonatomic)UIImage* flippedLuke;

@property (strong, nonatomic)IBOutlet UIButton* rightButton;
@property (strong, nonatomic)IBOutlet UIButton* leftButton;

@property (strong, nonatomic)IBOutlet UILabel* positionLabel;
@property (strong, nonatomic)IBOutlet UILabel* distanceTraveledLabel;

@property (strong, nonatomic)IBOutlet NSLayoutConstraint* backgroundSkyConstraint;
@property (strong, nonatomic)IBOutlet NSLayoutConstraint* backgroundMountainConstraint;
@property (strong, nonatomic)IBOutlet NSLayoutConstraint* backgroundFenceConstraint;
@property (strong, nonatomic)IBOutlet NSLayoutConstraint* backgroundDirtConstraint;

@property (strong, nonatomic)InfiniteBackgroundElement* skyBackground;
@property (strong, nonatomic)InfiniteBackgroundElement* mountainsBackground;
@property (strong, nonatomic)InfiniteBackgroundElement* fenceBackground;
@property (strong, nonatomic)InfiniteBackgroundElement* dirtBackground;

@property (strong, nonatomic)NSTimer* pressAndHoldTimer;

@property (nonatomic)NSInteger pixelsTraveled;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lukeImage   = self.lukeImageView.image;
    self.flippedLuke = [UIImage imageWithCGImage:self.lukeImageView.image.CGImage
                                           scale:self.lukeImageView.image.scale
                                     orientation:UIImageOrientationUpMirrored];
    
    self.pixelsTraveled = 0;
    
    self.distanceTraveledLabel.alpha = 0;
    
    self.skyBackground = [[InfiniteBackgroundElement alloc] initWithPng:@"sky.png"];
    self.skyBackground.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.skyBackground.speed = SKY_SPEED;
    self.skyBackground.animationDuration = ANIMATION_DURATION;
    [self addChildViewController:self.skyBackground];
    [self.backgroundContainer addSubview:self.skyBackground.view];
    [self.skyBackground.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    self.mountainsBackground = [[InfiniteBackgroundElement alloc] initWithPng:@"mountain.png"];
    self.mountainsBackground.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.mountainsBackground.speed = MOUNTAINS_SPEED;
    self.mountainsBackground.animationDuration = ANIMATION_DURATION;
    [self addChildViewController:self.mountainsBackground];
    [self.backgroundContainer addSubview:self.mountainsBackground.view];
    [self.mountainsBackground.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    self.fenceBackground = [[InfiniteBackgroundElement alloc] initWithPng:@"smallfence.png"];
    self.fenceBackground.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.fenceBackground.speed = FENCE_SPEED;
    self.fenceBackground.animationDuration = ANIMATION_DURATION;
    [self addChildViewController:self.fenceBackground];
    [self.backgroundContainer addSubview:self.fenceBackground.view];
    [self.fenceBackground.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    self.dirtBackground = [[InfiniteBackgroundElement alloc] initWithPng:@"dirt.png"];
    self.dirtBackground.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.dirtBackground.speed = GROUND_SPEED;
    self.dirtBackground.animationDuration = ANIMATION_DURATION;
    [self addChildViewController:self.dirtBackground];
    [self.backgroundContainer addSubview:self.dirtBackground.view];
    [self.dirtBackground.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
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
    
    [self.rightButton setBackgroundColor:[UIColor colorWithRed:BUTTON_RED/255 green:BUTTON_GREEN/255 blue:BUTTON_BLUE/255 alpha:1]];
    [self.leftButton setBackgroundColor:[UIColor colorWithRed:BUTTON_RED/255 green:BUTTON_GREEN/255 blue:BUTTON_BLUE/255 alpha:1]];
    
    self.rightButton.layer.cornerRadius = self.rightButton.bounds.size.width/2.0;
    self.rightButton.layer.borderWidth = 0;
    
    self.leftButton.layer.cornerRadius = self.leftButton.bounds.size.width/2.0;
    self.leftButton.layer.borderWidth = 0;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)position {
    return self.dirtBackground.position;
}

- (NSString*)positionString{
    return [[NSString stringWithFormat:@"%li", (long)[self position]] stringByAppendingString:POSTION_LABEL_STRING];
    
}

- (NSString*)distanceTraveledString {
    return [[NSString stringWithFormat:@"%li", (long)self.pixelsTraveled] stringByAppendingString:DISTANCE_LABEL_STRING];
}

- (void)flipLuke:(Direction)direction {
    if (direction == LEFT) {
        self.lukeImageView.image = self.flippedLuke;
    }
    else {
        self.lukeImageView.image = self.lukeImage;
    }
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

- (NSInteger)moveTo:(NSInteger)position
   shouldCountToOdo:(BOOL)shouldCount
shouldChangeOrientation:(BOOL)shouldChange {
    if ([self position] > position){
        return [self moveRightWithMultiplier:(([self position] - position) / GROUND_SPEED) shouldCountToOdo:shouldCount shouldChangeOrientation:shouldChange];
    }
    else if ([self position] < position) {
        return [self moveLeftWithMultiplier:((position - [self position]) / GROUND_SPEED) shouldCountToOdo:shouldCount shouldChangeOrientation:shouldChange];
    }
    return position;
}

- (void)moveWorld:(Direction)direction
 shouldCountToOdo:(BOOL)shouldCount
shouldChangeOrientation:(BOOL)shouldChange {
    
    NSInteger oldPostion = [self position];
    
    if (direction != self.currentDirection) {
        self.currentDirection = direction;
        [self flipLuke:direction];
    }
    
    if (direction == LEFT) {
       
        [self.skyBackground moveLeft];
        [self.mountainsBackground moveLeft];
        [self.fenceBackground moveLeft];
        [self.dirtBackground moveLeft];
        
    }
    else if (direction == RIGHT) {
        [self.skyBackground moveRight];
        [self.mountainsBackground moveRight];
        [self.fenceBackground moveRight];
        [self.dirtBackground moveRight];
        
    }
    
    if (shouldCount) {
        NSInteger change = [self position] - oldPostion;
        self.pixelsTraveled += fabs(change);
    }

    self.positionLabel.text = [self positionString];
    self.distanceTraveledLabel.text = [self distanceTraveledString];
}

- (NSInteger)moveLeftWithMultiplier:(NSInteger)mult
                   shouldCountToOdo:(BOOL)shouldCount
            shouldChangeOrientation:(BOOL)shouldChange {
    [self moveWorld:LEFT shouldCountToOdo:shouldCount shouldChangeOrientation:shouldChange];
    return [self position];
}

- (NSInteger)moveRightWithMultiplier:(NSInteger)mult
                    shouldCountToOdo:(BOOL)shouldCount
             shouldChangeOrientation:(BOOL)shouldChange {
    [self moveWorld:RIGHT shouldCountToOdo:shouldCount shouldChangeOrientation:shouldChange];
    return [self position];
}

- (IBAction)leftTap:(id)sender {
    [self moveLeftWithMultiplier:1 shouldCountToOdo:YES shouldChangeOrientation:YES];
}

- (IBAction)rightTap:(id)sender {
    [self moveRightWithMultiplier:1 shouldCountToOdo:YES shouldChangeOrientation:YES];
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
