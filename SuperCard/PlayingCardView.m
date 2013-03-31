//
//  PlayingCardView.m
//  SuperCard
//
//  Created by sesproul on 3/26/13.
//  Copyright (c) 2013 SDS. All rights reserved.
//

#import "PlayingCardView.h"

@interface PlayingCardView()
@property (nonatomic) CGFloat faceCardScaleFactor;
@end



@implementation PlayingCardView
@synthesize faceCardScaleFactor = _faceCardScaleFactor; //needed when you create both getter and setter

#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.90

-(CGFloat)faceCardScaleFactor{
    if (!_faceCardScaleFactor) _faceCardScaleFactor = DEFAULT_FACE_CARD_SCALE_FACTOR;
    return _faceCardScaleFactor;
}

-(void) setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor {
    _faceCardScaleFactor *= faceCardScaleFactor;
    [self setNeedsDisplay];
}

 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
#define CORNER 12.0
#define PIP_FONT_SCALE_FACTOR .2
#define CORNER_OFFSET 2.0
#define DEFAULT_GESTURE 1.0

-(void)pinch:(UIPinchGestureRecognizer *)gesture{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)){
        self.faceCardScaleFactor = gesture.scale;
        NSLog (@"Scale: %f", self.faceCardScaleFactor);
        gesture.scale = 1;
    }
}

 - (void)drawRect:(CGRect)rect
 {
     // Drawing code
     UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CORNER];
     [roundedRect addClip];
     
     [[UIColor whiteColor] setFill];
     UIRectFill(self.bounds);
     
     
     [[UIColor blackColor] setStroke];
     [roundedRect stroke];
     
     if (self.faceUp){
         
     
         UIImage *faceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@.jpg",[self rankAsString], self.suit]];
         if (faceImage) {
             CGRect imageRect = CGRectInset (self.bounds,
                                              [self getWidth]*(1.0 - self.faceCardScaleFactor),
                                              [self getWidth]*(1.0 - self.faceCardScaleFactor));
             
             [faceImage drawInRect:imageRect];
                                             
         } else {
             [self drawPips];
         }
         [self drawCorners];
     } else {
         [[UIImage imageNamed:@"cardback.png"] drawInRect:self.bounds];
     }
   
 }



-(NSString *)rankAsString{
    return  @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K" ][self.rank];
}
#pragma mark Function
-(CGFloat) getHeight {
    return self.bounds.size.height;
}

-(CGFloat) getWidth {
    return self.bounds.size.width;
}

- (void)drawCorners
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *cornerFont = [UIFont systemFontOfSize:[self getWidth] * PIP_FONT_SCALE_FACTOR];
    
    NSAttributedString *cornerText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", [self rankAsString], self.suit] attributes:@{ NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : cornerFont }];
    NSLog(@"Corner:%@%@", [self rankAsString], self.suit);
    CGRect textBounds;
    textBounds.origin = CGPointMake(CORNER_OFFSET, CORNER_OFFSET);
    textBounds.size = [cornerText size];
    [cornerText drawInRect:textBounds];
    
    [self pushContextAndRotateUpsideDown];
    [cornerText drawInRect:textBounds];
    [self popContext];
}


-(void)pushContextAndRotateUpsideDown{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context,[self getWidth], [self getHeight]);
    CGContextRotateCTM(context, M_PI);
}

-(void) popContext{
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}



-(void)setSuit:(NSString *)suit{
    _suit = suit;
    //Redraw the view if this is set
    [self setNeedsDisplay];
}

-(void)setRank:(NSUInteger)rank{
    _rank=rank;
    NSLog(@"Rank Set:%i", rank);
    //Redraw the view if this is set
    [self setNeedsDisplay];
}

-(void)setFaceUp:(BOOL)faceUp{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}
#pragma mark - Draw pips
#define PIP_H_OFFSET_PERCENTAGE 0.165
#define PIP_V_OFFSET1_PERCENTAGE 0.090
#define PIP_V_OFFSET2_PERCENTAGE 0.175
#define PIP_V_OFFSET3_PERCENTAGE 0.270

-(void) drawPips {
    if ((self.rank==1) || (self.rank == 5) ||(self.rank == 9) || (self.rank == 3)) {
        [self drawPipsWithHorizontalOffset:0
                            verticleOffset:0
                        mirroredVertically:NO];
    }
    if ((self.rank==6) || (self.rank==7) || (self.rank==8)){
        [self drawPipsWithHorizontalOffset:PIP_H_OFFSET_PERCENTAGE  
                            verticleOffset:0
                        mirroredVertically:NO];
    }
    if ((self.rank==2) || (self.rank==3) || (self.rank==7) ||(self.rank==8) || (self.rank==10)){
        [self drawPipsWithHorizontalOffset:0
                            verticleOffset:PIP_V_OFFSET2_PERCENTAGE
                        mirroredVertically:(self.rank!=7)];
    }
    if ((self.rank==4) || (self.rank==5) || (self.rank==6) || (self.rank==7) || (self.rank==8) ||(self.rank==9) || (self.rank==10)){
        [self drawPipsWithHorizontalOffset:PIP_H_OFFSET_PERCENTAGE
                            verticleOffset:PIP_V_OFFSET3_PERCENTAGE
                        mirroredVertically:YES];
    }
    
    if ((self.rank==9) || (self.rank==10)){
        [self drawPipsWithHorizontalOffset:PIP_H_OFFSET_PERCENTAGE
                            verticleOffset:PIP_V_OFFSET1_PERCENTAGE
                        mirroredVertically:YES];
    }
}

-(void)drawPipsWithHorizontalOffset:(CGFloat)hOffset
                    verticalOfffset:(CGFloat)vOffset
                         upsideDown:(BOOL)upsideDown{
    if(upsideDown)[self pushContextAndRotateUpsideDown];
    
    CGPoint middle = CGPointMake([self getWidth]/2, [self getHeight]/2);
    
    UIFont *pipFont = [UIFont systemFontOfSize:[self getWidth]*PIP_FONT_SCALE_FACTOR];
    
    NSAttributedString *attributedSuit = [[NSAttributedString alloc] initWithString:self.suit attributes: @{NSFontAttributeName :pipFont}];
    
    CGSize pipSize = [attributedSuit size];
    
    CGPoint pipOrigin = CGPointMake(middle.x-pipSize.width/2.0 - hOffset * [self getWidth],
                                    middle.y-pipSize.height/2.0 -vOffset * [self getHeight]);
    
    [attributedSuit drawAtPoint:pipOrigin];
    
    if (hOffset){
        pipOrigin.x +=hOffset* 2.0 * [self getWidth];
        [attributedSuit drawAtPoint:pipOrigin];
    }
    
    if (upsideDown) [self popContext];
}

-(void) drawPipsWithHorizontalOffset:(CGFloat)hOffset
                      verticleOffset:(CGFloat)vOffset
                  mirroredVertically:(BOOL)mirroredVertically{
    
    [self  drawPipsWithHorizontalOffset:hOffset
                        verticalOfffset:vOffset
                             upsideDown:NO] ;
     
     if (mirroredVertically){
         [self drawPipsWithHorizontalOffset:hOffset
                            verticalOfffset:vOffset
                                 upsideDown:YES];
     }
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



@end
