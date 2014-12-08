//
//  MainViewController.m
//  Walking The Border
//
//  Created by Lucas Haber on 11/14/14.
//  Copyright (c) 2014 IM2100. All rights reserved.
//  TESTING OUT CHANGES

#import "MainViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "ALView+PureLayout.h"

typedef NS_ENUM(NSInteger, Direction) {
    RIGHT,
    LEFT,
};

static CGFloat RIGHT_LIMIT = -200;

//static CGFloat MOVE_FOR_HOUR = 1440000;// length of moving for an hour
static CGFloat TOTAL_DISTANCE = 15000;

static CGFloat PRESS_AND_HOLD_MINIMUM_DURATION = 0.1;
static CGFloat PRESS_AND_HOLD_DELAY = 0.125;
static CGFloat ANIMATION_DURATION = 0.2;

static CGFloat SKY_SPEED = 0;
static CGFloat CLOUDS_SPEED = 5;
static CGFloat MOUNTAINS_SPEED = 15;
static CGFloat FENCE_SPEED_BACK = 25;
static CGFloat FENCE_SPEED_FRONT = 35;
static CGFloat GROUND_SPEED = 50;

static CGFloat BUTTON_RED = 232;
static CGFloat BUTTON_GREEN = 100;
static CGFloat BUTTON_BLUE = 73;

static CGFloat CONTROLBAR_RED = 233;
static CGFloat CONTROLBAR_GREEN = 180;
static CGFloat CONTROLBAR_BLUE = 83;

static CGFloat POSITIONBAR_LENGTH = 525;

static unsigned int RANDOM_MAX = 100;

@interface MainViewController ()

@property (nonatomic)Direction currentDirection;

@property (strong, nonatomic)NSNumber* elcamino_position;

@property (strong, nonatomic)NSMutableArray* foregroundElements;
@property (strong, nonatomic)NSMutableArray* addedElements;

@property (strong, nonatomic)IBOutlet UIView*    backgroundContainer;
@property (strong, nonatomic)IBOutlet UIView*    controlbarContainer;

@property (strong, nonatomic)IBOutlet UIView*    positionStatusLine;
@property (strong, nonatomic)NSLayoutConstraint* positionStatusConstraint;
@property (strong, nonatomic)IBOutlet UILabel*    overEndIndicator;

@property (strong, nonatomic)IBOutlet UIImageView* lukeImageView;
@property (strong, nonatomic)IBOutlet UIImageView* positionIdicatorImageView;
@property (strong, nonatomic)UIImage* positionIdicatorImage;
@property (strong, nonatomic)UIImage* foregroundPositionIndicatorImage;
@property (strong, nonatomic)UIImage* lukeImage;
@property (strong, nonatomic)UIImage* flippedLuke;

@property (strong, nonatomic)IBOutlet UIButton* rightButton;
@property (strong, nonatomic)IBOutlet UIButton* leftButton;

@property (strong, nonatomic)IBOutlet UILabel* positionLabel;
@property (strong, nonatomic)IBOutlet UILabel* distanceTraveledLabel;

@property (strong, nonatomic)NSArray* infiniteBackgrounds;
@property (strong, nonatomic)InfiniteBackgroundElement* skyBackground;
@property (strong, nonatomic)InfiniteBackgroundElement* cloudsBackground;
@property (strong, nonatomic)InfiniteBackgroundElement* mountainsBackground;
@property (strong, nonatomic)InfiniteBackgroundElement* fenceBackground;
@property (strong, nonatomic)InfiniteBackgroundElement* dirtBackground;

@property (strong, nonatomic)NSTimer* pressAndHoldTimer;

@property (strong, nonatomic)NSTimer* TruckLeftTimer;
@property (strong, nonatomic)NSTimer* TruckRightTimer;
@property (strong, nonatomic)NSTimer* GuardLeftTimer;
@property (strong, nonatomic)NSTimer* GuardRightTimer;

@property (nonatomic)BOOL inElCamino;

