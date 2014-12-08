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

@property (nonatomic)BOOL observer;

@end

@implementation ModalActionVC

- (void)viewDidLoad {
    [super viewDidLoad];

    
    // BIG if to do all the work ;)))
    if ([self.uniqueDescription isEqualToString:@"friendshipCircle"]) {
        self.titleLabel.text = @"Friendship Circle";
        self.textView.hidden = NO;
        self.textView.text = @"The official name of this place is the \"Friendship Circle.\"\n\nA big marble obelisk stands in the center of the circle. There is a break in the southern fence to accommodate the obelisk, and some additional fencing around the break to keep anyone from trying to squeeze through.\n\nThe buffer zone between the two fences is reserved exclusively for the use of the U. S. Border Patrol, with one exception: At the top of the hill, there is a little door in the northern fence, and a sign informs that twice a week, Saturdays and Sundays from 10:00 A.M. until 2:00 P.M., U. S. citizens are allowed to enter. Then, if there happen to be Mexicans on the other side of the second, southern fence, the Americans are allowed to look at them and talk with them, though reaching through the fence or attempting \"physical contact with individuals in Mexico\" is prohibited. A portion of the American side of the visiting area has been paved with cement, in the shape of a semicircle, and there is an identical semicircle on the Mexican side of the fence.";
        
        [self.textView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
        self.observer = YES;
    }
    else if ([self.uniqueDescription isEqualToString:@"fordTruck"]) {
        self.titleLabel.text = @"Ford Truck";
        
        self.textView.hidden = NO;
        self.textView.text = @"Sometimes I'll see agents even when they're not really there. I'll spot their bright white-and-green vehicles parked on almost every significant overlook, but it's not till I'm right up on them, peering through the tinted windows, that I can tell whether they're occupied or just expensive scarecrows. About a third are empty.";
        
        [self.textView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
        self.observer = YES;
    }
    else if ([self.uniqueDescription isEqualToString:@"borderGuard"]) {
        self.titleLabel.text = @"Border Guard";

        self.textView.hidden = NO;
        self.textView.text = @"Every few miles, I'll run into an agent, who'll ask what I'm doing out here. Sometimes he'll ask to see the soles of my shoes. Agents spend most of their time cutting sign, which is to say, they patrol dirt roads near the border, looking for fresh footprints or other sign of aliens. When they come across people who are not aliens, they often ask to see the soles of their shoes. That way they won't later confuse native sign for alien sign.";
        
        [self.textView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
        self.observer = YES;
    }
    else if ([self.uniqueDescription isEqualToString:@"tecate"]) {
        self.titleLabel.text = @"Tecate";
        
        
        self.textView.hidden = NO;
        self.textView.text = @"I spot a truck, and this one has an agent inside. I tap on the window and he rolls it down and gives me a nod. People call this town Tecatito on account of how it sits right across the border from the much bigger town of Tecate, Mexico. The agent's got the nose of his truck pointed straight south, where every so often someone walks out of the Customs building and into America. A poster pasted to a wall in his line of sight features head shots of ten Hispanic men, along with details of the crimes they're wanted for, mostly smuggling, some kidnapping, some murders. I tell him I'm going across, that my hotel's a couple of miles away, that I'll have to walk through most of Tecate to get there. Does he think I'll have any problems, safetywise? Tecate's not too bad these days, he says. From what he hears, anyway. He's never crossed himself.";
        
        [self.textView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
        self.observer = YES;
    }
    else if ([self.uniqueDescription isEqualToString:@"laGloria"]) {
        self.titleLabel.text = @"La Gloria";
        
        
        self.textView.hidden = NO;
        self.textView.text = @"The trees shimmer and wobble in the red glow of his receding taillights, and then it's dark again and I go and gather up everything I think I might be able to use as a weapon, including the pepper spray, a knife, and some hiking poles. I bring it all inside the tent, crawl into my bag, zip up, and lie there, waiting. Every so often, I hear something moving outside, crunching seedpods or snapping twigs, and I turn on my headlamp and scoot up and try to look out through the tent's wall of mosquito netting, but the netting catches the light, and all I see is the wall itself. Then I turn off the light until I hear something else. Lying there in the dark, watching vague shadows on the polyester, it feels like a world of unknowns is outside pressing in.";
        
        [self.textView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
        self.observer = YES;
    }
    else if ([self.uniqueDescription isEqualToString:@"jacumba"]) {
        self.titleLabel.text = @"Jacumba";
        
        
        self.textView.hidden = NO;
        self.textView.text = @"The manager's smoking a cigarette outside when I get there, and there are plenty of rooms available, and he gives me the key to one and I go and take a shower and change, and when I come back outside, the manager's still standing by the street, smoking another cigarette. He's a skinny guy, maybe forty, maybe fifty, with a tight-cinched belt and a sort of permanent smirk. There's a convenience store — Mountain Sage Market — across the street from the hotel, and it's open, and so's the Laundromat next to it, but most everything else here on the main drag — a car wash, a gas station, an antique shop — has gone out of business. In a vacant lot near the shuttered car wash, a clutch of Border Patrol agents are milling around, waiting for something.\n\nI ask the manager about Jacume, which is the town directly south of Jacumba, right across the fence. I'd read about Jacume. The Los Angeles Times calls it a \"black hole,\" says it's overrun by smugglers and that even the Mexican cops won't go near it. The manager tells me that Jacumba and Jacume used to be as close as their names imply, that before the fence went up, people from Jacume used to cross all the time to work day shifts and do their shopping here in Jacumba, and people in Jacumba used to cross all the time to eat or party in Jacume. Jacumba and Jacume, the way he tells it, used to be real border towns, meaning places where north and south sort of overlapped and mixed together. Now they're just towns on the border.";
        
        [self.textView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
        self.observer = YES;
    }
    else if ([self.uniqueDescription isEqualToString:@"elCamino"]) {
        self.titleLabel.text = @"El Camino";
        
        
        self.textView.hidden = NO;
        self.textView.text = @"The geography, the remoteness, and the challenges of the Camino have remained more or less constant since Pablo Valencia's time, though there is one new hazard he would have found bewildering: A big chunk of it runs through the U. S. Air Force's Barry M. Goldwater Range. To gain entry, I signed a liability release that read, in part, that I accepted the \"danger of property damage and permanent, painful, disabling, and disfiguring injury or death due to high explosive detonations from falling objects such as aircraft, aerial targets, live ammunition, missiles, bombs, etc.\"\n\nThe Tinajas Altas are less than fifteen minutes behind me when I hear a huge roaring sound. I look to the north and see, barreling toward me close above the desert floor, two F-16 fighter jets. Before they reach me, they pull up and shoot nearly vertical, chasing each other into the blue sky.";
        
        [self.textView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
        self.observer = YES;
    }
    
    else if ([self.uniqueDescription isEqualToString:@"mountains"]) {
        self.titleLabel.text = @"Otay Mountains";
        
        UIImageView* imageView = [[UIImageView alloc] initForAutoLayout];
        imageView.image = [UIImage imageNamed:@"otaymountain.png"];
        
        [self.mainView addSubview:imageView];
        [imageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    }
    else if ([self.uniqueDescription isEqualToString:@"popupForm"]) {
        self.titleLabel.text = @"El Camino Waiver";
        
        UILabel* label = [[UILabel alloc] initForAutoLayout];
        label.userInteractionEnabled = YES;
        label.text = @"Tap Here to Accept the Risk";
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(successfulClose:)]];
        
        [self.mainView addSubview:label];
        [label autoConstrainAttribute:ALAttributeVertical toAttribute:ALAttributeVertical ofView:self.mainView];
        [label autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
        
        self.textView.hidden = NO;
        self.textView.text = @"Beware!\n\nThis is the treacherous El Camino Del Diablo. There is serious danger of property damage and permanent, painful, disabling, and disfiguring injury or death due to high explosive detonations from falling objects such as aircraft, aerial targets, live ammunition, missiles, bombs, etc.";

    }
    
    [self.view layoutIfNeeded];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.observer) {
        [self.textView removeObserver:self forKeyPath:@"contentSize"];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UITextView *tv = object;
    //Center vertical alignment
    //CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])/2.0;
    //topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    //tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
    
    //Bottom vertical alignment
    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height);
    topCorrect = (topCorrect <0.0 ? 0.0 : topCorrect);
    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)successfulClose:(id)sender {
    [self.delegate didCompleteAction:self.uniqueDescription];
}

- (IBAction)close:(id)sender {
    if ([self.uniqueDescription isEqualToString:@"popupForm"]) {
        [self.delegate didCloseWithoutCompletion];
        return;
    }
    
    [self.delegate didCompleteAction:self.uniqueDescription];
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
