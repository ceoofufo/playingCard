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

#pragma mark -Pips
#define PIP_HOFFSET_PERCENTAGE 0.165
#define PIP_VOFFSET1_PERCENTAGE 0.090
#define PIP_VOFFSET2_PERCENTAGE 0.175
#define PIP_VOFFSET3_PERCENTAGE 0.270

-(void)drawPips
{
    if ((self.rank == 1) || (self.rank == 5) || (self.rank == 9) || (self.rank == 3)) {
        [self drawPipsWithHorizontalOffset:0 verticalOffset:0 mirroredVertically:NO];
    }
    
    if ((self.rank == 6) || (self.rank == 7) || (self.rank == 8)) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE verticalOffset:0 mirroredVertically:NO];
    }
    
    if ((self.rank == 2) || (self.rank == 3) || (self.rank == 7) || (self.rank == 8) || (self.rank == 10)) {
        [self drawPipsWithHorizontalOffset:0 verticalOffset:PIP_VOFFSET2_PERCENTAGE mirroredVertically:(self.rank != 7)];
    }
    
    if ((self.rank == 4) || (self.rank == 5) || (self.rank == 6) || (self.rank == 7) || (self.rank == 8) || (self.rank == 9) || (self.rank == 10)) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE verticalOffset:PIP_VOFFSET3_PERCENTAGE mirroredVertically:YES];
    }
    
    if ((self.rank == 9) || (self.rank == 10)) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE verticalOffset:PIP_VOFFSET1_PERCENTAGE mirroredVertically:YES];
    }
}

#define PIP_FONT_SCALE_FACTOR 0.012

-(void) drawPipsWithHorizontalOffset :(CGFloat) hoffset verticalOffset:(CGFloat)voffset upsideDown:(BOOL)upsideDown
{
    if (upsideDown) {
        [self pushContextAndRotateUpsideDown];
    }
    
    CGPoint middle = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    UIFont *pipFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    pipFont = [pipFont fontWithSize:[pipFont pointSize] * self.bounds.size.width * PIP_FONT_SCALE_FACTOR];
    NSAttributedString *attributedSuit = [[NSAttributedString alloc] initWithString:self.suit attributes:@{NSFontAttributeName:pipFont}];
    CGSize pipSize = [attributedSuit size];
    CGPoint pipOrigin = CGPointMake(middle.x - pipSize.width / 2.0 - hoffset*self.bounds.size.width,
                                    middle.y - pipSize.height / 2.0 - voffset*self.bounds.size.height);
    [attributedSuit drawAtPoint:pipOrigin];
    if (hoffset) {
        pipOrigin.x += hoffset * 2.0 * self.bounds.size.width;
        [attributedSuit drawAtPoint:pipOrigin];
    }
    
    if (upsideDown) {
        [self popContext];
    }
    
}

- (void) drawPipsWithHorizontalOffset :(CGFloat) hoffset verticalOffset:(CGFloat)voffset mirroredVertically :(BOOL) mirroredVertically
{
    [self drawPipsWithHorizontalOffset: hoffset verticalOffset:voffset upsideDown:NO];
    if (mirroredVertically) {
        [self drawPipsWithHorizontalOffset: hoffset verticalOffset:voffset upsideDown:YES];

    }
}

-(NSString *)rankAsString
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"][self.rank];
}

-(void) pushContextAndRotateUpsideDown
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
}

- (void) popContext
{
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
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
    
    [self pushContextAndRotateUpsideDown];
    [cornerText drawInRect:textBounds];
    [self popContext];
    
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
