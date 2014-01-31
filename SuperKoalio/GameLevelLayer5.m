//
//  GameLevelLayer.m
//  SuperKoalio
//
//  Created by Jacob Gundersen on 6/4/12.

#import "Player.h"
#import "SimpleAudioEngine.h"
#import "StartMenuLayer.h"
#import "GameLevelLayer5.h"
#import "Level5DieLayer.h"
#import "Level5DoneLayer.h"



@interface GameLevelLayer5()
{
    CCTMXTiledMap *map;
    Player * player;
    CCTMXLayer *walls;
    CCTMXLayer *hazards;
    BOOL gameOver;
    CCLayerColor *whiteback;
    UISwipeGestureRecognizer *gestureRecognizer;
    UITapGestureRecognizer *gestureRecognizer2;
    CCSprite *bullet;
    NSTimeInterval timeInterval;
    CCSprite* alien1;
    CCSprite* alien2;
    CCSprite* alien3;
    CCSprite* alien4;
    CCSprite* alien5;
    CGPoint velocity1;
    CGPoint velocity2;
    CGPoint velocity3;
    CGPoint velocity4;
 
    BOOL alien1here;
    BOOL alien2here;
    BOOL alien3here;
    BOOL alien4here;
   
    CCSprite* instructions;
    BOOL start;
    BOOL won;
    CCSprite* count1;
    CCSprite* count2;
    CCSprite* count3;
    BOOL go;
    
    
}
@end
@implementation GameLevelLayer5
@synthesize start = _start;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLevelLayer5 *layer = [GameLevelLayer5 node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
	
	// return the scene
	return scene;
}
-(void) onEnter
{
    [super onEnter];
    whiteback = [[CCLayerColor alloc] initWithColor:ccc4(255, 255, 255, 255)];
    [self addChild:whiteback];
    gestureRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)] autorelease];
    [gestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [[CCDirector sharedDirector].view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer2 = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)] autorelease];
    [[CCDirector sharedDirector].view addGestureRecognizer:gestureRecognizer2];
    
    
}

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
    start = FALSE;
	if( (self=[super init]) ) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"in game?.wav"];
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.2];
        self.isTouchEnabled = YES;
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"heroframes.plist"];
        go = FALSE;
        won = FALSE;
        
        CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"heroframes.png"];
        
        [self addChild:spriteSheet];
        
        
        
        runningFrames = [NSMutableArray array];
        
        for(int i = 0; i <= 3; ++i)
        {
            [runningFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"hero%d.png", i]]];
        }
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"alienframes.plist"];
        
        
        
        CCSpriteBatchNode *spriteSheet2 = [CCSpriteBatchNode batchNodeWithFile:@"alienframes.png"];
        
        [self addChild:spriteSheet2];
        
        
        
        shakingFrames = [NSMutableArray array];
        
        for(int i = 0; i <= 3; ++i)
        {
            [shakingFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"alien%d.png", i]]];
        }
        
        map = [[CCTMXTiledMap alloc] initWithTMXFile:@"level1a.tmx"];
        [self addChild:map z:15];
        walls = [map layerNamed:@"walls"];
        hazards = [map layerNamed:@"hazards"];
        player = [[Player alloc] initWithSpriteFrameName:@"hero0.png"];
        player.scale = 0.2;
        
        player.position = ccp(100, 50);
        
        CCAnimation *running = [CCAnimation animationWithFrames: runningFrames delay:0.1f];
        run = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:running restoreOriginalFrame:NO]];
        [player runAction:run];
        [map addChild:player z:15];
        bullet = [CCSprite spriteWithFile:@"projectile.png"];
        bullet.position = ccp(0,0);
        bullet.scale = 0.5;
        [map addChild:bullet];
        alien1 = [CCSprite spriteWithSpriteFrameName:@"alien0.png" ];
        alien1.scale = 0.2;
        alien1.position = ccp(500, 50);
        CCAnimation *shaking = [CCAnimation animationWithFrames:shakingFrames delay:0.2f];
        shake = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:shaking restoreOriginalFrame:NO]];
        [alien1 runAction:shake];
        [map addChild:alien1 z:15];
        
        alien2 = [CCSprite spriteWithSpriteFrameName:@"alien0.png" ];
        alien2.scale = 0.2;
        alien2.position = ccp(1300, 50);
        
        shake = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:shaking restoreOriginalFrame:NO]];
        [alien2 runAction:shake];
        [map addChild:alien2 z:15];
        
        alien3 = [CCSprite spriteWithSpriteFrameName:@"alien0.png" ];
        alien3.scale = 0.2;
        alien3.position = ccp(2100, 50);
        shake = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:shaking restoreOriginalFrame:NO]];
        [alien3 runAction:shake];
        [map addChild:alien3 z:15];
        
        alien4 = [CCSprite spriteWithSpriteFrameName:@"alien0.png" ];
        alien4.scale = 0.2;
        alien4.position = ccp(2900, 50);
        shake = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:shaking restoreOriginalFrame:NO]];
        [alien4 runAction:shake];
        [map addChild:alien4 z:15];
        instructions = [CCSprite spriteWithFile:@"rounded-blue-sq-5.png" ];
        instructions.position = ccp(winSize.width/2, 200);
        instructions.scale  = .125;
        [map addChild:instructions z:5];
        velocity1 = ccp(-3.0, 0);
        velocity2 = ccp(-3.0, 0);
        velocity3 = ccp(-3.0, 0);
        velocity4 = ccp(-3.0, 0);
        
        alien1here = TRUE;
        alien2here = TRUE;
        alien3here = TRUE;
        alien4here = TRUE;
        
        count1 = [CCSprite spriteWithFile:@"count3.png"];
        
        
        count1.position = ccp(winSize.width/2, 75);
        
        [map addChild:count1 z:20];
        count1.visible = FALSE;
        
        count2 = [CCSprite spriteWithFile:@"count2.png"];
        
        
        count2.position = ccp(winSize.width/2, 75);
        
        [map addChild:count2 z:20];
        count2.visible =FALSE;
        count3 = [CCSprite spriteWithFile:@"count1.png"];
        
        
        count3.position = ccp(winSize.width/2, 75);
        
        [map addChild:count3 z:20];
        count3.visible = FALSE;
        
        
        [self schedule:@selector(update:)];
        
        
	}
	return self;
}
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    player.mightAsWellJump = YES;
    
    
}
-(void) handleTapFrom:(UITapGestureRecognizer *) recognizer {
    player.shoot = YES;
    
}
-(void)update:(ccTime)dt
{
    
    
    if (gameOver) {
        
        return;
    }
    ccColor3B color = {(255 - (player.enemiesKilled*45)), (255 - (player.enemiesKilled*45)), (255 - (player.enemiesKilled*45))};
    [whiteback setColor:color];
    if(start)
    {
        [player update:dt];
        
        
        [self projectileCheck];
        [self moveAliens];
        [self deathCheck];
        [self checkForAndResolveCollisions:player];
        [self setViewpointCenter:player.position];
        [self handleHazardCollisions:player];
        [self checkForWin];
    }
    if(!start && !go)
        
    {
        go = TRUE;
        [self performSelector:@selector(firstUpdate) withObject:nil afterDelay:1];
        
        [self performSelector:@selector(secondUpdate) withObject:nil afterDelay:2];
        
        
        [self performSelector:@selector(thirdUpdate) withObject:nil afterDelay:3];
        
        
        [self performSelector:@selector(fourthUpdate) withObject:nil afterDelay:4];
        
        
        
        
    }
    
}

