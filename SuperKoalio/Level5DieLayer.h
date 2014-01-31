//
//  LevelSelectLayer.h
//  Perception
//
//  Created by Michaela Ennis on 1/30/14.
//  Copyright (c) 2014 Interrobang Software LLC. All rights reserved.
//
#import "CCLayer.h"
#import "CCMenu.h"

@interface Level5DieLayer : CCLayer
{
    
    
    
}
@property(readwrite, retain) CCMenu * myMenu;
-(id) init;
+(id) scene;
-(void) setUpMenus;
-(void) doThis: (CCMenuItem  *) menuItem;
-(void) doThis2: (CCMenuItem  *) menuItem;

-(void)resizeSprite:(CCSprite*)sprite toWidth:(float)width toHeight:(float)height;

@end