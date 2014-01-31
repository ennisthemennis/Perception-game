//
//  GameLevelLayer.h
//  SuperKoalio
//
//  Created by Jacob Gundersen on 6/4/12.

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Player.h"

@interface GameLevelLayer5 : CCLayer {
    CCAction *run;
    NSMutableArray *runningFrames;
    CCAction *shake;
    NSMutableArray *shakingFrames;
    
}
@property(nonatomic,retain) NSDate *start;

+(CCScene *) scene;
-(void) onEnter;
-(id) init;
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer;
-(void) pauser;
-(void) handleTapFrom:(UITapGestureRecognizer *) recognizer;
-(void)update:(ccTime)dt;
-(void) firstUpdate;
-(void) secondUpdate;
-(void) thirdUpdate;
-(void) fourthUpdate;
- (CGPoint)tileCoordForPosition:(CGPoint)position;
-(CGRect)tileRectFromTileCoords:(CGPoint)tileCoords;
-(NSArray *)getSurroundingTilesAtPosition:(CGPoint)position forLayer:(CCTMXLayer *)layer;
-(void)checkForAndResolveCollisions:(Player *)p;
-(void)setViewpointCenter:(CGPoint) position;
-(void)handleHazardCollisions:(Player *)p;
-(void)gameOver;
-(void)checkForWin;
-(void) projectileCheck;
-(void) moveAliens;
-(void) deathCheck;

@end