//
//  CardMatchingGame.h
//  Machismo
//
//  Created by ceoofufo on 15/6/15.
//  Copyright (c) 2015年 ceoofufo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

-(instancetype) initWithCardCount:(NSUInteger)count usingDeck:(Deck*)deck;
-(void)chooseCardAtIndex:(NSUInteger)index;
-(Card*)cardAtIndex:(NSUInteger)index;

@property (nonatomic,readonly)NSInteger score;

@end
