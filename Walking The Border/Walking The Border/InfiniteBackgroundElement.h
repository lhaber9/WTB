//
//  InfiniteBackgroundElement.h
//  Walking The Border
//
//  Created by Lucas Haber on 11/21/14.
//  Copyright (c) 2014 IM2100. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfiniteBackgroundElement : UIViewController


@property (nonatomic)CGFloat speed;
@property (nonatomic)CGFloat animationDuration;

- (id)initWithPng:(NSString *)PngFile;

- (NSInteger)position;

- (NSInteger)moveLeft;
- (NSInteger)moveRight;



@end
