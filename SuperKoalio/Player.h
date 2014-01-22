//
//  Player.h
//  SuperKoalio
//
//  Created by Jacob Gundersen on 6/4/12.
//  Copyright 2012 Interrobang Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Player : CCSprite
{
    
}

@property (nonatomic, assign) CGPoint velocity;
@property (nonatomic, assign) CGPoint desiredPosition;
@property (nonatomic, assign) BOOL onGround;
@property(nonatomic,assign) BOOL shoot;
@property(nonatomic,assign) BOOL activebullet;
@property (nonatomic, assign) BOOL mightAsWellJump;
@property(nonatomic,assign) int enemiesKilled;
-(CGRect)collisionBoundingBox;
-(void)update:(ccTime)dt;

@end