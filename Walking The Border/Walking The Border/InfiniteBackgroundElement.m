//
//  InfiniteBackgroundElement.m
//  Walking The Border
//
//  Created by Lucas Haber on 11/21/14.
//  Copyright (c) 2014 IM2100. All rights reserved.
//

#import "InfiniteBackgroundElement.h"
#import "ALView+PureLayout.h"

@interface InfiniteBackgroundElement ()

@property (strong, nonatomic)UIImage*     image;
@property (nonatomic)CGFloat     mult;
@property (strong, nonatomic)NSLayoutConstraint* positionConstraint;

@end

@implementation InfiniteBackgroundElement

- (id)initWithPng:(NSString *)PngFile andMult:(CGFloat)mult{
    self.mult = mult;
    self.image = [UIImage imageNamed:PngFile];
    
    UIImageView* imageView = [[UIImageView alloc] initForAutoLayout];
    imageView.image = self.image;
    
    [self.view addSubview:imageView];
    [imageView autoAlignAxisToSuperviewAxis:ALAxisBaseline];
    self.positionConstraint = [imageView autoConstrainAttribute:ALAttributeTrailing toAttribute:ALAttributeTrailing ofView:self.view];
   
    if (self.mult < 1){
        [imageView autoSetDimension:ALDimensionHeight toSize:309 * self.mult];
    }
    
    self.views = [NSMutableArray arrayWithObject:imageView];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)position {
    return self.positionConstraint.constant;
}

- (NSInteger)moveLeft {
    
    CGFloat currentPosition = self.positionConstraint.constant;
    CGFloat newPosition = currentPosition + self.speed;
    
    CGFloat totalWidth = self.views.count * self.image.size.width;
    
    if (newPosition > totalWidth - 750) {
        UIImageView* imageView = [[UIImageView alloc] initForAutoLayout];
        imageView.image = self.image;
        [self.view addSubview:imageView];
        [imageView autoAlignAxisToSuperviewAxis:ALAxisBaseline];
        [imageView autoConstrainAttribute:ALAttributeTrailing toAttribute:ALAttributeLeading ofView:self.views.lastObject];
        [imageView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.views.lastObject];
        
        [self.views addObject:imageView];
        [self.delegate didAddViewFrom:[NSNumber numberWithDouble:totalWidth] to:[NSNumber numberWithDouble:totalWidth + self.image.size.width]];
    }
    
    self.positionConstraint.constant = newPosition;

    return newPosition;
}

- (NSInteger)moveRight {
    
    CGFloat currentPosition = self.positionConstraint.constant;
    CGFloat newPosition = currentPosition - self.speed;
    
    if (newPosition < 0) {
        return 0;
    }
    
    CGFloat totalWidth = self.views.count * self.image.size.width;
    
    if (newPosition < totalWidth - self.image.size.width - 750 && self.views.count > 1) {
        [self.views.lastObject removeFromSuperview];
        [self.views removeLastObject];
        [self.delegate didRemoveViewFrom:[NSNumber numberWithDouble:totalWidth - self.image.size.width] to:[NSNumber numberWithDouble:totalWidth]];
    }
    
    self.positionConstraint.constant = newPosition;
    
    return newPosition;
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
