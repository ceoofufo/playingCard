//
//  PlayingCardView.h
//  SuperCard
//
//  Created by ceoofufo on 15/7/6.
//  Copyright (c) 2015年 ceoofufo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic) NSInteger rank;
@property (strong, nonatomic) NSString *suit;
@property (nonatomic) BOOL faceup;

@end
