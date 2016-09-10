/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2016 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#ifdef USE_TI_UIIOSFEEDBACKGENERATOR
#import "TiUIiOSFeedbackGeneratorProxy.h"
#import "TiUtils.h"

@implementation TiUIiOSFeedbackGeneratorProxy

#pragma mark Internal

- (void)dealloc
{
    RELEASE_TO_NIL(generator);
    [super dealloc];
}

- (NSString*)apiName
{
    return @"Ti.UI.iOS.FeedbackGenerator";
}

- (UIFeedbackGenerator*)generator
{
    if (!generator) {
        ENSURE_TYPE([self valueForKey:@"type"], NSNumber);
        type = [TiUtils intValue:[self valueForKey:@"type"]];
        
        switch (type) {
            case TiUIiOSFeedbackGeneratorTypeSelection:
            {
                generator = [UISelectionFeedbackGenerator new];
                break;
            }
            case TiUIiOSFeedbackGeneratorTypeImpact:
            {
                id style = [self valueForKey:@"style"];
                
                if (!style) {
                    NSLog(@"[WARN] When using the Ti.UI.IOS.FEEDBACK_GENERATOR_TYPE_IMPACT generator, you also need to specify the `style` property to define the proposed impact style. Falling back to Ti.UI.iOS.FEEDBACK_GENERATOR_IMPACT_STYLE_MEDIUM.");
                }
                
                generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:[TiUtils intValue:style def:UIImpactFeedbackStyleMedium]];
                break;
            }
            case TiUIiOSFeedbackGeneratorTypeNotification:
            {
                generator = [UINotificationFeedbackGenerator new];
                break;
            }
            default:
            {
                NSLog(@"[ERROR] Unknown feedback generator type specified: %lu", (NSNumber*)type);
            }
        }
    }
    
    return generator;
}

#pragma mark Public API's

- (void)prepare:(id)unused
{
    [[self generator] prepare];
}

- (void)selectionChanged:(id)unused
{
    if (type != TiUIiOSFeedbackGeneratorTypeSelection) {
        NSLog(@"[ERROR] The `selectionChanged` method is only available for generators of the type Ti.Ui.iOS.FEEDBACK_GENERATOR_TYPE_SELECTION.");
        return;
    }
    
    [(UISelectionFeedbackGenerator*)[self generator] selectionChanged];
}

- (void)impactOccurred:(id)unused
{
    if (type != TiUIiOSFeedbackGeneratorTypeImpact) {
        NSLog(@"[ERROR] The `impactOccurred` method is only available for generators of the type Ti.Ui.iOS.FEEDBACK_GENERATOR_TYPE_IMPACT.");
        return;
    }
    
    [(UIImpactFeedbackGenerator*)[self generator] impactOccurred];
}

- (void)notificationOccurred:(id)value
{
    if (type != TiUIiOSFeedbackGeneratorTypeNotification) {
        NSLog(@"[ERROR] The `notificationOccurred` method is only available for generators of the type Ti.Ui.iOS.FEEDBACK_GENERATOR_TYPE_NOTIFICATION.");
        return;
    }
    
    ENSURE_SINGLE_ARG(value, NSNumber);
    
    [(UINotificationFeedbackGenerator*)[self generator] notificationOccurred:[TiUtils intValue:value]];
}

@end

#endif
