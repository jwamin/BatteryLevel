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
    
    handler(CLKComplicationTimeTravelDirectionForward);
}

- (void)getTimelineStartDateForComplication:(CLKComplication *)complication withHandler:(void(^)(NSDate * __nullable date))handler {
    handler([[[NSDate alloc]init] dateByAddingTimeInterval:(-60*60)]);
}

- (void)getTimelineEndDateForComplication:(CLKComplication *)complication withHandler:(void(^)(NSDate * __nullable date))handler {
    handler([[[NSDate alloc]init] dateByAddingTimeInterval:(60*60)]);
}

- (void)getPrivacyBehaviorForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationPrivacyBehavior privacyBehavior))handler {
    handler(CLKComplicationPrivacyBehaviorShowOnLockScreen);
}

#pragma mark - Timeline Population

- (void)getCurrentTimelineEntryForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTimelineEntry * __nullable))handler {
    // Call the handler with the current timeline entry
    
    ExtensionDelegate* myDelegate = (ExtensionDelegate*)[[WKExtension sharedExtension] delegate];
    
    BatteryLevelHelper *currentHelper = [myDelegate helper];
    
    if([currentHelper.ready isEqualToNumber:[NSNumber numberWithBool:YES]]){
        NSLog(@"helper is ready and has values");
        
        CLKComplicationTimelineEntry *entry = [[CLKComplicationTimelineEntry alloc]init];
        CLKComplicationTemplateUtilitarianSmallRingText *templ = [[CLKComplicationTemplateUtilitarianSmallRingText alloc]init];
        
        UIImage *image = [UIImage imageNamed:@"Utilitarian"];
        
        if([[currentHelper status] isEqual:[NSNumber numberWithInt:2]]){
            image = [UIImage imageNamed:@"Complication/Charging"];
        }
        
        CLKImageProvider *imageprovider = [[CLKImageProvider alloc]init];
        imageprovider.onePieceImage = image;
        
        NSString *floatstring = [[currentHelper levelFloat]stringValue];
        CLKTextProvider *text = [CLKTextProvider textProviderWithFormat:@"%@", floatstring];
        [templ setTextProvider:text];
        [templ setFillFraction:[[currentHelper levelFloat]floatValue]/100];
        
        [entry setDate:currentHelper.date];
        [entry setComplicationTemplate:templ];
        
        handler(entry);
    } else {
        NSLog(@"nilling out");
        handler(nil);
    }
    

    
    
}

- (void)getTimelineEntriesForComplication:(CLKComplication *)complication beforeDate:(NSDate *)date limit:(NSUInteger)limit withHandler:(void(^)(NSArray<CLKComplicationTimelineEntry *> * __nullable entries))handler {
    // Call the handler with the timeline entries prior to the given date
//    ExtensionDelegate* myDelegate = (ExtensionDelegate*)[[WKExtension sharedExtension] delegate];
//    
//    BatteryLevelHelper *currentHelper = [myDelegate helper];
//    
//    NSMutableArray *array = [[NSMutableArray alloc]init];
//    int count = 0;
//    while([array count]<limit){
//        CLKComplicationTimelineEntry *entry = [[CLKComplicationTimelineEntry alloc]init];
//        
//        CLKComplicationTemplateUtilitarianSmallRingText *templ = [[CLKComplicationTemplateUtilitarianSmallRingText alloc]init];
//        
//        UIImage *image = [UIImage imageNamed:@"Utilitarian"];
//        
//        if([[currentHelper status] isEqual:[NSNumber numberWithInt:2]]){
//            image = [UIImage imageNamed:@"Complication/Charging"];
//        }
//        
//        CLKImageProvider *imageprovider = [[CLKImageProvider alloc]init];
//        imageprovider.onePieceImage = image;
//        NSDate *nextdate = [date dateByAddingTimeInterval:(-count * 60)];
//        NSNumber *calculatedFloat = [currentHelper estimateLevelWithDate:nextdate];
//        NSLog(@"calculated float for %@ is %@",date,calculatedFloat);
//        NSString *floatstring = [calculatedFloat stringValue];
//        NSLog(@"calculated float stringvalue is %@",floatstring);
//        CLKTextProvider *text = [CLKTextProvider textProviderWithFormat:@"%@", floatstring];
//        [templ setTextProvider:text];
//        [templ setFillFraction:[calculatedFloat floatValue]];
//        
//        [entry setDate:currentHelper.date];
//        [entry setComplicationTemplate:templ];
//        
//        [array addObject:entry];
//        count++;
//    }
//    
//    
//    handler([NSArray arrayWithArray:array]);
    handler(nil);
}

- (void)getTimelineEntriesForComplication:(CLKComplication *)complication afterDate:(NSDate *)date limit:(NSUInteger)limit withHandler:(void(^)(NSArray<CLKComplicationTimelineEntry *> * __nullable entries))handler {
    // Call the handler with the timeline entries after to the given date
    
    ExtensionDelegate* myDelegate = (ExtensionDelegate*)[[WKExtension sharedExtension] delegate];
    
    BatteryLevelHelper *currentHelper = [myDelegate helper];
    
    NSDate *endDate = [[[NSDate alloc]init] dateByAddingTimeInterval:(60*60)];
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    int count = 0;
    while([array count]<limit){
        NSDate *nextdate = [date dateByAddingTimeInterval:(count * 60)];
        
        if([endDate compare:nextdate] == NSOrderedAscending){
            NSLog(@"breaking out");
            break;
        }
        
        CLKComplicationTimelineEntry *entry = [[CLKComplicationTimelineEntry alloc]init];
        
        CLKComplicationTemplateUtilitarianSmallRingText *templ = [[CLKComplicationTemplateUtilitarianSmallRingText alloc]init];
        
        UIImage *image = [UIImage imageNamed:@"Utilitarian"];
        
        if([[currentHelper status] isEqual:[NSNumber numberWithInt:2]]){
            image = [UIImage imageNamed:@"Complication/Charging"];
        }
        
        CLKImageProvider *imageprovider = [[CLKImageProvider alloc]init];
        imageprovider.onePieceImage = image;
        
        NSNumber *calculatedFloat = [currentHelper estimateLevelWithDate:nextdate];
        
        NSNumber *percentFloat = [NSNumber numberWithFloat:([calculatedFloat floatValue] * 100.0)];
        
        NSString *floatstring = [percentFloat stringValue];
        CLKTextProvider *text = [CLKTextProvider textProviderWithFormat:@"%@", floatstring];
        [templ setTextProvider:text];
        [templ setFillFraction:[calculatedFloat floatValue]];
        
        [entry setDate:nextdate];
        [entry setComplicationTemplate:templ];
        
        [array addObject:entry];
        count++;
    }
    NSArray *finalArray = [NSArray arrayWithArray:array];
    NSLog(@"%@",finalArray);
    handler(finalArray);
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
