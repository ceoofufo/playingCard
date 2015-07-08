//
//  PlayingCard.h
//  Machismo
//
//  Created by ceoofufo on 15/6/15.
//  Copyright (c) 2015年 ceoofufo. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+(NSArray*) validSuits;
+(NSUInteger)maxRank;

@end
