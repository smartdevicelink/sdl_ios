//
//  SDLSyncMsgVersionSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSyncMsgVersion.h"
#import "SDLNames.h"

QuickSpecBegin(SDLSyncMsgVersionSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLSyncMsgVersion* testStruct = [[SDLSyncMsgVersion alloc] init];
        
        testStruct.majorVersion = @4;
        testStruct.minorVersion = @532;
        
        expect(testStruct.majorVersion).to(equal(@4));
        expect(testStruct.minorVersion).to(equal(@532));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_majorVersion:@4,
                                       NAMES_minorVersion:@532} mutableCopy];
        SDLSyncMsgVersion* testStruct = [[SDLSyncMsgVersion alloc] initWithDictionary:dict];
        
        expect(testStruct.majorVersion).to(equal(@4));
        expect(testStruct.minorVersion).to(equal(@532));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLSyncMsgVersion* testStruct = [[SDLSyncMsgVersion alloc] init];
        
        expect(testStruct.majorVersion).to(beNil());
        expect(testStruct.minorVersion).to(beNil());
    });
});

QuickSpecEnd