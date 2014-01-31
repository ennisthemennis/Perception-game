//
//  AppDelegate.h
//  SuperKoalio
//
//  Created by Jacob Gundersen on 6/4/12.


#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow *window_;
	UINavigationController *navController_;

	CCDirectorIOS	*director_;							// weak ref
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;
-(NSUInteger)supportedInterfaceOrientations;
- (NSUInteger)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window;
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
-(void) applicationWillResignActive:(UIApplication *)application;
-(void) applicationDidBecomeActive:(UIApplication *)application;
-(void) applicationDidEnterBackground:(UIApplication*)application;
-(void) applicationWillEnterForeground:(UIApplication*)application;
- (void)applicationWillTerminate:(UIApplication *)application;
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application;
-(void) applicationSignificantTimeChange:(UIApplication *)application;
- (void) dealloc;

@end
