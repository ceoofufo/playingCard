//
//  PlayingCardView.m
//  SuperCard
//
//  Created by ceoofufo on 15/7/6.
//  Copyright (c) 2015年 ceoofufo. All rights reserved.
//

#import "PlayingCardView.h"

@interface PlayingCardView()
@property (nonatomic) CGFloat faceCardScaleFactor;
@end

@implementation PlayingCardView

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0
#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.90

@synthesize faceCardScaleFactor = _faceCardScaleFactor;

- (CGFloat) faceCardScaleFactor
{
    if (! _faceCardScaleFactor) _faceCardScaleFactor = DEFAULT_FACE_CARD_SCALE_FACTOR;
    return _faceCardScaleFactor;
}

-(void) setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor
{
    _faceCardScaleFactor = faceCardScaleFactor;
    [self setNeedsDisplay];
}

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

-(void)pinch:(UIPinchGestureRecognizer*)gesture
{
    if ((gesture.state == UIGestureRecognizerStateRecognized) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        self.faceCardScaleFactor *= gesture.scale;
        gesture.scale = 1.0;
    }
}

- (void)drawRect:(CGRect)rect {
     //Drawing code
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    if (self.faceup) {
        UIImage *faceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@.jpg",[self rankAsString], self.suit]];
        if (faceImage) {
            CGRect imageRect = CGRectInset(self.bounds, self.bounds.size.width * (1.0 - self.faceCardScaleFactor),
                                           self.bounds.size.height * (1.0 - self.faceCardScaleFactor));
            [faceImage drawInRect:imageRect];
        } else {
            [self drawPips];
        }
        
         [self drawCorners];
    } else {
        [[UIImage imageNamed:@"cardback.jpg"] drawInRect:self.bounds];
    }

   
}

-(void)drawPips
{
    
}

-(NSString *)rankAsString
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"][self.rank];
}

- (void) drawCorners
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *cornerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    cornerFont = [cornerFont fontWithSize:cornerFont.pointSize * [self cornerScaleFactor]];
    
    NSAttributedString *cornerText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",[self rankAsString],self.suit] attributes:@{NSFontAttributeName : cornerFont, NSParagraphStyleAttributeName : paragraphStyle}];
    
    CGRect textBounds;
    textBounds.origin = CGPointMake([self cornerOffset], [self cornerOffset]);
    textBounds.size = [cornerText size];
    
    [cornerText drawInRect:textBounds];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
    [cornerText drawInRect:textBounds];
    
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
