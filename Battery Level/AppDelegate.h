//
//  AppDelegate.h
//  Battery Level
//
//  Created by Joss Manger on 5/24/17.
//  Copyright © 2017 Joss Manger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WatchConnectivity/WatchConnectivity.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,WCSessionDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

