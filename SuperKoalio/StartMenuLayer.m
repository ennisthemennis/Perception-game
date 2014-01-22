//
//  StartMenuLayer.m
//  SuperKoalio
//
//  Created by Michaela Ennis on 1/22/14.
//  Copyright (c) 2014 Interrobang Software LLC. All rights reserved.
//

#import "StartMenuLayer.h"
#import "GameLevelLayer.h"
#import "CCMenu.h"
#import "SimpleAudioEngine.h"
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
        
        CCSprite * bg = [CCSprite spriteWithFile:@"Title card?.png"];
        [self resizeSprite:bg toWidth:480 toHeight:320];
        [bg setPosition:ccp(240,160)];
        [self addChild:bg];
        [self setUpMenus];
    }
    return self;
}
-(void) setUpMenus
{
    CCMenuItemImage *menuItem1 = [CCMenuItemImage itemWithNormalImage:@"play button?.png"
                                                        selectedImage: @"play button?.png"
                                                               target:self
                                                             selector:@selector(doThis:)];
    self.myMenu = [CCMenu menuWithItems:menuItem1, nil];
    self.myMenu.position = ccp(240,80);
    
    
    [self addChild:self.myMenu];
}
-(void) doThis: (CCMenuItem  *) menuItem
{
    
    
   
        [[CCDirector sharedDirector] replaceScene: [GameLevelLayer scene]];
    
}

@end
