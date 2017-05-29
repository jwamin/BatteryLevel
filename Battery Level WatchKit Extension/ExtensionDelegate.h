//
//  ExtensionDelegate.h
//  Battery Level WatchKit Extension
//
//  Created by Joss Manger on 5/24/17.
//  Copyright © 2017 Joss Manger. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <WatchConnectivity/WatchConnectivity.h>
#import "BatteryLevel-Swift.h"
#import "InterfaceController.h"

@interface ExtensionDelegate : NSObject <WKExtensionDelegate, WCSessionDelegate, BatteryLevelHelperDelegate>

@property WCSession *session;
@property BatteryLevelHelper *helper;
@property InterfaceController *mainView;
@end
