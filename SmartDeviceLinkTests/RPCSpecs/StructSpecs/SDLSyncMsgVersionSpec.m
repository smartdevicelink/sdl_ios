//
//  SDLSyncMsgVersionSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSyncMsgVersion.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLSyncMsgVersionSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLSyncMsgVersion* testStruct = [[SDLSyncMsgVersion alloc] init];
#pragma clang diagnostic pop

        testStruct.majorVersion = @4;
        testStruct.minorVersion = @532;
        testStruct.patchVersion = @12;

        expect(testStruct.majorVersion).to(equal(@4));
        expect(testStruct.minorVersion).to(equal(@532));
        expect(testStruct.patchVersion).to(equal(@12));
    });

    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLRPCParameterNameMajorVersion:@4,
                                       SDLRPCParameterNameMinorVersion:@532,
                                       SDLRPCParameterNamePatchVersion:@12} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLSyncMsgVersion* testStruct = [[SDLSyncMsgVersion alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

        expect(testStruct.majorVersion).to(equal(@4));
        expect(testStruct.minorVersion).to(equal(@532));
        expect(testStruct.patchVersion).to(equal(@12));
    });

    it(@"Should return nil if not set", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLSyncMsgVersion* testStruct = [[SDLSyncMsgVersion alloc] init];
#pragma clang diagnostic pop


        expect(testStruct.majorVersion).to(beNil());
        expect(testStruct.minorVersion).to(beNil());
        expect(testStruct.patchVersion).to(beNil());
    });
});

QuickSpecEnd
