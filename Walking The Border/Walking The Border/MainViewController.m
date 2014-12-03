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

@interface MainViewController ()

@property (nonatomic)Direction currentDirection;

@property (strong, nonatomic)NSMutableArray* foregroundElements;
@property (strong, nonatomic)NSMutableArray* addedElements;

@property (strong, nonatomic)IBOutlet UIView* backgroundContainer;
@property (strong, nonatomic)IBOutlet UIView* controlbarContainer;

@property (strong, nonatomic)IBOutlet UIView*             positionStatusLine;
@property (strong, nonatomic)NSLayoutConstraint*          positionStatusConstraint;

@property (strong, nonatomic)IBOutlet UIImageView* lukeImageView;
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

@property (nonatomic)NSInteger pixelsTraveled;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBackgrounds];
    [self initForegrounds];
    [self initButtons];
    [self initIndicators];
    
    
    // set luke image
    self.lukeImage   = self.lukeImageView.image;
    self.flippedLuke = [UIImage imageWithCGImage:self.lukeImageView.image.CGImage
                                           scale:self.lukeImageView.image.scale
                                     orientation:UIImageOrientationUpMirrored];
    
    [self didAddViewFrom:[NSNumber numberWithFloat:0] to:[NSNumber numberWithFloat:[self lastBackground].view.frame.size.width]];
    
    
    // set initial settings
    self.pixelsTraveled = 0;
    self.currentDirection = LEFT;
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
    
    UIImageView* imageView = [[UIImageView alloc] initForAutoLayout];
    imageView.image = self.positionIdicatorImage;
    
    
    [self.controlbarContainer addSubview:imageView];
    [imageView autoSetDimensionsToSize:CGSizeMake(15, 15)];
    [imageView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.positionStatusLine];
    self.positionStatusConstraint = [imageView autoConstrainAttribute:ALAttributeVertical
                                                          toAttribute:ALAttributeTrailing
                                                               ofView:self.positionStatusLine];
    
}

- (void)initForegrounds {
    self.foregroundElements = [NSMutableArray array];
    self.addedElements = [NSMutableArray array];
    [self.foregroundElements addObject:@[[NSNumber numberWithFloat:0],     @YES, @"arrow.png", @"0", @"firstElement"]];
    [self.foregroundElements addObject:@[[NSNumber numberWithFloat:500],   @YES, @"friendshipcircle.png", @"1", @"friendshipCircle"]];
    [self.foregroundElements addObject:@[[NSNumber numberWithFloat:1000],  @YES, @"arrow.png", @"2", @"secondElement"]];
    [self.foregroundElements addObject:@[[NSNumber numberWithFloat:5000],  @YES, @"arrow.png", @"3", @"thirdElement"]];
    [self.foregroundElements addObject:@[[NSNumber numberWithFloat:10000], @YES, @"arrow.png", @"4", @"fourthElement"]];
    
}

- (void)initBackgrounds {
    // Set up backgrounds
    NSArray* infiniteBackgroundsData = @[@[@"sky.png",[NSNumber numberWithFloat:SKY_SPEED], @"1"],
                                         @[@"smallclouds.png",[NSNumber numberWithFloat:CLOUDS_SPEED], @"1"],
                                         @[@"smallmountain.png",[NSNumber numberWithFloat:MOUNTAINS_SPEED], @"1"],
                                         @[@"smallfence.png",[NSNumber numberWithFloat:FENCE_SPEED_BACK], @"0.8"],
                                         @[@"smallfence.png",[NSNumber numberWithFloat:FENCE_SPEED_FRONT], @"1"],
                                         @[@"smalldirt.png",[NSNumber numberWithFloat:GROUND_SPEED], @"1"]];
    
    self.infiniteBackgrounds = [NSArray array];
    
    for (NSArray* pngWithSpeed in infiniteBackgroundsData) {
        [self addInfinteBackground:pngWithSpeed[0] withSpeed:pngWithSpeed[1] andMult:[[NSString stringWithString:pngWithSpeed[2]] floatValue]];
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
    if ([self position] > [[self totalDistance] floatValue] || [self position] == 0) {
        return;
    }

    if (direction == LEFT) {
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            self.positionStatusConstraint.constant -= ((GROUND_SPEED / [[self totalDistance] floatValue]) * POSITIONBAR_LENGTH);
            [self.view layoutIfNeeded];
        }];
    }
    else {
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            self.positionStatusConstraint.constant += ((GROUND_SPEED / [[self totalDistance] floatValue]) * POSITIONBAR_LENGTH);
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)setCurrentDirection:(Direction)currentDirection {
    _currentDirection = currentDirection;
    [self flipLuke:currentDirection];
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

- (void)addInfinteBackground:(NSString*)pngName withSpeed:(NSNumber*)speed andMult:(CGFloat)mult{
    
    InfiniteBackgroundElement* newBackground = [[InfiniteBackgroundElement alloc] initWithPng:pngName andMult:mult];
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
    
    if (direction != self.currentDirection) {
        self.currentDirection = direction;
        return;
    }
    
    for (InfiniteBackgroundElement* background in self.infiniteBackgrounds) {
        if (direction == LEFT) {
            [UIView animateWithDuration:ANIMATION_DURATION animations:^{
                [background moveLeft];
                [self.view layoutIfNeeded];
            }];
        }
        else if (direction == RIGHT) {
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

    self.positionLabel.text = [self positionString];
    self.distanceTraveledLabel.text = [self distanceTraveledString];
}

- (IBAction)leftTap:(id)sender {
    [self moveWorld:LEFT shouldCountToOdo:YES shouldChangeOrientation:YES];
    [self movePositionStatus:LEFT];
}

- (IBAction)rightTap:(id)sender {
    [self moveWorld:RIGHT shouldCountToOdo:YES shouldChangeOrientation:YES];
    [self movePositionStatus:RIGHT];
}

- (void)closeModal:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tappedForegroundElement:(id)sender {
    
    UITapGestureRecognizer* tapGesture = (UITapGestureRecognizer*)sender;
    UIImageView* tappedElement = (UIImageView*)tapGesture.view;
    NSInteger tag = tappedElement.tag;
    
    NSArray* element;
    for (NSArray* el in self.foregroundElements) {
        if ([el[3] integerValue] == tag){
            element = el;
            break;
        }
    }
    
    ModalActionVC* modalVC = [[ModalActionVC alloc] init];
    modalVC.delegate = self;
    modalVC.uniqueDescription = element[4];
    modalVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:modalVC animated:YES completion:nil];
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
    [imageView autoConstrainAttribute:ALAttributeTrailing
                          toAttribute:ALAttributeTrailing
                               ofView:[self lastBackground].views.firstObject
                           withOffset:([position floatValue] + 350) * -1];
    
    return imageView;
}




#pragma mark - ModalDelegate

- (void)didRequestClose {
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