@property (nonatomic)NSInteger pixelsTraveled;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.inElCamino = NO;
    self.elcamino_position = [NSNumber numberWithFloat:TOTAL_DISTANCE * 0.55];
    
    [self initBackgrounds];
    [self initForegrounds];
    [self initButtons];
    [self initIndicators];
    
    UIView* underview = [[UIView alloc] initForAutoLayout];
    underview.backgroundColor = [UIColor clearColor];
    [self.backgroundContainer addSubview:underview];
    [underview addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMountains:)]];
    
    [underview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:50];
    [underview autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [underview autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [underview autoSetDimension:ALDimensionHeight toSize:125];
    
    
    
    dispatch_after(0, dispatch_get_main_queue(), ^{
        self.TruckLeftTimer = [NSTimer scheduledTimerWithTimeInterval:arc4random() % RANDOM_MAX target:self selector:@selector(moveTruckLeft:) userInfo:nil repeats:YES];
        self.TruckRightTimer = [NSTimer scheduledTimerWithTimeInterval:arc4random() % RANDOM_MAX target:self selector:@selector(moveTruckRight:) userInfo:nil repeats:YES];
        self.GuardLeftTimer = [NSTimer scheduledTimerWithTimeInterval:arc4random() % RANDOM_MAX target:self selector:@selector(moveGuardLeft:) userInfo:nil repeats:YES];
        self.GuardRightTimer = [NSTimer scheduledTimerWithTimeInterval:arc4random() % RANDOM_MAX target:self selector:@selector(moveGuardRight:) userInfo:nil repeats:YES];
    });
    
    // set luke image
    self.lukeImage   = self.lukeImageView.image;
    self.flippedLuke = [UIImage imageWithCGImage:self.lukeImageView.image.CGImage
                                           scale:self.lukeImageView.image.scale
                                     orientation:UIImageOrientationUpMirrored];
    
    [self didAddViewFrom:[NSNumber numberWithFloat:0] to:[NSNumber numberWithFloat:[UIImage imageNamed:@"smalldirt.png"].size.width]];
    
    // set initial settings
    self.pixelsTraveled = 0;
    self.currentDirection = LEFT;
    [self flipLuke:LEFT];
}

- (void)initIndicators {
    
    self.foregroundPositionIndicatorImage = [UIImage imageNamed:@"Gray Button.png"];
    self.positionIdicatorImage = [UIImage imageNamed:@"Red Button.png"];

    for (NSArray* element in self.foregroundElements) {
        BOOL shouldShowIndicator = [element[1] boolValue];
        
        if (shouldShowIndicator) {
            
            UIImageView* imageView = [[UIImageView alloc] initForAutoLayout];
            imageView.image = self.foregroundPositionIndicatorImage;
            
            
            NSNumber* position = element[0];
            NSNumber* total = [self totalDistance];
            CGFloat lineWidth = POSITIONBAR_LENGTH * -1;
            
            CGFloat offset = ([position floatValue] / [total floatValue]) * lineWidth;
            
            [self.controlbarContainer addSubview:imageView];
            [imageView autoSetDimensionsToSize:CGSizeMake(15, 15)];
            [imageView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.positionStatusLine];
            [imageView autoConstrainAttribute:ALAttributeVertical
                                  toAttribute:ALAttributeTrailing
                                       ofView:self.positionStatusLine
                                   withOffset:offset];
            
        }
        
    }
    
    self.positionIdicatorImageView = [[UIImageView alloc] initForAutoLayout];
    self.positionIdicatorImageView.image = self.positionIdicatorImage;
    
    
    [self.controlbarContainer addSubview:self.positionIdicatorImageView];
    [self.positionIdicatorImageView autoSetDimensionsToSize:CGSizeMake(15, 15)];
    [self.positionIdicatorImageView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.positionStatusLine];
    self.positionStatusConstraint = [self.positionIdicatorImageView autoConstrainAttribute:ALAttributeVertical
                                                                               toAttribute:ALAttributeTrailing
                                                                                    ofView:self.positionStatusLine];
    
}

- (void)initForegrounds {
    self.foregroundElements = [NSMutableArray array];
    self.addedElements = [NSMutableArray array];
    
    // Elements
    [self.foregroundElements addObject:@[[NSNumber numberWithFloat:TOTAL_DISTANCE * 0.005], @YES, @"friendshipcircle.png", @"1", @"friendshipCircle"]];
    [self.foregroundElements addObject:@[[NSNumber numberWithFloat:TOTAL_DISTANCE * 0.16],  @YES, @"booth.png", @"3", @"tecate"]];
    [self.foregroundElements addObject:@[[NSNumber numberWithFloat:TOTAL_DISTANCE * 0.28],  @YES, @"lagloria.png", @"4", @"laGloria"]];
    [self.foregroundElements addObject:@[[NSNumber numberWithFloat:TOTAL_DISTANCE * 0.41],  @YES, @"WelcomeToJacumba2.png", @"5", @"jacumba"]];
    [self.foregroundElements addObject:@[self.elcamino_position,  @YES, @"fighterjets.png", @"6", @"elCamino"]];
    
    
    [self.foregroundElements addObject:@[[NSNumber numberWithFloat:TOTAL_DISTANCE * 0.2],  @YES, @"borderguard.png", @"99", @"borderGuard"]];
    [self.foregroundElements addObject:@[[NSNumber numberWithFloat:TOTAL_DISTANCE * 0.6],  @YES, @"borderguard.png", @"98", @"borderGuard"]];
    [self.foregroundElements addObject:@[[NSNumber numberWithFloat:TOTAL_DISTANCE * 0.8],  @YES, @"borderguardflip.png", @"97", @"borderGuard"]];
    [self.foregroundElements addObject:@[[NSNumber numberWithFloat:TOTAL_DISTANCE * 0.95], @YES, @"borderguard.png", @"96", @"borderGuard"]];
    
    [self.foregroundElements addObject:@[[NSNumber numberWithFloat:TOTAL_DISTANCE * 0.35],        @YES, @"truck2.png", @"95", @"fordTruck"]];
    [self.foregroundElements addObject:@[[NSNumber numberWithFloat:(TOTAL_DISTANCE * 0.35) + 5],  @YES, @"borderguard.png", @"94", @"borderGuard"]];
    [self.foregroundElements addObject:@[[NSNumber numberWithFloat:TOTAL_DISTANCE * 0.7],        @YES, @"truckflip.png", @"93", @"fordTruck"]];
    [self.foregroundElements addObject:@[[NSNumber numberWithFloat:(TOTAL_DISTANCE * 0.7) + 5],  @YES, @"borderguardflip.png", @"92", @"borderGuard"]];
    
    [self.foregroundElements addObject:@[[NSNumber numberWithFloat:TOTAL_DISTANCE * 0.5],  @YES, @"truck2flip.png", @"91", @"fordTruck"]];
    [self.foregroundElements addObject:@[[NSNumber numberWithFloat:TOTAL_DISTANCE * 0.85],  @YES, @"truck.png", @"90", @"fordTruck"]];
    
    
    
    
    
//    [self.foregroundElements addObject:@[[NSNumber numberWithFloat:10000],  @YES, @"borderguard.png", @"4", @"borderGuard"]];
//    [self.foregroundElements addObject:@[[NSNumber numberWithFloat:10000],  @YES, @"borderguard.png", @"4", @"borderGuard"]];
//    [self.foregroundElements addObject:@[[NSNumber numberWithFloat:11000],  @YES, @"borderguard.png", @"5", @"borderGuard"]];
//    [self.foregroundElements addObject:@[[NSNumber numberWithFloat:12000],  @YES, @"borderguard.png", @"6", @"borderGuard"]];
//    [self.foregroundElements addObject:@[[NSNumber numberWithFloat:15000],  @YES, @"borderguard.png", @"7", @"borderGuard"]];
//    [self.foregroundElements addObject:@[[NSNumber numberWithFloat:TOTAL_DISTANCE], @YES, @"arrow.png", @"8", @"fourthElement"]];
//    
}

- (void)initBackgrounds {
    // Set up backgrounds
    NSArray* infiniteBackgroundsData = @[@[@"sky.png",@"sky.png",[NSNumber numberWithFloat:SKY_SPEED], @"1"],
                                         @[@"smallclouds.png",@"smallclouds.png",[NSNumber numberWithFloat:CLOUDS_SPEED], @"1"],
                                         @[@"smallmountain.png",@"mountainendpoint.png",[NSNumber numberWithFloat:MOUNTAINS_SPEED], @"1"],
                                         @[@"smallfence.png",@"",[NSNumber numberWithFloat:FENCE_SPEED_BACK], @"0.8"],
                                         @[@"smallfence.png",@"",[NSNumber numberWithFloat:FENCE_SPEED_FRONT], @"1"],
                                         @[@"smalldirt.png",@"dirtendpoint.png",[NSNumber numberWithFloat:GROUND_SPEED], @"1"]];
    
    self.infiniteBackgrounds = [NSArray array];
    
    for (NSArray* pngWithSpeed in infiniteBackgroundsData) {
        [self addInfinteBackground:pngWithSpeed[0] andEndPng:pngWithSpeed[1] withSpeed:pngWithSpeed[2] andMult:[[NSString stringWithString:pngWithSpeed[3]] floatValue]];
    }
    
    InfiniteBackgroundElement* lastElement = (InfiniteBackgroundElement*)self.infiniteBackgrounds.lastObject;
    lastElement.delegate = self;
    
    // Color the controlbar container orange.
    [self.controlbarContainer setBackgroundColor:[UIColor colorWithRed:CONTROLBAR_RED/255 green:CONTROLBAR_GREEN/255 blue:CONTROLBAR_BLUE/255 alpha:1]];
}

- (void)initButtons {
    // Set up buttons and stuff
    
    UILongPressGestureRecognizer* rightHold = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(rightTapHold:)];
    UILongPressGestureRecognizer* leftHold = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(leftTapHold:)];
    
    self.positionLabel.text = @"0";
    self.distanceTraveledLabel.text = @"0";
    
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
    
    
    UIImageView* rightArrow = [[UIImageView alloc] initForAutoLayout];
    UIImageView* leftArrow = [[UIImageView alloc] initForAutoLayout];
    
    rightArrow.image = [UIImage imageWithCGImage:[UIImage imageNamed:@"arrow.png"].CGImage
                                           scale:[UIImage imageNamed:@"arrow.png"].scale * 1.8
                                     orientation:UIImageOrientationUp];
    
    leftArrow.image = [UIImage imageWithCGImage:[UIImage imageNamed:@"arrow.png"].CGImage
                                          scale:[UIImage imageNamed:@"arrow.png"].scale * 1.8
                                    orientation:UIImageOrientationUpMirrored];
    
    [self.rightButton addSubview:rightArrow];
    [rightArrow autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [rightArrow autoAlignAxis:ALAxisVertical toSameAxisOfView:self.rightButton withOffset:2];
    
    [self.leftButton addSubview:leftArrow];
    [leftArrow autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [leftArrow autoAlignAxis:ALAxisVertical toSameAxisOfView:self.leftButton withOffset:-2];
}


- (void)tapLuke:(id)sender {
    
    
}

- (NSNumber*)totalDistance {
    
    NSNumber* max = [NSNumber numberWithLong:0];
    
    for (NSArray* element in self.foregroundElements) {
        if ([element[0] floatValue] > [max floatValue]) {
            max =[NSNumber numberWithFloat:[element[0] floatValue]];
        }
    }
    
    return [NSNumber numberWithFloat:[max floatValue]];
}

- (NSArray*)getForegroundElementsBetween:(NSNumber*)start and:(NSNumber*)end {
    
    NSMutableArray* elements = [NSMutableArray array];
    
    for (NSArray* element in self.foregroundElements) {
        if ([element[0] floatValue] >= [start floatValue] && [element[0] floatValue] <= [end floatValue]) {
            [elements addObject:element];
        }
    }
    
    return elements;
}

- (void)movePositionStatus:(Direction)direction {
    if ([self position] > [[self totalDistance] floatValue]) {
        self.overEndIndicator.hidden = NO;
        self.positionIdicatorImageView.hidden = YES;
        return;
    }

    if ([self position] <= 0){
        return;
    }
    
    self.overEndIndicator.hidden = YES;
    self.positionIdicatorImageView.hidden = NO;
    if (direction == LEFT) {
        dispatch_after(0, dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:ANIMATION_DURATION animations:^{
                self.positionStatusConstraint.constant -= ((GROUND_SPEED / [[self totalDistance] floatValue]) * POSITIONBAR_LENGTH);
                [self.view layoutIfNeeded];
            }];
        });
    }
    else {
        dispatch_after(0, dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:ANIMATION_DURATION animations:^{
                self.positionStatusConstraint.constant += ((GROUND_SPEED / [[self totalDistance] floatValue]) * POSITIONBAR_LENGTH);
                [self.view layoutIfNeeded];
            }];
        });
    }
}

