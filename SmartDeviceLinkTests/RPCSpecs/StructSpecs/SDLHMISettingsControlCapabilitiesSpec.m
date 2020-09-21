//
//  SDLHMISettingsControlCapabilitiesSpec.m
//  SmartDeviceLinkTests
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLHMISettingsControlCapabilities.h"
#import "SDLRPCParameterNames.h"


QuickSpecBegin(SDLHMISettingsControlCapabilitiesSpec)

describe(@"Getter/Setter Tests", ^ {
    __block SDLModuleInfo *testModuleInfo = nil;
    __block SDLGrid *testGird = nil;
    
    beforeEach(^{
        testGird.col = @0;
        testGird.row = @0;
        testGird.level = @0;
        testGird.rowspan = @2;
        testGird.colspan = @3;
        testGird.levelspan = @1;
        testModuleInfo = [[SDLModuleInfo alloc] init];
        testModuleInfo.moduleId = @"123";
        testModuleInfo.allowMultipleAccess = @YES;
        testModuleInfo.serviceArea = testGird;
        testModuleInfo.location = testGird;
    });

    it(@"Should set and get correctly", ^ {
        SDLHMISettingsControlCapabilities* testStruct = [[SDLHMISettingsControlCapabilities alloc] init];

        testStruct.moduleName = @"displayMode";
        testStruct.moduleInfo = testModuleInfo;
        testStruct.distanceUnitAvailable = @(NO);
        testStruct.temperatureUnitAvailable = @(NO);
        testStruct.displayModeUnitAvailable = @(YES);

        expect(testStruct.moduleName).to(equal(@"displayMode"));
        expect(testStruct.moduleInfo).to(equal(testModuleInfo));
        expect(testStruct.distanceUnitAvailable).to(equal(@(NO)));
        expect(testStruct.temperatureUnitAvailable).to(equal(@(NO)));
        expect(testStruct.displayModeUnitAvailable).to(equal(@(YES)));
    });
    
    it(@"Should init correctly with initWithModuleName:moduleInfo:", ^ {
        SDLHMISettingsControlCapabilities* testStruct = [[SDLHMISettingsControlCapabilities alloc] initWithModuleName:@"displayMode" moduleInfo:testModuleInfo];

        expect(testStruct.moduleName).to(equal(@"displayMode"));
        expect(testStruct.moduleInfo).to(equal(testModuleInfo));
        expect(testStruct.distanceUnitAvailable).to(beNil());
        expect(testStruct.temperatureUnitAvailable).to(beNil());
        expect(testStruct.displayModeUnitAvailable).to(beNil());
    });
    
    it(@"Should init correctly with initWithModuleName:moduleInfo:distanceUnitAvailable:temperatureUnitAvailable:displayModeUnitAvailable:", ^ {
        SDLHMISettingsControlCapabilities* testStruct = [[SDLHMISettingsControlCapabilities alloc] initWithModuleName:@"displayMode" moduleInfo:testModuleInfo distanceUnitAvailable:NO temperatureUnitAvailable:YES displayModeUnitAvailable:NO];
        
        expect(testStruct.moduleName).to(equal(@"displayMode"));
        expect(testStruct.moduleInfo).to(equal(testModuleInfo));
        expect(testStruct.distanceUnitAvailable).to(equal(@(NO)));
        expect(testStruct.temperatureUnitAvailable).to(equal(@(YES)));
        expect(testStruct.displayModeUnitAvailable).to(equal(@(NO)));
    });

    it(@"Should get correctly when initialized", ^ {
        NSDictionary *dict = @{SDLRPCParameterNameModuleName:@"temperatureUnit",
                                       SDLRPCParameterNameModuleInfo:testModuleInfo,
                                       SDLRPCParameterNameTemperatureUnitAvailable:@(YES),
                                       SDLRPCParameterNameDistanceUnitAvailable:@(YES),
                                       SDLRPCParameterNameDisplayModeUnitAvailable:@(NO)
                                       };
        SDLHMISettingsControlCapabilities *testStruct = [[SDLHMISettingsControlCapabilities alloc] initWithDictionary:dict];

        expect(testStruct.moduleName).to(equal(@"temperatureUnit"));
        expect(testStruct.moduleInfo).to(equal(testModuleInfo));
        expect(testStruct.distanceUnitAvailable).to(equal(@(YES)));
        expect(testStruct.temperatureUnitAvailable).to(equal(@(YES)));
        expect(testStruct.displayModeUnitAvailable).to(equal(@(NO)));
    });

    it(@"Should return nil if not set", ^ {
        SDLHMISettingsControlCapabilities* testStruct = [[SDLHMISettingsControlCapabilities alloc] init];

        expect(testStruct.moduleName).to(beNil());
        expect(testStruct.moduleInfo).to(beNil());
        expect(testStruct.distanceUnitAvailable).to(beNil());
        expect(testStruct.temperatureUnitAvailable).to(beNil());
        expect(testStruct.displayModeUnitAvailable).to(beNil());
    });
});

QuickSpecEnd
