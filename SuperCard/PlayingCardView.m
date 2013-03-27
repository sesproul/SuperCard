//
//  PlayingCardView.m
//  SuperCard
//
//  Created by sesproul on 3/26/13.
//  Copyright (c) 2013 SDS. All rights reserved.
//

#import "PlayingCardView.h"

@implementation PlayingCardView

-(void)setSuit:(NSString *)suit{
    _suit = suit;
    [self setNeedsDisplay];
}

-(void)setRank:(NSUInteger)rank{
    _rank=rank;
    [self setNeedsDisplay];
}

-(void)setFaceUp:(BOOL)faceUp{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

#pragma mark - Initialization

-(void)setup{
    //do intialization here
}

-(void)awakeFromNib{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