- (void)moveTruckLeft:(id)sender {
    UIImageView* truckImage = [[UIImageView alloc] initForAutoLayout];
    
    if (arc4random() % 2 == 0) {
        truckImage.image = [UIImage imageNamed:@"truck.png"];
    }
    else {
       truckImage.image = [UIImage imageNamed:@"truck2.png"];
    }
    
    [self.backgroundContainer addSubview:truckImage];
    [truckImage autoConstrainAttribute:ALAttributeHorizontal toAttribute:ALAttributeHorizontal ofView:self.backgroundContainer];
    NSLayoutConstraint* position = [truckImage autoConstrainAttribute:ALAttributeLeading toAttribute:ALAttributeTrailing ofView:self.backgroundContainer];
    [self.view layoutIfNeeded];
    
    dispatch_after(0, dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:2 animations:^{
            position.constant = -1 * (self.backgroundContainer.frame.size.width + truckImage.frame.size.width);
            [self.view layoutIfNeeded];
        }completion:^(BOOL finished) {
            [truckImage removeFromSuperview];
            [self.view layoutIfNeeded];
        }];
    });
    
    [self.TruckLeftTimer invalidate];
    self.TruckLeftTimer = nil;
    
    self.TruckLeftTimer = [NSTimer scheduledTimerWithTimeInterval:arc4random() % RANDOM_MAX target:self selector:@selector(moveTruckLeft:) userInfo:nil repeats:YES];
}

