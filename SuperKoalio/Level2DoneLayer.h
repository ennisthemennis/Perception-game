//
//  LevelSelectLayer.h
//  Perception
//
//  Created by Michaela Ennis on 1/30/14.
//  Copyright (c) 2014 Interrobang Software LLC. All rights reserved.
//
#import "CCLayer.h"
#import "CCMenu.h"

@interface Level2DoneLayer : CCLayer
{
    
    
    
}
@property(readwrite, retain) CCMenu * myMenu;
-(id) init;
+(id) scene;
-(void) setUpMenus;
-(void) doThis: (CCMenuItem  *) menuItem;
-(void) doThis2: (CCMenuItem  *) menuItem;
-(void) doThis3: (CCMenuItem  *) menuItem;



@end