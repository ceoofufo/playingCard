//
//  Card.h
//  Machismo
//
//  Created by ceoofufo on 15/6/14.
//  Copyright (c) 2015年 ceoofufo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic)NSString* contents;
@property (nonatomic, getter=isChosen) BOOL chosen;
@property (nonatomic, getter=isMatched) BOOL matched;

-(int)match:(NSArray* )otherCards;

@end
