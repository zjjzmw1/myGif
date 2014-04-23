//
//  AppDelegate.m
//  myGif
//
//  Created by Buddy on 17/4/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "SJBMyCollectViewController.h"
#import "AGViewController.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [AVOSCloud setApplicationId:kAVOSId clientKey:kAVOSKey];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];///跟踪应用的打开情况。
    
    ///获取在后台上次的数据。
    AVQuery *query = [AVQuery queryWithClassName:@"gifList"];
    
    NSMutableArray *avosArray = [NSMutableArray array];
    int count = [[query findObjects]count];
    for (int i =0; i<count; ++i) {
        [avosArray addObject:[[[query findObjects]objectAtIndex:i]objectForKey:@"url"]];
    }
    [kUserDefault setObject:avosArray forKey:@"avosArray"];
    [kUserDefault synchronize];
    
    
    
    [MobClick startWithAppkey:kUMappKey];
    [MobClick updateOnlineConfig];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    SJBMyCollectViewController *myCollectVC = [[SJBMyCollectViewController alloc]init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:myCollectVC];
    self.window.rootViewController = navi;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
