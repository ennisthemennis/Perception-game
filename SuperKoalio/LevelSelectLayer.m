#import "StartMenuLayer.h"
#import "GameLevelLayer.h"
#import "CCMenu.h"
#import "SimpleAudioEngine.h"
#import "GameLevelLayer3.h"
#import "GameLevelLayer4.h"
#import "GameLevelLayer5.h"
#import "LevelSelectLayer.h"
#import "GameLevelLayer2.h"
@implementation LevelSelectLayer
+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
    
	// 'layer' is an autorelease object.
	LevelSelectLayer *layer = [LevelSelectLayer node];
    
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
        CCSprite * bg = [CCSprite spriteWithFile:@"background select.png"];
        [self resizeSprite:bg toWidth:winSize.width toHeight:winSize.height];
        [bg setPosition:ccp((winSize.width/2),(winSize.height/2))];
        [self addChild:bg];
        [self setUpMenus];
    }
    return self;
}
-(void) setUpMenus
{
    BOOL check1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"level1complete"];
    BOOL check2 = [[NSUserDefaults standardUserDefaults] objectForKey:@"level2complete"];
    BOOL check3 = [[NSUserDefaults standardUserDefaults] objectForKey:@"level3complete"];
    BOOL check4 = [[NSUserDefaults standardUserDefaults] objectForKey:@"level4complete"];
    
    CCMenuItemImage *menuItem1 = [CCMenuItemImage itemWithNormalImage:@"level 1 select.jpg"
                                                        selectedImage: @"level 1 select.jpg"
                                                               target:self
                                                             selector:@selector(doThis:)];
    CCMenuItemImage *menuItem2;
    CCMenuItemImage *menuItem3;
    CCMenuItemImage *menuItem4;
    CCMenuItemImage *menuItem5;
  
    if (check1)
    {
    menuItem2 = [CCMenuItemImage itemWithNormalImage:@"level 2 select.jpg"
                                                        selectedImage: @"level 2 select.jpg"
                                                               target:self
                                                             selector:@selector(doThis2:)];
    }
    else
    {
        menuItem2 = [CCMenuItemImage itemWithNormalImage:@"level 2 select locked.jpg"
                                                            selectedImage: @"level 2 select locked.jpg"
                                                                   target:self
                                                                 selector:@selector(doNothing:)];
    }
    
    if (check2)
    {
     menuItem3 = [CCMenuItemImage itemWithNormalImage:@"level 3 select.jpg"
                                                        selectedImage: @"level 3 select.jpg"
                                                               target:self
                                                             selector:@selector(doThis3:)];
    }
    
    else
        
    {
        menuItem3 = [CCMenuItemImage itemWithNormalImage:@"level 3 select locked.jpg"
                                                            selectedImage: @"level 3 select locked.jpg"
                                                                   target:self
                                                                 selector:@selector(doNothing:)];
    }
    if(check3)
    {
    
    menuItem4 = [CCMenuItemImage itemWithNormalImage:@"level 4 select.jpg"
                                                        selectedImage: @"level 4 select.jpg"
                                                               target:self
                                                             selector:@selector(doThis4:)];
    }
    else
    {
        menuItem4 = [CCMenuItemImage itemWithNormalImage:@"level 4 select locked.jpg"
                                                            selectedImage: @"level 4 select locked.jpg"
                                                                   target:self
                                                                 selector:@selector(doNothing:)];

    }
    if(check4)
    {
        menuItem5 = [CCMenuItemImage itemWithNormalImage:@"level 5 select.jpg"
                                                        selectedImage: @"level 5 select.jpg"
                                                               target:self
                                                             selector:@selector(doThis5:)];
    }
    else
    {
        menuItem5 = [CCMenuItemImage itemWithNormalImage:@"level 5 select locked.jpg"
                                                            selectedImage: @"level 5 select locked.jpg"
                                                                   target:self
                                                selector:@selector(doNothing:)];
    }
    self.myMenu = [CCMenu menuWithItems:menuItem1, menuItem2, menuItem3, menuItem4, menuItem5, nil];
    menuItem1.scale = .4;
    menuItem2.scale = .4;
    menuItem3.scale = .4;
    menuItem4.scale = .4;
    menuItem5.scale = .4;
    menuItem1.position = ccp(-150, 75);
    menuItem2.position = ccp(0, 75);
    menuItem3.position = ccp(150, 75);
    menuItem4.position = ccp(-75,-50);
    menuItem5.position = ccp(75, -50);
    
    
    [self addChild:self.myMenu];
}
-(void) doThis: (CCMenuItem  *) menuItem
{
    
    
    
    [[CCDirector sharedDirector] replaceScene: [GameLevelLayer scene]];
    
}
-(void) doThis2: (CCMenuItem *) menuItem
{
    [[CCDirector sharedDirector] replaceScene: [GameLevelLayer2 scene]];
}
-(void) doThis3: (CCMenuItem  *) menuItem
{
    
    
    
    [[CCDirector sharedDirector] replaceScene: [GameLevelLayer3 scene]];
    
}
-(void) doThis4: (CCMenuItem *) menuItem
{
    [[CCDirector sharedDirector] replaceScene: [GameLevelLayer4 scene]];
}
-(void) doThis5: (CCMenuItem *) menuItem
{
    [[CCDirector sharedDirector] replaceScene: [GameLevelLayer5 scene]];
}
-(void) doNothing: (CCMenuItem *) menuItem
{
    [[CCDirector sharedDirector] replaceScene: [LevelSelectLayer scene]];
}

@end

