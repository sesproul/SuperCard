//
//  SetCard.m
//  Matchismo
//
//  Created by sesproul on 3/3/13.
//  Copyright (c) 2013 SDS. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard
@synthesize color=_color; //because we provide setter and getter

-(BOOL) colorMatchwithC2:(SetCard *) card2
                   andC3:(SetCard *) card3{
    BOOL match = NO;
    NSLog(@"Color1: %@, Color2: %@, Color3: %@",self.color, card2.color, card3.color);
    if ([self.color isEqualToString:card2.color] &&
        [self.color isEqualToString:card3.color] &&
        [card3.color isEqualToString:card2.color]){
        match = YES;
    }
    
    if (![self.color isEqualToString:card2.color] &&
        ![self.color isEqualToString:card3.color] &&
        ![card3.color isEqualToString:card2.color]) {
        match = YES;
    }
   return match;
}

-(BOOL) symbolMatchwithC2:(SetCard *) card2
                    andC3:(SetCard *) card3{
    BOOL match = NO;
    
    if (!([self.symbol isEqualToString:card2.symbol]) &&
        !([self.symbol isEqualToString:card3.symbol]) &&
        !([card3.symbol isEqualToString:card2.symbol])){
        match = YES;
    }
    
    
    return match;
    }


-(BOOL) fillMatchwithC2:(SetCard *) card2
                     andC3:(SetCard *) card3{
    BOOL match = NO;
    if (!(self.fill == card2.fill) &&
        !(self.fill == card3.fill) &&
        !(card3.fill == card2.fill)){
        match = YES;
    }
    
    return match;
}

//Override
-(int)match:(NSArray *)otherCards{
    
    int score = 0;
    
    if ([otherCards count] ==2) {
        SetCard *card2 = (SetCard *)otherCards[0];
        SetCard *card3 = (SetCard *)[otherCards lastObject];
        if ([self colorMatchwithC2:card2 andC3:card3]){
            score = 3;
        
            if ([self symbolMatchwithC2:card2 andC3:card3]){
                score *= 3;
            }
            
            if ([self fillMatchwithC2:card2 andC3:card3]){
                score *= 3;
            }
           
        }
    }
   
    return score;
}




-(NSString *)contents

{
    NSString *tmp = [self.symbol stringByPaddingToLength:self.number withString:self.symbol startingAtIndex:0];
    NSLog(@"%@, Fill: %i, Qty: %i, Color : %@",tmp,self.fill ,self.number,  self.color);
    return tmp;
}

-(NSString *)description{
    return [self.contents stringByAppendingFormat:@"-%@-%u",self.color,self.fill];
}


+(NSArray *) validSymbols
{
    return @[@"▲",@"●",@"■"];
}


// ------------------------Symbol on the Card
@synthesize symbol=_symbol;//because we provide setter and getter
- (void)setSymbol:(NSString *) symbol{
    //Check to see if the passed in object is in this valid array
    if ([[SetCard validSymbols] containsObject:symbol]){
        _symbol = symbol;
    }
}
-(NSString *)symbol{
    
    //here if suit is nil, then we have to assign the symbol as ?
    // using the tertiary IF
    
    return _symbol ? _symbol : @"?";
}

+(NSArray *) validColors
{
    return @[@"red",@"green",@"purple"];
}
- (void)setColor:(NSString *) color{
    
    //Check to see if the passed in object is in this valid array of colors
    if ([[SetCard validColors] containsObject:color]){
        _color = color;
    }
}
-(NSString *)color{
    //here if suit is nil, then we have to assign the color as ?
    // using the tertiary IF
    
    return _color ? _color : @"?";
}

// ------------------------Fill on the Card
- (void)setFill:(NSUInteger)fill{
    //Check to see if fill value is 1,2,3
    if (fill==0 || fill ==1 || fill==2) _fill = fill;}

// ------------------------Number of items
- (void)setNumber:(NSUInteger)number{
    //Check to see if fill value is 1,2,3
    if (number==1 || number ==2 || number==3) _number = number;
    }

@end
