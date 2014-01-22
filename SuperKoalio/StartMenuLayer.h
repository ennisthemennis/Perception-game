//
//  StartMenuLayer.h
//  SuperKoalio
//
//  Created by Michaela Ennis on 1/22/14.
//  Copyright (c) 2014 Interrobang Software LLC. All rights reserved.
//

#import "CCLayer.h"
#import "CCMenu.h"

@interface StartMenuLayer : CCLayer
{
    
    
    
}
@property(readwrite, retain) CCMenu * myMenu;
-(id) init;
+(id) scene;
-(void) setUpMenus;
-(void) doThis: (CCMenuItem  *) menuItem;


@end