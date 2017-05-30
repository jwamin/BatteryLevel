//
//  InterfaceController.m
//  Battery Level WatchKit Extension
//
//  Created by Joss Manger on 5/24/17.
//  Copyright © 2017 Joss Manger. All rights reserved.
//

#import "InterfaceController.h"
#import "ExtensionDelegate.h"
#import "BatteryLevel-Swift.h"

@interface InterfaceController ()
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *label;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *deviceNameLabel;
@property ExtensionDelegate *delegate;
@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    _delegate = (ExtensionDelegate*)[[WKExtension sharedExtension] delegate];
    // Configure interface objects here.
    [self setLabel];
}

 -(void)setLabel{
     //NSString *bkupstr = @"unset";
     NSString *setstr = [[[_delegate.helper levelFloat]stringValue] stringByAppendingString:@"%"];
     NSString *devicestr = [_delegate.helper name];
     [_label setText:setstr];
     [_deviceNameLabel setText:devicestr];
     NSLog(@"did set label to %@",setstr);

 }

- (IBAction)reload {
    
}

-(void)didAppear{
    NSLog(@"did appear");
    [self setLabel];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}


@end



