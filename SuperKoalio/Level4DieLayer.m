#import "GameLevelLayer4.h"
#import "CCMenu.h"
#import "SimpleAudioEngine.h"
#import "Level4DieLayer.h"
#import "LevelSelectLayer.h"

@implementation Level4DieLayer
+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
    
	// 'layer' is an autorelease object.
	Level4DieLayer *layer = [Level4DieLayer node];
    
	// add layer as a child to scene
	[scene addChild: layer];
    
	// return the scene
	return scene;
}
-(void)resizeSprite:(CCSprite*)sprite toWidth:(float)width toHeight:(float)height {
    sprite.scaleX = width / sprite.contentSize.width;
    sprite.scaleY = height / sprite.contentSize.height;
}
-(id) init
{
    if( (self=[super init] )) {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"menu?.wav"];
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCSprite * bg = [CCSprite spriteWithFile:@"background die.png"];
        [self resizeSprite:bg toWidth:winSize.width toHeight:winSize.height];
        [bg setPosition:ccp((winSize.width/2),(winSize.height/2))];
        [self addChild:bg];
        [self setUpMenus];
    }
    return self;
}
-(void) setUpMenus
{
    
    
    CCMenuItemImage *menuItem1 = [CCMenuItemImage itemWithNormalImage:@"retry.jpg"
                                                        selectedImage: @"retry.jpg"
                                                               target:self
                                                             selector:@selector(doThis:)];
    
    
    CCMenuItemImage *menuItem2 = [CCMenuItemImage itemWithNormalImage:@"level select.jpg"
                                                        selectedImage: @"level select.jpg"
                                                               target:self
                                                             selector:@selector(doThis2:)];
    
    self.myMenu = [CCMenu menuWithItems:menuItem1, menuItem2, nil];
    menuItem1.scale = .4;
    menuItem2.scale = .4;
    
    menuItem1.position = ccp(-100, -50);
    menuItem2.position = ccp(100, -50);
    
    
    
    [self addChild:self.myMenu];
}
-(void) doThis: (CCMenuItem  *) menuItem
{
    
    
    
    [[CCDirector sharedDirector] replaceScene: [GameLevelLayer4 scene]];
    
}
-(void) doThis2: (CCMenuItem *) menuItem
{
    [[CCDirector sharedDirector] replaceScene: [LevelSelectLayer scene]];
}

@end