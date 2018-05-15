//
//  SDLPrimaryAudioSourceSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLPrimaryAudioSource.h"

QuickSpecBegin(SDLPrimaryAudioSourceSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLPrimaryAudioSourceNoSourceSelected).to(equal(@"NO_SOURCE_SELECTED"));
        expect(SDLPrimaryAudioSourceUSB).to(equal(@"USB"));
        expect(SDLPrimaryAudioSourceUSB2).to(equal(@"USB2"));
        expect(SDLPrimaryAudioSourceBluetoothStereo).to(equal(@"BLUETOOTH_STEREO_BTST"));
        expect(SDLPrimaryAudioSourceLineIn).to(equal(@"LINE_IN"));
        expect(SDLPrimaryAudioSourceIpod).to(equal(@"IPOD"));
        expect(SDLPrimaryAudioSourceMobileApp).to(equal(@"MOBILE_APP"));
        expect(SDLPrimaryAudioSourceCD).to(equal(@"CD"));
        expect(SDLPrimaryAudioSourceRadioTuner).to(equal(@"RADIO_TUNER"));

    });
});

QuickSpecEnd