- (void)moveTruckRight:(id)sender {
    UIImageView* truckImage = [[UIImageView alloc] initForAutoLayout];
    
    if (arc4random() % 2 == 0) {
        truckImage.image = [UIImage imageNamed:@"truckflip.png"];
    }
    else {
        truckImage.image = [UIImage imageNamed:@"truck2flip.png"];
    }
    
    [self.backgroundContainer addSubview:truckImage];
    [truckImage autoConstrainAttribute:ALAttributeHorizontal toAttribute:ALAttributeHorizontal ofView:self.backgroundContainer];
    NSLayoutConstraint* position = [truckImage autoConstrainAttribute:ALAttributeTrailing toAttribute:ALAttributeLeading ofView:self.backgroundContainer];
    [self.view layoutIfNeeded];
    
    dispatch_after(0, dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:2 animations:^{
            position.constant = (self.backgroundContainer.frame.size.width + truckImage.frame.size.width);
            [self.view layoutIfNeeded];
        }completion:^(BOOL finished) {
            [truckImage removeFromSuperview];
            [self.view layoutIfNeeded];
        }];
        
    });
    
    [self.TruckRightTimer invalidate];
    self.TruckRightTimer = nil;
    
    self.TruckRightTimer = [NSTimer scheduledTimerWithTimeInterval:arc4random() % RANDOM_MAX target:self selector:@selector(moveTruckRight:) userInfo:nil repeats:YES];
}
    
