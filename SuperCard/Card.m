//
//  Card.m
//  Machismo
//
//  Created by ceoofufo on 15/6/14.
//  Copyright (c) 2015年 ceoofufo. All rights reserved.
//

#import "Card.h"

@implementation Card

-(int)match:(NSArray* )otherCards
{
    int score = 0;
    for(Card* card in otherCards) {
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
        }
    }
    return score;
}

@end
