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
@property (weak, nonatomic) IBOutlet WKInterfaceImage *image;
@property UIImage *chargingImage;
@property UIImage *fullImage;
@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    
    [super awakeWithContext:context];
    _delegate = (ExtensionDelegate*)[[WKExtension sharedExtension] delegate];
    [_label setText:@""];
    [_deviceNameLabel setText:@""];
    
    _chargingImage = [UIImage imageNamed:@"Complication/Charging"];
    _fullImage = [UIImage imageNamed:@"Complication/Utilitarian"];
    [_image setTintColor:[UIColor greenColor]];
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
         
         NSLog(@"chargeimage,%@",_chargingImage);
         NSLog(@"status %@",_delegate.helper.status);
         if([_delegate.helper.status isEqualToNumber:[NSNumber numberWithInt:2]]){
              [_image setImage:_chargingImage];
         } else {
              [_image setImage:_fullImage];
             
         }
         
         [_image setWidth:0];
         [_image setHeight:0];
         
         [self animateWithDuration:0.5 animations:^{
             [_image setWidth:40];
             [_image setHeight:44];
             [_label setAlpha:1.0];
         }];
         

         NSLog(@"set imageview image to: %@",_image);
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
    [self reload];
    NSLog(@"err hello");
}

- (void)willDisappear{
    [_image setWidth:0];
    [_image setHeight:0];
    [_label setAlpha:0.0];
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



