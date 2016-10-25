//
//  AppDelegate.m
//  CheerUp
//
//  Created by Dipen Sekhsaria on 25/10/16.
//  Copyright © 2016 stardeep. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [self enablePushNotification];
    
    //Check if App starts because of push notification
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]!=nil)
    {
        
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// Add or incorporate this function in your app delegate file
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
    NSLog(@"Succeeded registering for push notifications. Device token: %@", devToken);
    
    NSString *tokenStr = [devToken description];
    tokenStr = [tokenStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
    tokenStr = [tokenStr stringByReplacingOccurrencesOfString:@">" withString:@""];
    tokenStr = [tokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [[NSUserDefaults standardUserDefaults] setValue:tokenStr forKey:kDeviceToken];
    
}

//Add or incorporate function to display for simulator support
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error
{
    NSLog(@"Failed to register with error: %@", error);
    
}

// Add or incorporate this function in your app delegate file
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)launchOptions
{
    //NSLog(@"Receiving notification, app is running");
    
}


#pragma mark - PUSH NOTIFICATION

- (void)enablePushNotification {
    
    UIApplication * app = [UIApplication sharedApplication];
    
    if([app respondsToSelector:@selector(registerForRemoteNotifications)])
    {
        UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings * settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [app registerUserNotificationSettings: settings];
        [app registerForRemoteNotifications];
    }
    
}

@end
