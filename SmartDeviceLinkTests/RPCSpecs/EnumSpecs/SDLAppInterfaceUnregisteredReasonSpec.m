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
        //expect(SDLAppInterfaceUnregisteredReason USER_EXIT).to(equal(@"USER_EXIT"));
        expect(SDLAppInterfaceUnregisteredReasonIgnitionOff).to(equal(@"IGNITION_OFF"));
        expect(SDLAppInterfaceUnregisteredReasonBluetoothOff).to(equal(@"BLUETOOTH_OFF"));
        expect(SDLAppInterfaceUnregisteredReasonUSBDisconnected).to(equal(@"USB_DISCONNECTED"));
        expect(SDLAppInterfaceUnregisteredReasonRequestWhileInNoneHMILevel).to(equal(@"REQUEST_WHILE_IN_NONE_HMI_LEVEL"));
        expect(SDLAppInterfaceUnregisteredReasonTooManyRequests).to(equal(@"TOO_MANY_REQUESTS"));
        expect(SDLAppInterfaceUnregisteredReasonDriverDistractionViolation).to(equal(@"DRIVER_DISTRACTION_VIOLATION"));
        expect(SDLAppInterfaceUnregisteredReasonLanguageChange).to(equal(@"LANGUAGE_CHANGE"));
        expect(SDLAppInterfaceUnregisteredReasonMasterReset).to(equal(@"MASTER_RESET"));
        expect(SDLAppInterfaceUnregisteredReasonFactoryDefaults).to(equal(@"FACTORY_DEFAULTS"));
        expect(SDLAppInterfaceUnregisteredReasonAppUnauthorized).to(equal(@"APP_UNAUTHORIZED"));
        expect(SDLAppInterfaceUnregisteredReasonProtocolViolation).to(equal(@"PROTOCOL_VIOLATION"));
        expect(SDLAppInterfaceUnregisteredReasonUnsupportedHMIResource).to(equal(@"UNSUPPORTED_HMI_RESOURCE"));
        expect(SDLAppInterfaceUnregisteredReasonResourceConstraint).to(equal(@"RESOURCE_CONSTRAINT"));
    });
});

QuickSpecEnd
