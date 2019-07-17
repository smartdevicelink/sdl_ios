//
//  SDLTemplateConfigurationSpec.m
//  SmartDeviceLinkTests

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLTemplateConfiguration.h"
#import "SDLRPCParameterNames.h"
#import "SDLTemplateColorScheme.h"


QuickSpecBegin(SDLTemplateConfigurationSpec)

describe(@"Getter/Setter Tests", ^ {
    
    __block SDLTemplateColorScheme *dayScheme = [[SDLTemplateColorScheme alloc] initWithPrimaryColor:[UIColor blueColor] secondaryColor:[UIColor blackColor] backgroundColor:[UIColor whiteColor]];
    __block SDLTemplateColorScheme *nightScheme = [[SDLTemplateColorScheme alloc] initWithPrimaryColor:[UIColor blueColor] secondaryColor:[UIColor purpleColor] backgroundColor:[UIColor blackColor]];
    
    it(@"Should get correctly when initialized DESIGNATED", ^ {
        SDLTemplateConfiguration* testStruct = [[SDLTemplateConfiguration alloc] initWithTemplate:@"Template Name"];
        expect(testStruct.template).to(equal(@"Template Name"));
    });
    it(@"Should get correctly when initialized", ^ {
        SDLTemplateConfiguration* testStruct = [[SDLTemplateConfiguration alloc] initWithTemplate:@"Template Name" dayColorScheme:dayScheme nightColorScheme:nightScheme];
        expect(testStruct.template).to(equal(@"Template Name"));
        expect(testStruct.dayColorScheme).to(equal(dayScheme));
        expect(testStruct.nightColorScheme).to(equal(nightScheme));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLTemplateConfiguration* testStruct = [[SDLTemplateConfiguration alloc] initWithTemplate:@"Template Name"];
        
        expect(testStruct.dayColorScheme).to(beNil());
        expect(testStruct.nightColorScheme).to(beNil());
    });
    
    it(@"Should set and get correctly", ^ {
        SDLTemplateConfiguration* testStruct = [[SDLTemplateConfiguration alloc] initWithTemplate:@"Template Name"];
        
        testStruct.dayColorScheme = dayScheme;
        testStruct.nightColorScheme = nightScheme;
        
        expect(testStruct.dayColorScheme).to(equal(dayScheme));
        expect(testStruct.nightColorScheme).to(equal(nightScheme));
    });
});

QuickSpecEnd
