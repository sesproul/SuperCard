//
//  SuperCardViewController.m
//  SuperCard
//
//  Created by sesproul on 3/26/13.
//  Copyright (c) 2013 SDS. All rights reserved.
//

#import "SuperCardViewController.h"
#import "PlayingCardView.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"


@interface SuperCardViewController ()
@property (weak, nonatomic) IBOutlet PlayingCardView *PlayingCardView;
@property (nonatomic) Deck *deck;
@end

@implementation SuperCardViewController

-(Deck *)deck{
    if(!_deck){
        _deck = [[PlayingCardDeck alloc] init];
    }
    
    return _deck;
    
}

-(void)setPlayingCardView:(PlayingCardView *)PlayingCardView{
    _PlayingCardView = PlayingCardView;
    
    [self drawPlayingCardFromDeck];
    
    [PlayingCardView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:PlayingCardView action:@selector(pinch:)]];
    
}

-(void) drawPlayingCardFromDeck{
    
    Card *card = [self.deck drawRandomCard];
    if ([card isKindOfClass:[PlayingCard class]]){
        PlayingCard *playingCard = (PlayingCard *)card;
        self.PlayingCardView.suit = playingCard.suit;
        self.PlayingCardView.rank = playingCard.rank;
    }
    
}
- (IBAction)Swipe:(UISwipeGestureRecognizer *)sender {
    
    [UIView transitionWithView:self.PlayingCardView duration:0.75 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        self.PlayingCardView.faceUp = !self.PlayingCardView.faceUp;
        if (!self.PlayingCardView.faceUp){
           [self drawPlayingCardFromDeck]; 
        }
    }completion:NULL];
    
}

@end
