//
//  AppDelegate.m
//  ExpenseReport
//
//  Created by Fu Steven on 6/25/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "AppDelegate.h"

#import "LoginViewController.h"
#import "ExpenseReportsMain.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //[[AppSettings sharedSettings] load_init_data];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if ([AppSettings sharedSettings].isLogin){
        [self startApp];
    }else{
        [self startLogin];
    }
    
   
    [self.window makeKeyAndVisible];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startApp) name:EVENT_LOGIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startLogin) name:EVENT_LOGOUT object:nil];
    return YES;
}

-(void)startApp{
    /*
    UIViewController *viewController1, *viewController2;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        viewController1 = [[FirstViewController alloc] initWithNibName:@"FirstViewController_iPhone" bundle:nil];
        viewController2 = [[SecondViewController alloc] initWithNibName:@"SecondViewController_iPhone" bundle:nil];
    } else {
        viewController1 = [[FirstViewController alloc] initWithNibName:@"FirstViewController_iPad" bundle:nil];
        viewController2 = [[SecondViewController alloc] initWithNibName:@"SecondViewController_iPad" bundle:nil];
    }
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[viewController1, viewController2];
     */
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [[[ExpenseReportsMain alloc] init] createControllers];
    self.window.rootViewController = self.tabBarController;
}

-(void)startLogin{
    LoginViewController *vc =[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = controller;
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
