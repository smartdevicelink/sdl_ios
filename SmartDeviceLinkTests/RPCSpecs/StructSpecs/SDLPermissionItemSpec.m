//
//  SDLPermissionItemSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLHMIPermissions.h"
#import "SDLParameterPermissions.h"
#import "SDLPermissionItem.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLPermissionItemSpec)

SDLHMIPermissions* hmiPermissions = [[SDLHMIPermissions alloc] init];
SDLParameterPermissions* parameterPermissions = [[SDLParameterPermissions alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLPermissionItem* testStruct = [[SDLPermissionItem alloc] init];
        
        testStruct.rpcName = @"RPCNameThing";
        testStruct.hmiPermissions = hmiPermissions;
        testStruct.parameterPermissions = parameterPermissions;
        
        expect(testStruct.rpcName).to(equal(@"RPCNameThing"));
        expect(testStruct.hmiPermissions).to(equal(hmiPermissions));
        expect(testStruct.parameterPermissions).to(equal(parameterPermissions));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLRPCParameterNameRPCName:@"RPCNameThing",
                                                       SDLRPCParameterNameHMIPermissions:hmiPermissions,
                                                       SDLRPCParameterNameParameterPermissions:parameterPermissions} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLPermissionItem* testStruct = [[SDLPermissionItem alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testStruct.rpcName).to(equal(@"RPCNameThing"));
        expect(testStruct.hmiPermissions).to(equal(hmiPermissions));
        expect(testStruct.parameterPermissions).to(equal(parameterPermissions));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLPermissionItem* testStruct = [[SDLPermissionItem alloc] init];
        
        expect(testStruct.rpcName).to(beNil());
        expect(testStruct.hmiPermissions).to(beNil());
        expect(testStruct.parameterPermissions).to(beNil());
    });
});

QuickSpecEnd