-(void) firstUpdate
{
    
    
    count1.visible = TRUE;
    
    
}
-(void) secondUpdate
{
    
    [count1 removeFromParentAndCleanup:YES];
    
    count2.visible = TRUE;
    
    
    
}
-(void) thirdUpdate
{
    
    [count2 removeFromParentAndCleanup:YES];
    count3.visible = TRUE;
    
    
}
-(void)fourthUpdate
{
    
    
    [count3 removeFromParentAndCleanup:YES];
    
    start = TRUE;
    
}

- (CGPoint)tileCoordForPosition:(CGPoint)position
{
    float x = floor(position.x / map.tileSize.width);
    float levelHeightInPixels = map.mapSize.height * map.tileSize.height;
    float y = floor((levelHeightInPixels - position.y) / map.tileSize.height);
    return ccp(x, y);
}

-(CGRect)tileRectFromTileCoords:(CGPoint)tileCoords
{
    float levelHeightInPixels = map.mapSize.height * map.tileSize.height;
    CGPoint origin = ccp(tileCoords.x * map.tileSize.width, levelHeightInPixels - ((tileCoords.y + 1) * map.tileSize.height));
    return CGRectMake(origin.x, origin.y, map.tileSize.width, map.tileSize.height);
}
-(NSArray *)getSurroundingTilesAtPosition:(CGPoint)position forLayer:(CCTMXLayer *)layer {
    
    CGPoint plPos = [self tileCoordForPosition:position]; //1
    
    NSMutableArray *gids = [NSMutableArray array]; //2
    
    for (int i = 0; i < 9; i++) { //3
        int c = i % 3;
        int r = (int)(i / 3);
        CGPoint tilePos = ccp(plPos.x + (c - 1), plPos.y + (r - 1));
        if (tilePos.y > (map.mapSize.height - 1)) {
            //fallen in a hole
            [self gameOver];
            return nil;
        }
        int tgid = [layer tileGIDAt:tilePos]; //4
        
        CGRect tileRect = [self tileRectFromTileCoords:tilePos]; //5
        
        NSDictionary *tileDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithInt:tgid], @"gid",
                                  [NSNumber numberWithFloat:tileRect.origin.x], @"x",
                                  [NSNumber numberWithFloat:tileRect.origin.y], @"y",
                                  [NSValue valueWithCGPoint:tilePos],@"tilePos",
                                  nil];
        [gids addObject:tileDict]; //6
        
    }
    
    [gids removeObjectAtIndex:4];
    [gids insertObject:[gids objectAtIndex:2] atIndex:6];
    [gids removeObjectAtIndex:2];
    [gids exchangeObjectAtIndex:4 withObjectAtIndex:6];
    [gids exchangeObjectAtIndex:0 withObjectAtIndex:4]; //7
    /*
     for (NSDictionary *d in gids) {
     NSLog(@"%@", d);
     } //8 */
    
    return (NSArray *)gids;
}
-(void)checkForAndResolveCollisions:(Player *)p {
    
    NSArray *tiles = [self getSurroundingTilesAtPosition:p.position forLayer:walls ]; //1
    if (gameOver) {
        return;
    }
    p.onGround = NO; //////Here
    
    for (NSDictionary *dic in tiles) {
        CGRect pRect = [p collisionBoundingBox]; //3
        
        int gid = [[dic objectForKey:@"gid"] intValue]; //4
        if (gid) {
            CGRect tileRect = CGRectMake([[dic objectForKey:@"x"] floatValue], [[dic objectForKey:@"y"] floatValue], map.tileSize.width, map.tileSize.height); //5
            if (CGRectIntersectsRect(pRect, tileRect)) {
                CGRect intersection = CGRectIntersection(pRect, tileRect);
                int tileIndx = [tiles indexOfObject:dic];
                
                if (tileIndx == 0) {
                    //tile is directly below player
                    p.desiredPosition = ccp(p.desiredPosition.x, p.desiredPosition.y + intersection.size.height);
                    p.velocity = ccp(p.velocity.x, 0.0); //////Here
                    p.onGround = YES; //////Here
                } else if (tileIndx == 1) {
                    //tile is directly above player
                    p.desiredPosition = ccp(p.desiredPosition.x, p.desiredPosition.y - intersection.size.height);
                    p.velocity = ccp(p.velocity.x, 0.0); //////Here
                } else if (tileIndx == 2) {
                    //tile is left of player
                    p.desiredPosition = ccp(p.desiredPosition.x + intersection.size.width, p.desiredPosition.y);
                } else if (tileIndx == 3) {
                    //tile is right of player
                    p.desiredPosition = ccp(p.desiredPosition.x - intersection.size.width, p.desiredPosition.y);
                } else {
                    if (intersection.size.width > intersection.size.height) {
                        //tile is diagonal, but resolving collision vertially
                        p.velocity = ccp(p.velocity.x, 0.0); //////Here
                        float resolutionHeight;
                        if (tileIndx > 5) {
                            resolutionHeight = intersection.size.height;
                            p.onGround = YES; //////Here
                        } else {
                            resolutionHeight = -intersection.size.height;
                        }
                        p.desiredPosition = ccp(p.desiredPosition.x, p.desiredPosition.y + resolutionHeight);
                        
                    } else {
                        float resolutionWidth;
                        if (tileIndx == 6 || tileIndx == 4) {
                            resolutionWidth = intersection.size.width;
                        } else {
                            resolutionWidth = -intersection.size.width;
                        }
                        p.desiredPosition = ccp(p.desiredPosition.x + resolutionWidth, p.desiredPosition.y);
                    }
                }
            }
        }
    }
    p.position = p.desiredPosition; //8
}