- (void)moveGuardLeft:(id)sender {
    UIImageView* guardImage = [[UIImageView alloc] initForAutoLayout];
    guardImage.image = [UIImage imageNamed:@"borderguard.png"];
    
    [self.backgroundContainer addSubview:guardImage];
    [guardImage autoConstrainAttribute:ALAttributeHorizontal toAttribute:ALAttributeHorizontal ofView:self.backgroundContainer];
    NSLayoutConstraint* position = [guardImage autoConstrainAttribute:ALAttributeLeading toAttribute:ALAttributeTrailing ofView:self.backgroundContainer];
    [self.view layoutIfNeeded];
    
    dispatch_after(0, dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:5 animations:^{
            position.constant = -1 * (self.backgroundContainer.frame.size.width + guardImage.frame.size.width);
            [self.view layoutIfNeeded];
        }completion:^(BOOL finished) {
            [guardImage removeFromSuperview];
            [self.view layoutIfNeeded];
        }];
        
    });
    
    [self.GuardLeftTimer invalidate];
    self.GuardLeftTimer = nil;
    
    self.GuardLeftTimer = [NSTimer scheduledTimerWithTimeInterval:arc4random() % RANDOM_MAX target:self selector:@selector(moveGuardLeft:) userInfo:nil repeats:YES];
}

