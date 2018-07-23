//
//  SDLStaticIconNameSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 7/23/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLStaticIconName.h"

QuickSpecBegin(SDLStaticIconNameSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLStaticIconNameAcceptCall).to(equal(@"0x29"));
        expect(SDLStaticIconNameAddWaypoint).to(equal(@"0x1B"));
        expect(SDLStaticIconNameAlbum).to(equal(@"0x21"));
        expect(SDLStaticIconNameAmbientLighting).to(equal(@"0x3d"));
        expect(SDLStaticIconNameArrowNorth).to(equal(@"0x40"));
        expect(SDLStaticIconNameAudioMute).to(equal(@"0x12"));
        expect(SDLStaticIconNameAudiobookEpisode).to(equal(@"0x83"));
        expect(SDLStaticIconNameAudiobookNarrator).to(equal(@"0x82"));
        expect(SDLStaticIconNameAuxillaryAudio).to(equal(@"0x45"));
        expect(SDLStaticIconNameBack).to(equal(@"0x86"));
        expect(SDLStaticIconNameBatteryCapacity0Of5).to(equal(@"0xF7"));
        expect(SDLStaticIconNameBatteryCapacity1Of5).to(equal(@"0xF8"));
        expect(SDLStaticIconNameBatteryCapacity2Of5).to(equal(@"0xF9"));
        expect(SDLStaticIconNameBatteryCapacity3Of5).to(equal(@"0xFA"));
        expect(SDLStaticIconNameBatteryCapacity4Of5).to(equal(@"0xf6"));
        expect(SDLStaticIconNameBatteryCapacity5Of5).to(equal(@"0xFB"));
        expect(SDLStaticIconNameBluetoothAudioSource).to(equal(@"0x09"));
        expect(SDLStaticIconNameBluetooth1).to(equal(@"0xcc"));
        expect(SDLStaticIconNameBluetooth2).to(equal(@"0xCD"));
        expect(SDLStaticIconNameBrowse).to(equal(@"0x77"));
        expect(SDLStaticIconNameCellPhoneInRoamingMode).to(equal(@"0x66"));
        expect(SDLStaticIconNameCellServiceSignalStrength0Of5Bars).to(equal(@"0x67"));
        expect(SDLStaticIconNameCellServiceSignalStrength1Of5Bars).to(equal(@"0x68"));
        expect(SDLStaticIconNameCellServiceSignalStrength2Of5Bars).to(equal(@"0x69"));
        expect(SDLStaticIconNameCellServiceSignalStrength3Of5Bars).to(equal(@"0x6A"));
        expect(SDLStaticIconNameCellServiceSignalStrength4Of5Bars).to(equal(@"0x6B"));
        expect(SDLStaticIconNameCellServiceSignalStrength5Of5Bars).to(equal(@"0xd5"));
    });
});

QuickSpecEnd

