//
//  SDLDIDResultSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDIDResult.h"
#import "SDLRPCParameterNames.h"
#import "SDLVehicleDataResultCode.h"


QuickSpecBegin(SDLDIDResultSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLDIDResult* testStruct = [[SDLDIDResult alloc] init];
        
        testStruct.resultCode = SDLVehicleDataResultCodeDataNotSubscribed;
        testStruct.didLocation = @300;
        testStruct.data = @"gertwydhty4235tdhedt4tue";
        
        expect(testStruct.resultCode).to(equal(SDLVehicleDataResultCodeDataNotSubscribed));
        expect(testStruct.didLocation).to(equal(@300));
        expect(testStruct.data).to(equal(@"gertwydhty4235tdhedt4tue"));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLRPCParameterNameResultCode:SDLVehicleDataResultCodeDataNotSubscribed,
                                       SDLRPCParameterNameDIDLocation:@300,
                                       SDLRPCParameterNameData:@"gertwydhty4235tdhedt4tue"} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLDIDResult* testStruct = [[SDLDIDResult alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testStruct.resultCode).to(equal(SDLVehicleDataResultCodeDataNotSubscribed));
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