- (void)moveGuardRight:(id)sender {
    UIImageView* guardImage = [[UIImageView alloc] initForAutoLayout];
    guardImage.image = [UIImage imageNamed:@"borderguardflip.png"];
    
    [self.backgroundContainer addSubview:guardImage];
    [guardImage autoConstrainAttribute:ALAttributeHorizontal toAttribute:ALAttributeHorizontal ofView:self.backgroundContainer];
    NSLayoutConstraint* position = [guardImage autoConstrainAttribute:ALAttributeTrailing toAttribute:ALAttributeLeading ofView:self.backgroundContainer];
    [self.view layoutIfNeeded];
    
    dispatch_after(0, dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:5 animations:^{
            position.constant = (self.backgroundContainer.frame.size.width + guardImage.frame.size.width);
            [self.view layoutIfNeeded];
        }completion:^(BOOL finished) {
            [guardImage removeFromSuperview];
            [self.view layoutIfNeeded];
        }];
        
    });
    
    [self.GuardRightTimer invalidate];
    self.GuardRightTimer = nil;
    
    self.GuardRightTimer = [NSTimer scheduledTimerWithTimeInterval:arc4random() % RANDOM_MAX target:self selector:@selector(moveGuardRight:) userInfo:nil repeats:YES];
}

- (void)setCurrentDirection:(Direction)currentDirection {
    _currentDirection = currentDirection;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (InfiniteBackgroundElement*)lastBackground {
    return (InfiniteBackgroundElement*)self.infiniteBackgrounds.lastObject;
}

- (NSInteger)position {
    return [self lastBackground].position;
}

- (NSString*)positionString{
    return [NSString stringWithFormat:@"%li", (long)[self position]];
    
}

- (NSString*)distanceTraveledString {
    return [NSString stringWithFormat:@"%li", (long)self.pixelsTraveled];
}

- (void)addInfinteBackground:(NSString*)pngName andEndPng:(NSString*)endPngFile withSpeed:(NSNumber*)speed andMult:(CGFloat)mult{
    
    InfiniteBackgroundElement* newBackground = [[InfiniteBackgroundElement alloc] initWithPng:pngName andEndPng:endPngFile andMult:mult];
    newBackground.view.translatesAutoresizingMaskIntoConstraints = NO;
    newBackground.speed = [speed integerValue];
    newBackground.animationDuration = ANIMATION_DURATION;
    [self addChildViewController:newBackground];
    [self.backgroundContainer addSubview:newBackground.view];
    [newBackground.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.infiniteBackgrounds = [self.infiniteBackgrounds arrayByAddingObject:newBackground];
}

- (void)flipLuke:(Direction)direction {
    if (direction == LEFT) {
        self.lukeImageView.image = self.flippedLuke;
    }
    else {
        self.lukeImageView.image = self.lukeImage;
    }
}

//
//- (NSInteger)moveTo:(NSInteger)position
//   shouldCountToOdo:(BOOL)shouldCount
//shouldChangeOrientation:(BOOL)shouldChange {
//    if ([self position] > position){
//        return [self moveRightWithMultiplier:(([self position] - position) / GROUND_SPEED) shouldCountToOdo:shouldCount shouldChangeOrientation:shouldChange];
//    }
//    else if ([self position] < position) {
//        return [self moveLeftWithMultiplier:((position - [self position]) / GROUND_SPEED) shouldCountToOdo:shouldCount shouldChangeOrientation:shouldChange];
//    }
//    return position;
//}

- (void)moveWorld:(Direction)direction
 shouldCountToOdo:(BOOL)shouldCount
shouldChangeOrientation:(BOOL)shouldChange {
    
    NSInteger oldPostion = [self position];
    
    if (direction != self.currentDirection && shouldChange) {
        self.currentDirection = direction;
        [self flipLuke:direction];
        return;
    }
    
    [self movePositionStatus:direction];
    
    for (InfiniteBackgroundElement* background in self.infiniteBackgrounds) {
        if (direction == LEFT) {
            [UIView animateWithDuration:ANIMATION_DURATION animations:^{
                [background moveLeft];
                [self.view layoutIfNeeded];
            }];
        }
        else if (direction == RIGHT) {
            
            if ([self position] <= RIGHT_LIMIT) {
                return;
            }
            
            [UIView animateWithDuration:ANIMATION_DURATION animations:^{
                [background moveRight];
                [self.view layoutIfNeeded];
            }];
        }
    }
    
    if (shouldCount) {
        NSInteger change = [self position] - oldPostion;
        self.pixelsTraveled += fabs(change);
    }
    
    if (direction == LEFT &&
        [self position] >= [self.elcamino_position integerValue] &&
        !self.inElCamino){
        if (self.pressAndHoldTimer != nil) {
            [self.pressAndHoldTimer invalidate];
            self.pressAndHoldTimer = nil;
        }
        
        [self tappedForegroundElementWithDescription:@"popupForm"];
    }
    else if ([self position] < [self.elcamino_position integerValue]) {
        self.inElCamino = NO;
    }

    self.positionLabel.text = [self positionString];
    self.distanceTraveledLabel.text = [self distanceTraveledString];
}

- (IBAction)leftTap:(id)sender {
    [self moveWorld:LEFT shouldCountToOdo:YES shouldChangeOrientation:YES];
}

- (IBAction)rightTap:(id)sender {
    [self moveWorld:RIGHT shouldCountToOdo:YES shouldChangeOrientation:YES];
}

- (void)closeModal:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tappedForegroundElement:(id)sender {
    
    UITapGestureRecognizer* tapGesture = (UITapGestureRecognizer*)sender;
    UIImageView* tappedElement = (UIImageView*)tapGesture.view;
    NSInteger tag = tappedElement.tag;
    
    [self tappedForegroundElementWithTag:tag];
}

- (void)tappedForegroundElementWithTag:(NSInteger)tag {
    NSArray* element;
    for (NSArray* el in self.foregroundElements) {
        if ([el[3] integerValue] == tag){
            element = el;
            break;
        }
    }
    
    [self tappedForegroundElementWithDescription:element[4]];
}

- (void)tappedForegroundElementWithDescription:(NSString*)description {
    ModalActionVC* modalVC = [[ModalActionVC alloc] init];
    modalVC.delegate = self;
    modalVC.uniqueDescription = description;
    modalVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:modalVC animated:YES completion:nil];
}

- (void)tapMountains:(id)sender {
    [self tappedForegroundElementWithDescription:@"mountains"];
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

- (UIImageView*)addForegroundElement:(NSString*)fileName atPosition:(NSNumber*)position withTag:(NSInteger)tag {
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedForegroundElement:)];
    
    UIImageView* imageView = [[UIImageView alloc] initForAutoLayout];
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:fileName];
    imageView.tag = tag;
    [imageView addGestureRecognizer:tapGesture];
    
    [self.backgroundContainer addSubview:imageView];
    [imageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [imageView autoConstrainAttribute:ALAttributeVertical
                          toAttribute:ALAttributeTrailing
                               ofView:[self lastBackground].views.firstObject
                           withOffset:([position floatValue] + 350) * -1];
    
    return imageView;
}




