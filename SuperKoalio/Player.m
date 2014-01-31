//
//  Player.m
//  SuperKoalio
//
//  Created by Jacob Gundersen on 6/4/12.
//  Copyright 2012 Interrobang Software LLC. All rights reserved.
//

#import "Player.h"
#import "SimpleAudioEngine.h"


@implementation Player
@synthesize desiredPosition = _desiredPosition;
@synthesize onGround = _onGround;
@synthesize mightAsWellJump = _mightAsWellJump;
@synthesize shoot = _shoot;
@synthesize enemiesKilled = _enemiesKilled;
-(id)initWithFile:(NSString *)filename {
    if (self = [super initWithFile:filename]) {
        self.velocity = ccp(250.0, 0.0);
        self.enemiesKilled = 0;
        
        
    }
    return self;
}
-(CGRect)collisionBoundingBox {
    
    
    CGRect collisionBox = CGRectInset(self.boundingBox, 3, 0);
    CGPoint diff = ccpSub(self.desiredPosition, self.position);
    CGRect returnBoundingBox = CGRectOffset(collisionBox, diff.x, diff.y);
    return returnBoundingBox;
}
-(void)update:(ccTime)dt {
    
    CGPoint gravity = ccp(0.0, -450.0);
    CGPoint gravityStep = ccpMult(gravity, dt);
    
    CGPoint forwardMove = ccp(10000.0, 0.0);
    CGPoint forwardStep = ccpMult(forwardMove, dt); //1
    
    self.velocity = ccpAdd(self.velocity, gravityStep);
    self.velocity = ccp(self.velocity.x * 0.90, self.velocity.y); //2
    
    
    CGPoint jumpForce = ccp(0.0, 1000.0);
    
    
    if (self.mightAsWellJump && self.onGround) {
        
        self.velocity = ccpAdd(self.velocity, jumpForce);
        self.mightAsWellJump = NO;
    }
    
    self.velocity = ccpAdd(self.velocity, forwardStep);
    
    CGPoint minMovement = ccp(0.0, -450.0);
    CGPoint maxMovement = ccp(300.0 - (self.enemiesKilled * 50), 300.0-(self.enemiesKilled * 25));
    self.velocity = ccpClamp(self.velocity, minMovement, maxMovement); //4
    
    CGPoint stepVelocity = ccpMult(self.velocity, dt);
    
    self.desiredPosition = ccpAdd(self.position, stepVelocity);
    
    
}

@end
