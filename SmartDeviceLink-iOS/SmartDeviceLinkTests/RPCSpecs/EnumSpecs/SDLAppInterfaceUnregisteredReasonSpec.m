//
//  SDLAppInterfaceUnregisteredReasonSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAppInterfaceUnregisteredReason.h"

//Commented tests refer to values defined in the spec, but are not implemented

QuickSpecBegin(SDLAppInterfaceUnregisteredReasonSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        //expect([SDLAppInterfaceUnregisteredReason USER_EXIT].value).to(equal(@"USER_EXIT"));
        expect([SDLAppInterfaceUnregisteredReason IGNITION_OFF].value).to(equal(@"IGNITION_OFF"));
        expect([SDLAppInterfaceUnregisteredReason BLUETOOTH_OFF].value).to(equal(@"BLUETOOTH_OFF"));
        expect([SDLAppInterfaceUnregisteredReason USB_DISCONNECTED].value).to(equal(@"USB_DISCONNECTED"));
        expect([SDLAppInterfaceUnregisteredReason REQUEST_WHILE_IN_NONE_HMI_LEVEL].value).to(equal(@"REQUEST_WHILE_IN_NONE_HMI_LEVEL"));
        expect([SDLAppInterfaceUnregisteredReason TOO_MANY_REQUESTS].value).to(equal(@"TOO_MANY_REQUESTS"));
        expect([SDLAppInterfaceUnregisteredReason DRIVER_DISTRACTION_VIOLATION].value).to(equal(@"DRIVER_DISTRACTION_VIOLATION"));
        expect([SDLAppInterfaceUnregisteredReason LANGUAGE_CHANGE].value).to(equal(@"LANGUAGE_CHANGE"));
        expect([SDLAppInterfaceUnregisteredReason MASTER_RESET].value).to(equal(@"MASTER_RESET"));
        expect([SDLAppInterfaceUnregisteredReason FACTORY_DEFAULTS].value).to(equal(@"FACTORY_DEFAULTS"));
        expect([SDLAppInterfaceUnregisteredReason APP_UNAUTHORIZED].value).to(equal(@"APP_UNAUTHORIZED"));
        //expect([SDLAppInterfaceUnregisteredReason PROTOCOL_VIOLATION].value).to(equal(@"PROTOCOL_VIOLATION"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        //expect([SDLAppInterfaceUnregisteredReason valueOf:@"USER_EXIT"]).to(equal([SDLAppInterfaceUnregisteredReason USER_EXIT]));
        expect([SDLAppInterfaceUnregisteredReason valueOf:@"IGNITION_OFF"]).to(equal([SDLAppInterfaceUnregisteredReason IGNITION_OFF]));
        expect([SDLAppInterfaceUnregisteredReason valueOf:@"BLUETOOTH_OFF"]).to(equal([SDLAppInterfaceUnregisteredReason BLUETOOTH_OFF]));
        expect([SDLAppInterfaceUnregisteredReason valueOf:@"USB_DISCONNECTED"]).to(equal([SDLAppInterfaceUnregisteredReason USB_DISCONNECTED]));
        expect([SDLAppInterfaceUnregisteredReason valueOf:@"REQUEST_WHILE_IN_NONE_HMI_LEVEL"]).to(equal([SDLAppInterfaceUnregisteredReason REQUEST_WHILE_IN_NONE_HMI_LEVEL]));
        expect([SDLAppInterfaceUnregisteredReason valueOf:@"TOO_MANY_REQUESTS"]).to(equal([SDLAppInterfaceUnregisteredReason TOO_MANY_REQUESTS]));
        expect([SDLAppInterfaceUnregisteredReason valueOf:@"DRIVER_DISTRACTION_VIOLATION"]).to(equal([SDLAppInterfaceUnregisteredReason DRIVER_DISTRACTION_VIOLATION]));
        expect([SDLAppInterfaceUnregisteredReason valueOf:@"LANGUAGE_CHANGE"]).to(equal([SDLAppInterfaceUnregisteredReason LANGUAGE_CHANGE]));
        expect([SDLAppInterfaceUnregisteredReason valueOf:@"MASTER_RESET"]).to(equal([SDLAppInterfaceUnregisteredReason MASTER_RESET]));
        expect([SDLAppInterfaceUnregisteredReason valueOf:@"FACTORY_DEFAULTS"]).to(equal([SDLAppInterfaceUnregisteredReason FACTORY_DEFAULTS]));
        expect([SDLAppInterfaceUnregisteredReason valueOf:@"APP_UNAUTHORIZED"]).to(equal([SDLAppInterfaceUnregisteredReason APP_UNAUTHORIZED]));
        //expect([SDLAppInterfaceUnregisteredReason valueOf:@"PROTOCOL_VIOLATION"]).to(equal([SDLAppInterfaceUnregisteredReason PROTOCOL_VIOLATION]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLAppInterfaceUnregisteredReason valueOf:nil]).to(beNil());
        expect([SDLAppInterfaceUnregisteredReason valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLAppInterfaceUnregisteredReason values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[//[SDLAppInterfaceUnregisteredReason USER_EXIT],
                        [SDLAppInterfaceUnregisteredReason IGNITION_OFF],
                        [SDLAppInterfaceUnregisteredReason BLUETOOTH_OFF],
                        [SDLAppInterfaceUnregisteredReason USB_DISCONNECTED],
                        [SDLAppInterfaceUnregisteredReason REQUEST_WHILE_IN_NONE_HMI_LEVEL],
                        [SDLAppInterfaceUnregisteredReason TOO_MANY_REQUESTS],
                        [SDLAppInterfaceUnregisteredReason DRIVER_DISTRACTION_VIOLATION],
                        [SDLAppInterfaceUnregisteredReason LANGUAGE_CHANGE],
                        [SDLAppInterfaceUnregisteredReason MASTER_RESET],
                        [SDLAppInterfaceUnregisteredReason FACTORY_DEFAULTS],
                        [SDLAppInterfaceUnregisteredReason APP_UNAUTHORIZED]] copy];
                        //[SDLAppInterfaceUnregisteredReason PROTOCOL_VIOLATION]
    });
    
    it(@"Should contain all defined enum values", ^ {
        for (int i = 0; i < definedValues.count; i++) {
            expect(storedValues).to(contain(definedValues[i]));
        }
    });
    
    it(@"Should contain only defined enum values", ^ {
        for (int i = 0; i < storedValues.count; i++) {
            expect(definedValues).to(contain(storedValues[i]));
        }
    });
});

QuickSpecEnd