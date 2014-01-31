//
//  StartMenuLayer.m
//  SuperKoalio
//
//  Created by Michaela Ennis on 1/22/14.
//  Copyright (c) 2014 Interrobang Software LLC. All rights reserved.
//

#import "StartMenuLayer.h"
#import "LevelSelectLayer.h"
#import "CCMenu.h"
#import "SimpleAudioEngine.h"
#import "GameLevelLayer.h"

@implementation StartMenuLayer
+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
    
	// 'layer' is an autorelease object.
	StartMenuLayer *layer = [StartMenuLayer node];
    
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
        CCSprite * bg = [CCSprite spriteWithFile:@"Title card?.png"];
        [self resizeSprite:bg toWidth:winSize.width toHeight:winSize.height];
        [bg setPosition:ccp((winSize.width/2),(winSize.height/2))];
        [self addChild:bg];
        [self setUpMenus];
    }
    return self;
}
-(void) setUpMenus
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];

    CCMenuItemImage *menuItem1 = [CCMenuItemImage itemWithNormalImage:@"play button?.png"
                                                        selectedImage: @"play button?.png"
                                                               target:self
                                                             selector:@selector(doThis:)];
    self.myMenu = [CCMenu menuWithItems:menuItem1, nil];
    self.myMenu.position = ccp(winSize.width/2,80);
    
    
    [self addChild:self.myMenu];
}
-(void) doThis: (CCMenuItem  *) menuItem
{
    
    
   
        [[CCDirector sharedDirector] replaceScene: [LevelSelectLayer scene]];
    
}

@end
