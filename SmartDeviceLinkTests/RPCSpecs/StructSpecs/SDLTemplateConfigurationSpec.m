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
    
    __block SDLTemplateColorScheme *dayScheme = nil;
    __block SDLTemplateColorScheme *nightScheme = nil;
    __block NSString *testTemplateName = nil;
    
    beforeEach(^{
        dayScheme = [[SDLTemplateColorScheme alloc] initWithPrimaryColor:[UIColor blueColor] secondaryColor:[UIColor blackColor] backgroundColor:[UIColor whiteColor]];
        nightScheme = [[SDLTemplateColorScheme alloc] initWithPrimaryColor:[UIColor blueColor] secondaryColor:[UIColor purpleColor] backgroundColor:[UIColor blackColor]];
        testTemplateName = @"Template Name";
    });
    
    it(@"Should get correctly when initialized DESIGNATED", ^ {
        SDLTemplateConfiguration* testStruct = [[SDLTemplateConfiguration alloc] initWithTemplate:testTemplateName];
        expect(testStruct.template).to(equal(testTemplateName));
    });
    it(@"Should get correctly when initialized", ^ {
        SDLTemplateConfiguration* testStruct = [[SDLTemplateConfiguration alloc] initWithTemplate:testTemplateName dayColorScheme:dayScheme nightColorScheme:nightScheme];
        expect(testStruct.template).to(equal(testTemplateName));
        expect(testStruct.dayColorScheme).to(equal(dayScheme));
        expect(testStruct.nightColorScheme).to(equal(nightScheme));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLTemplateConfiguration* testStruct = [[SDLTemplateConfiguration alloc] initWithTemplate:testTemplateName];
        
        expect(testStruct.dayColorScheme).to(beNil());
        expect(testStruct.nightColorScheme).to(beNil());
    });
    
    it(@"Should set and get correctly", ^ {
        SDLTemplateConfiguration* testStruct = [[SDLTemplateConfiguration alloc] initWithTemplate:testTemplateName];
        
        testStruct.dayColorScheme = dayScheme;
        testStruct.nightColorScheme = nightScheme;
        
        expect(testStruct.dayColorScheme).to(equal(dayScheme));
        expect(testStruct.nightColorScheme).to(equal(nightScheme));
    });
});

QuickSpecEnd