-(void)setViewpointCenter:(CGPoint) position {
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    int x = MAX(position.x, winSize.width / 2);
    int y = MAX(position.y, winSize.height / 2);
    x = MIN(x, (map.mapSize.width * map.tileSize.width)
            - winSize.width / 2);
    y = MIN(y, (map.mapSize.height * map.tileSize.height)
            - winSize.height/2);
    CGPoint actualPosition = ccp(x, y);
    
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    map.position = viewPoint;
}
-(void)handleHazardCollisions:(Player *)p {
    NSArray *tiles = [self getSurroundingTilesAtPosition:p.position forLayer:hazards ];
    for (NSDictionary *dic in tiles) {
        CGRect tileRect = CGRectMake([[dic objectForKey:@"x"] floatValue], [[dic objectForKey:@"y"] floatValue], map.tileSize.width, map.tileSize.height);
        CGRect pRect = [p collisionBoundingBox];
        
        if ([[dic objectForKey:@"gid"] intValue] && CGRectIntersectsRect(pRect, tileRect)) {
            [self gameOver];
        }
    }
}
-(void)gameOver {
	gameOver = YES;
    
    gestureRecognizer.enabled = NO;
    gestureRecognizer2.enabled = NO;

    
	if (won) {
		[[CCDirector sharedDirector] replaceScene:[Level5DoneLayer scene]];
	} else {
        [[CCDirector sharedDirector] replaceScene:[Level5DieLayer scene]];
		    }
}
-(void)checkForWin {
    if (player.position.x > 3250.0) {
        won = TRUE;
        [self gameOver];
    }
}
-(void) projectileCheck
{
    if (player.activebullet){
        
        CGPoint bulletvelocity = ccp(7.0, 0.0);
        CGPoint placehold = bullet.position;
        bullet.position = ccpAdd(bulletvelocity, placehold);
        timeInterval = [self.start timeIntervalSinceNow];
        
        if (timeInterval < (-1.75) + (player.enemiesKilled * .25))
        {
            player.activebullet=FALSE;
            bullet.zOrder = 0;
            bullet.position = ccp(0,0);
        }
        player.shoot = NO;
        
    }
    else if (player.shoot && !(player.activebullet))
    {
        player.activebullet = TRUE;
        player.shoot = NO;
        bullet.position = player.position;
        bullet.zOrder = 20;
        CGPoint bulletvelocity = ccp(7.0, 0.0);
        CGPoint placehold = bullet.position;
        bullet.position = ccpAdd(bulletvelocity, placehold);
        self.start = [NSDate date];
        
        
        
    }
    
    
}
-(void) moveAliens
{
    if(alien1here)
    {
        if (alien1.position.x < 400)
        {
            velocity1 = ccp(3.0, 0);
            
        }
    }
    
    if(alien2here)
    {
        if (alien2.position.x < 1200)
        {
            velocity2 = ccp(3.0, 0);
            
        }
    }
    if(alien3here)
    {
        if (alien3.position.x < 2000)
        {
            velocity3 = ccp(3.0, 0);
            
        }
    }
    if(alien4here)
    {
        if (alien4.position.x < 2850)
        {
            velocity4 = ccp(3.0, 0);
            
            
        }
    }
    if(alien1here)
    {
        if (alien1.position.x > 600)
        {
            velocity1 = ccp(-3.0, 0);
            
        }
    }
    if(alien2here)
    {
        if (alien2.position.x > 1350)
        {
            velocity2 = ccp(-3.0, 0);
            
        }
    }
    if(alien3here)
    {
        if (alien3.position.x > 2200)
        {
            velocity3 = ccp(-3.0, 0);
            
        }
    }
    if(alien4here)
        
    {
        if (alien4.position.x > 3000)
        {
            velocity4 = ccp(-3.0, 0);
            
        }
    }
    
    if (alien1here)
    {
        alien1.position = ccpAdd(alien1.position, velocity1);
    }
    if (alien2here)
    {
        alien2.position = ccpAdd(alien2.position, velocity2);
    }
    if (alien3here)
    {
        alien3.position = ccpAdd(alien3.position, velocity3);
    }
    if (alien4here)
    {
        alien4.position = ccpAdd(alien4.position, velocity4);
    }
   }
