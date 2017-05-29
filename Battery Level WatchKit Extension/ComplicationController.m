//
//  ComplicationController.m
//  Battery Level WatchKit Extension
//
//  Created by Joss Manger on 5/24/17.
//  Copyright © 2017 Joss Manger. All rights reserved.
//

#import "ExtensionDelegate.h"
#import "ComplicationController.h"
#import "BatteryLevel-Swift.h"

@interface ComplicationController ()

@end

#pragma mark - Resource https://developer.apple.com/videos/play/wwdc2015/209/

@implementation ComplicationController

#pragma mark - Timeline Configuration

- (void)getSupportedTimeTravelDirectionsForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTimeTravelDirections directions))handler {
    //setting the time travel direction to backwards for the timebeing - can only rewind
    handler(CLKComplicationTimeTravelDirectionBackward);
}

- (void)getTimelineStartDateForComplication:(CLKComplication *)complication withHandler:(void(^)(NSDate * __nullable date))handler {
    handler(nil);
}

- (void)getTimelineEndDateForComplication:(CLKComplication *)complication withHandler:(void(^)(NSDate * __nullable date))handler {
    handler(nil);
}

- (void)getPrivacyBehaviorForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationPrivacyBehavior privacyBehavior))handler {
    handler(CLKComplicationPrivacyBehaviorShowOnLockScreen);
}

#pragma mark - Timeline Population

- (void)getCurrentTimelineEntryForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTimelineEntry * __nullable))handler {
    // Call the handler with the current timeline entry
    
    ExtensionDelegate* myDelegate = (ExtensionDelegate*)[[WKExtension sharedExtension] delegate];
    
    BatteryLevelHelper *currentHelper = [[BatteryLevelHelper alloc]init];
    
    if([currentHelper.ready isEqualToNumber:[NSNumber numberWithBool:YES]]){
        NSLog(@"helper is ready and has values");
        
        CLKComplicationTimelineEntry *entry = [[CLKComplicationTimelineEntry alloc]init];
        CLKComplicationTemplateUtilitarianSmallRingText *templ = [[CLKComplicationTemplateUtilitarianSmallRingText alloc]init];
        
        UIImage *image = [UIImage imageNamed:@"Utilitarian"];
        CLKImageProvider *imageprovider = [[CLKImageProvider alloc]init];
        imageprovider.onePieceImage = image;
        
        [templ setRingStyle:CLKComplicationRingStyleClosed];
        CLKTextProvider *text = [CLKTextProvider textProviderWithFormat:@"Battery Level"];
        [templ setTextProvider:text];
        [templ setFillFraction:[[currentHelper levelFloat]floatValue]];
        
        [entry setDate:currentHelper.date];
        [entry setComplicationTemplate:templ];
        
        handler(entry);
    } else {
        handler(nil);
    }
    

    
    
}

- (void)getTimelineEntriesForComplication:(CLKComplication *)complication beforeDate:(NSDate *)date limit:(NSUInteger)limit withHandler:(void(^)(NSArray<CLKComplicationTimelineEntry *> * __nullable entries))handler {
    // Call the handler with the timeline entries prior to the given date
    handler(nil);
}

- (void)getTimelineEntriesForComplication:(CLKComplication *)complication afterDate:(NSDate *)date limit:(NSUInteger)limit withHandler:(void(^)(NSArray<CLKComplicationTimelineEntry *> * __nullable entries))handler {
    // Call the handler with the timeline entries after to the given date
    handler(nil);
}

#pragma mark - Placeholder Templates

- (void)getLocalizableSampleTemplateForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTemplate * __nullable complicationTemplate))handler {
    CLKComplicationTemplateUtilitarianSmallRingText *templ = [[CLKComplicationTemplateUtilitarianSmallRingText alloc]init];
    UIImage *image = [UIImage imageNamed:@"Utilitarian"];
    CLKImageProvider *imageprovider = [[CLKImageProvider alloc]init];
    imageprovider.onePieceImage = image;
    
    [templ setRingStyle:CLKComplicationRingStyleClosed];
    CLKTextProvider *text = [CLKTextProvider textProviderWithFormat:@"Battery Level"];
    [templ setTextProvider:text];
    [templ setFillFraction:100.0];
    handler(templ);
    
}

@end
