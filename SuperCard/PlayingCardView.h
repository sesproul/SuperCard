//
//  PlayingCardView.h
//  SuperCard
//
//  Created by sesproul on 3/26/13.
//  Copyright (c) 2013 SDS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic)NSString *suit;

@property (nonatomic) BOOL faceUp;

@end
