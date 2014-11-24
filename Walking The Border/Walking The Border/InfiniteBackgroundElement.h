//
//  InfiniteBackgroundElement.h
//  Walking The Border
//
//  Created by Lucas Haber on 11/21/14.
//  Copyright (c) 2014 IM2100. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InfiniteBackgroundElementDelegate

- (void)willAddViewFrom:(NSInteger)start to:(NSInteger)end;
- (void)willRemoveViewFrom:(NSInteger)start to:(NSInteger)end;

@end


@interface InfiniteBackgroundElement : UIViewController

@property (nonatomic, weak) id<InfiniteBackgroundElementDelegate> delegate;

@property (nonatomic)CGFloat speed;
@property (nonatomic)CGFloat animationDuration;

- (id)initWithPng:(NSString *)PngFile;

- (NSInteger)position;

- (NSInteger)moveLeft;
- (NSInteger)moveRight;

@end
