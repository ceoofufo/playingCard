//
//  PlayingCardView.m
//  SuperCard
//
//  Created by ceoofufo on 15/7/6.
//  Copyright (c) 2015年 ceoofufo. All rights reserved.
//

#import "PlayingCardView.h"

@implementation PlayingCardView

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

-(CGFloat) cornerScaleFactor
{
    return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT;
}

-(CGFloat) cornerRadius
{
    return CORNER_RADIUS * [self cornerScaleFactor];
}

-(CGFloat) cornerOffset
{
    return [self cornerRadius] / 3.0;
}

-(void) setSuit:(NSString *)suit
{
    _suit = suit;
    [self setNeedsDisplay];
}

-(void) setRank:(NSInteger)rank
{
    _rank = rank;
    [self setNeedsDisplay];
}

-(void) setFaceup:(BOOL)faceup;
{
    _faceup = faceup;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
     //Drawing code
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
}

#pragma mark - initialization
-(void)setup
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

-(void)awakeFromNib
{
    [self setup];
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


@end
