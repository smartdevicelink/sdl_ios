//
//  SDLButtonCapabilitiesSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLButtonCapabilities.h"
#import "SDLButtonName.h"
#import "SDLRPCParameterNames.h"


QuickSpecBegin(SDLButtonCapabilitiesSpec)

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
        SDLButtonCapabilities* testStruct = [[SDLButtonCapabilities alloc] init];
        
        testStruct.name = SDLButtonNameTuneUp;
        testStruct.shortPressAvailable = @YES;
        testStruct.longPressAvailable = @YES;
        testStruct.upDownAvailable = @NO;
        
        expect(testStruct.name).to(equal(SDLButtonNameTuneUp));
        expect(testStruct.moduleInfo).to(beNil());
        expect(testStruct.shortPressAvailable).to(equal(@YES));
        expect(testStruct.longPressAvailable).to(equal(@YES));
        expect(testStruct.upDownAvailable).to(equal(@NO));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLRPCParameterNameName:SDLButtonNameCustomButton,
                                       SDLRPCParameterNameModuleInfo:testModuleInfo,
                                       SDLRPCParameterNameShortPressAvailable:@YES,
                                       SDLRPCParameterNameLongPressAvailable:@YES,
                                       SDLRPCParameterNameUpDownAvailable:@NO} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLButtonCapabilities* testStruct = [[SDLButtonCapabilities alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testStruct.name).to(equal(SDLButtonNameCustomButton));
        expect(testStruct.moduleInfo).to(equal(testModuleInfo));
        expect(testStruct.shortPressAvailable).to(equal(@YES));
        expect(testStruct.longPressAvailable).to(equal(@YES));
        expect(testStruct.upDownAvailable).to(equal(@NO));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLButtonCapabilities* testStruct = [[SDLButtonCapabilities alloc] init];
        
        expect(testStruct.name).to(beNil());
        expect(testStruct.moduleInfo).to(beNil());
        expect(testStruct.shortPressAvailable).to(beNil());
        expect(testStruct.longPressAvailable).to(beNil());
        expect(testStruct.upDownAvailable).to(beNil());
    });
});

QuickSpecEnd
