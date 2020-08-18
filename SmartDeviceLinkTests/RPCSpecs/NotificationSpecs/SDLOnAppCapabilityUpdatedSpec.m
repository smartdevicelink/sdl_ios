//
//  SDLOnAppCapabilityUpdatedSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLOnAppCapabilityUpdated.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLOnAppCapabilityUpdatedSpec)

describe(@"getter/setter tests", ^{
    context(@"initWithDictionary:", ^{
        it(@"expect all properties to be set properly", ^{
            //TODO: implement tests
        });
    });

    context(@"initWithDictionary:", ^{
        NSDictionary* dict = @{SDLRPCParameterNameNotification:
                               @{SDLRPCParameterNameParameters:@{
                                    SDLRPCParameterNameReason:SDLAppInterfaceUnregisteredReasonAppUnauthorized
                               },
                            SDLRPCParameterNameOperationName:SDLRPCFunctionNameOnAppInterfaceUnregistered}};
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLOnAppCapabilityUpdated *testNotification = [[SDLOnAppCapabilityUpdated alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        it(@"expect all properties to be set properly", ^{
            expect(testNotification.reason).to(equal(???));
        });
    });
});

QuickSpecEnd
