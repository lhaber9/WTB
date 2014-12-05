//
//  InfiniteBackgroundElement.h
//  Walking The Border
//
//  Created by Lucas Haber on 11/21/14.
//  Copyright (c) 2014 IM2100. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InfiniteBackgroundElementDelegate

- (void)didAddViewFrom:(NSNumber*)start to:(NSNumber*)end;
- (void)didRemoveViewFrom:(NSNumber*)start to:(NSNumber*)end;

@end


@interface InfiniteBackgroundElement : UIViewController

@property (nonatomic, weak) id<InfiniteBackgroundElementDelegate> delegate;

@property (nonatomic)CGFloat speed;
@property (nonatomic)CGFloat animationDuration;

@property (strong, nonatomic)NSMutableArray*     views;

- (id)initWithPng:(NSString *)PngFile andEndPng:(NSString*)endPngFile andMult:(CGFloat)mult;

- (NSInteger)position;

- (NSInteger)moveLeft;
- (NSInteger)moveRight;

@end
