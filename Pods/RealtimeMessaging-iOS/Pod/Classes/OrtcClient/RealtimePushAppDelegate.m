//
//  AppDelegate.m
//  OrtcClient
//
//  Created by iOSdev on 9/20/13.
//  Copyright (c) 2013 Realtime.co All rights reserved.
//

#import "RealtimePushAppDelegate.h"
#import "OrtcClient.h"

@implementation RealtimePushAppDelegate
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    } else {
        [application registerForRemoteNotificationTypes: UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge];

    }
#else
    [application registerForRemoteNotificationTypes: UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge];
#endif
    
    return YES;
}
#pragma clang diagnostic pop

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    
    NSString* newToken = [deviceToken description];
	newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"\n\n - didRegisterForRemoteNotificationsWithDeviceToken:\n%@\n", deviceToken);
    
    [OrtcClient performSelector:@selector(setDEVICE_TOKEN:) withObject:[[NSString alloc] initWithString:newToken]];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [self application:application didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	
	//NSLog(@"\n\n - didReceiveRemoteNotification:\n%@\n", userInfo);
	
    // Handle the notification here
    //clear notifications
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    // set application badge number
    //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    
	/*
	if (application.applicationState != UIApplicationStateActive) {
		// app was just brought from background to foreground
	}
	*/
	
	// Write to NSUserDefaults
	if ([userInfo objectForKey:@"C"] && [userInfo objectForKey:@"M"] && [userInfo objectForKey:@"A"]) {
		
		NSString *ortcMessage = [NSString stringWithFormat:@"a[\"{\\\"ch\\\":\\\"%@\\\",\\\"m\\\":\\\"%@\\\"}\"]", [userInfo objectForKey:@"C"], [userInfo objectForKey:@"M"]];
		
		NSMutableDictionary *notificationsDict  = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:NOTIFICATIONS_KEY]];
		NSMutableArray *notificationsArray = [[NSMutableArray alloc] initWithArray:[notificationsDict objectForKey:[userInfo objectForKey:@"A"]]];
		[notificationsArray addObject:ortcMessage];
		[notificationsDict setObject:notificationsArray forKey:[userInfo objectForKey:@"A"]];
		
		[[NSUserDefaults standardUserDefaults] setObject:notificationsDict forKey:NOTIFICATIONS_KEY];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:@"ApnsNotification" object:nil userInfo:userInfo];
	}
}


- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to register with error : %@", error);
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ApnsRegisterError" object:nil userInfo:[NSDictionary dictionaryWithObject:error forKey:@"ApnsRegisterError"]];
}


@end