-(void) deathCheck
{
    if (alien1here)
        
    {
        if (CGRectIntersectsRect(bullet.boundingBox, alien1.boundingBox))
        {
            [alien1 removeFromParentAndCleanup:YES];
            player.enemiesKilled ++;
            alien1here = FALSE;
            player.activebullet=FALSE;
            bullet.zOrder = 0;
            bullet.position = ccp(0,0);
            player.scale = .2 - (player.enemiesKilled * .03);
            [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.2 + (0.2*player.enemiesKilled)];
        }
        
    }
    if(alien2here)
    {
        if (CGRectIntersectsRect(bullet.boundingBox, alien2.boundingBox))
        {
            [alien2 removeFromParentAndCleanup:YES];
            player.enemiesKilled ++;
            alien2here = FALSE;
            player.activebullet=FALSE;
            bullet.zOrder = 0;
            bullet.position = ccp(0,0);
            player.scale = .2 - (player.enemiesKilled * .03);
            [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.2 + (0.2*player.enemiesKilled)];
        }
    }
    if(alien3here)
    {
        if (CGRectIntersectsRect(bullet.boundingBox, alien3.boundingBox))
        {
            [alien3 removeFromParentAndCleanup:YES];
            player.enemiesKilled ++;
            alien3here = FALSE;
            player.activebullet=FALSE;
            bullet.zOrder = 0;
            bullet.position = ccp(0,0);
            player.scale = .2 - (player.enemiesKilled * .03);
            [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.2 + (0.2*player.enemiesKilled)];
        }
    }
    if(alien4here)
    {
        if (CGRectIntersectsRect(bullet.boundingBox, alien4.boundingBox))
        {
            [alien4 removeFromParentAndCleanup:YES];
            player.enemiesKilled ++;
            alien4here = FALSE;
            player.activebullet=FALSE;
            bullet.zOrder = 0;
            bullet.position = ccp(0,0);
            player.scale = .2 - (player.enemiesKilled * .03);
            [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.2 + (0.2*player.enemiesKilled)];
            
            
        }
    }
        if (alien1here)
    {
        if (CGRectIntersectsRect(player.boundingBox, alien1.boundingBox))
        {
            
            [self gameOver];
            
        }
    }
    if(alien2here)
    {
        
        
        if (CGRectIntersectsRect(player.boundingBox, alien2.boundingBox))
        {
            
            [self gameOver];
        }
    }
    if(alien3here)
    {
        if (CGRectIntersectsRect(player.boundingBox, alien3.boundingBox))
        {
            
            [self gameOver];
        }
    }
    if (alien4here)
    {
        
        
        if (CGRectIntersectsRect(player.boundingBox, alien4.boundingBox))
        {
            
            [self gameOver];
        }
    }
   }





@end