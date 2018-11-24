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
    [_label setText:@""];
    [_deviceNameLabel setText:@""];
    // Configure interface objects here.
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(setLabel) name:@"gotData" object:nil];
    
}

 -(void)setLabel{
     
     //ok this processing is in the Interface controller?
     NSNumber *percentNumber = [NSNumber numberWithInteger:((int)roundf([[_delegate.helper levelFloat]floatValue] * 100))];
     NSLog(@"percentnumber: %@",percentNumber);
     if([percentNumber intValue]>0){
         NSString *setstr = [[percentNumber stringValue] stringByAppendingString:@"%"];
         NSString *devicestr = [_delegate.helper name];
         
         //Set label
         [_label setText:setstr];
         [_deviceNameLabel setText:devicestr];
         
         //Log
         NSLog(@"did set label to %@",setstr);
     } else {
         NSLog(@"zeroed out");
     }


 }

- (IBAction)reload {
    [_delegate forceRefresh];
}

-(void)didAppear{
    NSLog(@"did appear");
    [self setLabel];
    NSLog(@"err hello");
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



