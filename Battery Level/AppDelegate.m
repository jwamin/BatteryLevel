//
//  AppDelegate.m
//  Battery Level
//
//  Created by Joss Manger on 5/24/17.
//  Copyright © 2017 Joss Manger. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    float level = [[UIDevice currentDevice]batteryLevel];
    NSLog(@"%f",level);
    if([WCSession isSupported]){
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
        NSLog(@"%ld",(long)[session activationState]);
    }
    return YES;
}

-(void)session:(WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(NSError *)error{
    
    NSLog(@"eh? %ld",(long)activationState);
//    NSDictionary *dict = @{@"hello":@"hello, if you are reading this message, it worked"};
//    [session sendMessage:dict replyHandler:nil errorHandler:nil];
    
}

//Listen for changes to battery charging state, update complication


-(void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message replyHandler:(void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler{
    NSLog(@"%@",message);
    
    if([[message objectForKey:@"request"] isEqual:@"currentBatteryLevelandStatus"]){
        float batteryLevel = [[UIDevice currentDevice]batteryLevel];
        //NSInteger state = *(NSInteger*)[[UIDevice currentDevice]batteryState];
        long state = (long)[[UIDevice currentDevice]batteryState];
        NSNumber *batteryLevelfloat = [NSNumber numberWithFloat:batteryLevel];
        NSNumber *statusEnum = [NSNumber numberWithLong:state];
        NSDate *now = [[NSDate alloc]init];
        NSDictionary *dict = @{@"currentLevelFloat":batteryLevelfloat,@"batteryStatus":statusEnum,@"currentDate":now,@"deviceName":[[UIDevice currentDevice]name]};
        [session sendMessage:dict replyHandler:nil errorHandler:nil];
        replyHandler(dict);
    } else if([[message objectForKey:@"request"] isEqual:@"dummyBatteryLevelandStatus"]){
        float batteryLevel = 76.0;
        long state = 2;
        NSNumber *batteryLevelfloat = [NSNumber numberWithFloat:batteryLevel];
        NSNumber *statusEnum = [NSNumber numberWithLong:state];
        NSDate *now = [[NSDate alloc]init];
        NSDictionary *dict = @{@"currentLevelFloat":batteryLevelfloat,@"batteryStatus":statusEnum,@"currentDate":now,@"deviceName":[[UIDevice currentDevice]name]};
        [session sendMessage:dict replyHandler:nil errorHandler:nil];
        replyHandler(dict);
    }
    
    
    
}

-(void)sessionDidBecomeInactive:(WCSession *)session{
    NSLog(@"inactive");
}

-(void)sessionDidDeactivate:(WCSession *)session{
    NSLog(@"deactivates");
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
