//
//  SDLDIDResultSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDIDResult.h"
#import "SDLNames.h"
#import "SDLVehicleDataResultCode.h"


QuickSpecBegin(SDLDIDResultSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLDIDResult* testStruct = [[SDLDIDResult alloc] init];
        
        testStruct.resultCode = [SDLVehicleDataResultCode DATA_NOT_SUBSCRIBED];
        testStruct.didLocation = @300;
        testStruct.data = @"gertwydhty4235tdhedt4tue";
        
        expect(testStruct.resultCode).to(equal([SDLVehicleDataResultCode DATA_NOT_SUBSCRIBED]));
        expect(testStruct.didLocation).to(equal(@300));
        expect(testStruct.data).to(equal(@"gertwydhty4235tdhedt4tue"));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_resultCode:[SDLVehicleDataResultCode DATA_NOT_SUBSCRIBED],
                                       NAMES_didLocation:@300,
                                       NAMES_data:@"gertwydhty4235tdhedt4tue"} mutableCopy];
        SDLDIDResult* testStruct = [[SDLDIDResult alloc] initWithDictionary:dict];
        
        expect(testStruct.resultCode).to(equal([SDLVehicleDataResultCode DATA_NOT_SUBSCRIBED]));
        expect(testStruct.didLocation).to(equal(@300));
        expect(testStruct.data).to(equal(@"gertwydhty4235tdhedt4tue"));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLDIDResult* testStruct = [[SDLDIDResult alloc] init];
        
        expect(testStruct.resultCode).to(beNil());
        expect(testStruct.didLocation).to(beNil());
        expect(testStruct.data).to(beNil());
    });
});

QuickSpecEnd