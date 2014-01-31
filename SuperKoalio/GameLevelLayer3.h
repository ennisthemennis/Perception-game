//
//  GameLevelLayer.h
//  SuperKoalio
//
//  Created by Jacob Gundersen on 6/4/12.

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameLevelLayer3 : CCLayer {
    CCAction *run;
    NSMutableArray *runningFrames;
    CCAction *shake;
    NSMutableArray *shakingFrames;
   
}
@property(nonatomic,retain) NSDate *start;

+(CCScene *) scene;

@end

