//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by sesproul on 2/9/13.
//  Copyright (c) 2013 SDS. All rights reserved.
//

#import "CardMatchingGame.h"
@interface CardMatchingGame()
    @property (readwrite, nonatomic) int score;
    @property (readwrite,nonatomic)NSUInteger NumberOfCardsToMatch;
    @property (strong, nonatomic) NSMutableArray *cards; // of Card for 3 flip
    @property(readwrite, nonatomic) NSDictionary *flipResults;
    @property (readwrite, nonatomic) NSString *flipStatus;  //Change flipStatus
    @property (readwrite, nonatomic) int flipCardCount;
@end




@implementation CardMatchingGame

-(NSString *) flipStatus{
    if (!_flipStatus) _flipStatus = [[NSString alloc] init];
    return _flipStatus;
}

-(NSMutableArray *) cards{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    
    return _cards;
}


- (void)NumberOfCardsToMatch:(NSUInteger)NumberOfCardsToMatch{
    
    _NumberOfCardsToMatch = NumberOfCardsToMatch;
    NSLog(@"New Value : %d, Current IVAR %d", NumberOfCardsToMatch, _NumberOfCardsToMatch);

}

// make these penalty a
#define MATCH_BONUS 4
#define MISMATCH_PENALITY 2
#define FLIP_COST 1
#define OVER_FLIP 1

-(void) flipCardAtindex:(NSUInteger)index{
    //This is the card we are about to flip
    Card *card = [self cardAtindex:index];
    
    
    //we use a dictionary to track the results.
    NSMutableDictionary *results = [[NSMutableDictionary alloc] init];
    //we have this array to check how many cards are already flipped over
    NSMutableArray *cardsFacingUp = [[NSMutableArray alloc] init];
    
    if (card && !card.isFaceUp){
        //look through all the other cards and see if we can find other face up cards.
        for (Card *otherCard in self.cards){
            if (otherCard.isFaceUp && !otherCard.isUnPlayable){
                [cardsFacingUp addObject:otherCard];
            }
        }
         
        if ([cardsFacingUp count]+1 == self.NumberOfCardsToMatch){
            //we are matching
            [results setObject:[cardsFacingUp arrayByAddingObject:card] forKey:@"cardsFlipped"];
            int matchScore = [card match:cardsFacingUp];
            card.faceUp = !card.isFaceUp;            
            if (matchScore){
                card.unPlayable = YES;
                for (Card *flipCard in cardsFacingUp){
                    flipCard.unPlayable = YES;

                }
            self.score += matchScore * MATCH_BONUS;
            [results setObject:@(matchScore * MATCH_BONUS) forKey:@"flipScore"];
            } else {
                //we did not match so there is a penalty
                self.score -=MISMATCH_PENALITY;
                [results setObject:@(-MISMATCH_PENALITY) forKey:@"flipScore"];
            }
        } else if ([cardsFacingUp count]+1 < self.NumberOfCardsToMatch){
            //we are flipping
            [results setObject:[cardsFacingUp arrayByAddingObject:card] forKey:@"cardsFlipped"];
            card.faceUp = !card.isFaceUp;
            self.score -=FLIP_COST;
            [results setObject:@(-FLIP_COST) forKey:@"flipScore"];

        } else {
            //we are not flipping we give error over max count
            //self.score -=OVER_FLIP;
            [results setObject:@(0) forKey:@"flipScore"];
            [results setObject:@(OVER_FLIP) forKey:@"invalidFlip"];
            [results setObject:cardsFacingUp forKey:@"cardsFlipped"];
        }
    } else if (card && card.isFaceUp){
        //Flip the card back over
        card.faceUp = !card.isFaceUp;
        self.score -=FLIP_COST;
        [results setObject:[cardsFacingUp arrayByAddingObject:card] forKey:@"cardsFlipped"];
        [results setObject:@(-FLIP_COST) forKey:@"flipScore"];    }
    self.flipResults = [results copy];
}


-(Card *) cardAtindex:(NSUInteger)index{
    
    return (index < [self.cards count]) ?   self.cards[index] : nil;
    }


-(id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck ForMatchingCards:(NSUInteger)MatchingCards{
    self = [super init];
    
    if (self){
         
        //draw out the count of cards for this game
        for (int i= 0; i < count; i++){
            Card *card = [deck drawRandomCard];
            if (card) {
                self.cards[i] = card;
            } else{
                self = nil;
                break;
            }
        }
    }
    
    self.NumberOfCardsToMatch = MatchingCards;
    
    return self;
}

@end