#pragma mark - ModalDelegate

- (void)didCloseWithoutCompletion {
    [self moveWorld:RIGHT shouldCountToOdo:NO shouldChangeOrientation:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didCompleteAction:(NSString*)description {
    if ([description isEqualToString:@"popupForm"]) {
        self.inElCamino = YES;
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - InfiniteBackgroundDelegate

- (void)didAddViewFrom:(NSNumber*)start to:(NSNumber*)end {
    NSArray* elementsToAdd = [self getForegroundElementsBetween:start and:end];
    NSMutableArray* elementsAdded = [NSMutableArray array];
    
    for (NSArray* element in elementsToAdd) {
        NSNumber* position = element[0];
        NSString* fileName = element[2];
        NSInteger tag = [element[3] integerValue];
        
        
        UIImageView* imageView = [self addForegroundElement:fileName
                                                 atPosition:position
                                                    withTag:tag];
        
        [elementsAdded addObject:imageView];
    }
    
    [self.addedElements addObject:elementsAdded];
}

- (void)didRemoveViewFrom:(NSNumber*)start to:(NSNumber*)end {
    NSArray* elements = self.addedElements.lastObject;
    
    for (NSArray* element in elements) {
        [(UIImageView*)element removeFromSuperview];
        
    }
    
    [self.addedElements removeLastObject];
}
@end
