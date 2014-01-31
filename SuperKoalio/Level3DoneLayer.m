#import "GameLevelLayer3.h"
#import "CCMenu.h"
#import "SimpleAudioEngine.h"
#import "Level3DoneLayer.h"
#import "LevelSelectLayer.h"
#import "GameLevelLayer4.h"

@implementation Level3DoneLayer
+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
    
	// 'layer' is an autorelease object.
	Level3DoneLayer *layer = [Level3DoneLayer node];
    
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
        CCSprite * bg = [CCSprite spriteWithFile:@"background complete.png"];
        [self resizeSprite:bg toWidth:winSize.width toHeight:winSize.height];
        [bg setPosition:ccp((winSize.width/2),(winSize.height/2))];
        [self addChild:bg];
        [self setUpMenus];
    }
    return self;
}
-(void) setUpMenus
{
    
    
    CCMenuItemImage *menuItem1 = [CCMenuItemImage itemWithNormalImage:@"replay.jpg"
                                                        selectedImage: @"replay.jpg"
                                                               target:self
                                                             selector:@selector(doThis:)];
    
    
    CCMenuItemImage *menuItem2 = [CCMenuItemImage itemWithNormalImage:@"level select.jpg"
                                                        selectedImage: @"level select.jpg"
                                                               target:self
                                                             selector:@selector(doThis2:)];
    CCMenuItemImage *menuItem3 = [CCMenuItemImage itemWithNormalImage:@"continue.jpg"
                                                        selectedImage: @"continue.jpg"
                                                               target:self
                                                             selector:@selector(doThis3:)];
    
    self.myMenu = [CCMenu menuWithItems:menuItem1, menuItem2, menuItem3, nil];
    menuItem1.scale = .5;
    menuItem2.scale = .5;
    menuItem3.scale = .5;
    
    menuItem1.position = ccp(-150, -50);
    menuItem2.position = ccp(0, -50);
    menuItem3.position = ccp(150, -50);
    
    
    
    [self addChild:self.myMenu];
}
-(void) doThis: (CCMenuItem  *) menuItem
{
    
    
    
    [[CCDirector sharedDirector] replaceScene: [GameLevelLayer3 scene]];
    
}
-(void) doThis2: (CCMenuItem *) menuItem
{
    [[CCDirector sharedDirector] replaceScene: [LevelSelectLayer scene]];
}
-(void) doThis3: (CCMenuItem *) menuItem
{
    [[CCDirector sharedDirector] replaceScene: [GameLevelLayer4 scene]];
}
@end