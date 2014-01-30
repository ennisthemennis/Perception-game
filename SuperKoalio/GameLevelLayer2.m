//
//  GameLevelLayer.m
//  SuperKoalio
//
//  Created by Jacob Gundersen on 6/4/12.


#import "GameLevelLayer2.h"
#import "GameLevelLayer.h"
#import "Player.h"
#import "SimpleAudioEngine.h"
#import "StartMenuLayer.h"



@interface GameLevelLayer2()
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
    
 
    CCSprite* instructions;
    BOOL start;
    
    
}
@end
@implementation GameLevelLayer2
@synthesize start = _start;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLevelLayer2 *layer = [GameLevelLayer2 node];
	
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
        
        map = [[CCTMXTiledMap alloc] initWithTMXFile:@"level2.tmx"];
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
        instructions = [CCSprite spriteWithFile:@"rounded-blue-sq-2.png" ];
        instructions.position = ccp(winSize.width/2, 200);
        instructions.scale  = .1;
        [map addChild:instructions z:5];
        
        
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
    
    [player update:dt];
    
    [self projectileCheck];
    
    
    [self checkForAndResolveCollisions:player];
    [self setViewpointCenter:player.position];
    [self handleHazardCollisions:player];
    [self checkForWin];
    if(!start)
    {
        sleep(2);
        start = TRUE;
    }
    
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
            [self gameOver:0];
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
            [self gameOver:0];
        }
    }
}
-(void)gameOver:(BOOL)won {
	gameOver = YES;
    
    gestureRecognizer.enabled = NO;
    gestureRecognizer2.enabled = NO;
	NSString *gameText;
    
	if (won) {
		gameText = @"You Won!";
	} else {
		gameText = @"You have Died!";
	}
    
    
    CCLabelTTF *diedLabel = [[CCLabelTTF alloc] initWithString:gameText fontName:@"Helvetica" fontSize:40];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    diedLabel.position = ccp(winSize.width/2, 200);
    diedLabel.color = ccc3(0, 0, 200);
    CCMoveBy *slideIn = [[CCMoveBy alloc] initWithDuration:1.0 position:ccp(0, 250)];
    CCMenuItemImage *replay = [[CCMenuItemImage alloc] initWithNormalImage:@"replay.png" selectedImage:@"replay.png" disabledImage:@"replay.png" block:^(id sender) {
        [[CCDirector sharedDirector] replaceScene:[GameLevelLayer scene]];
    }];
    
    NSArray *menuItems = [NSArray arrayWithObject:replay];
    CCMenu *menu = [[CCMenu alloc] initWithArray:menuItems];
    menu.position = ccp(winSize.width/2, -100);
    
    [self addChild:menu z:20];
    [self addChild:diedLabel z:20];
    
    [menu runAction:slideIn];
}
-(void)checkForWin {
    if (player.position.x > 1650.0) {
        [self gameOver:1];
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





@end