//
//  SDLStaticIconNameSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 7/23/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLStaticIconName.h"

QuickSpecBegin(SDLStaticIconNameSpec)

describe(@"Individual Enum Value Tests", ^{
    it(@"Should match internal values", ^{
        expect(SDLStaticIconNameAcceptCall).to(equal(@"0x29"));
        expect(SDLStaticIconNameAddWaypoint).to(equal(@"0x1B"));
        expect(SDLStaticIconNameAlbum).to(equal(@"0x21"));
        expect(SDLStaticIconNameAmbientLighting).to(equal(@"0x3d"));
        expect(SDLStaticIconNameArrowNorth).to(equal(@"0x40"));
        expect(SDLStaticIconNameAudioMute).to(equal(@"0x12"));
        expect(SDLStaticIconNameAudiobookEpisode).to(equal(@"0x83"));
        expect(SDLStaticIconNameAudiobookNarrator).to(equal(@"0x82"));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(SDLStaticIconNameAuxillaryAudio).to(equal(@"0x45"));
#pragma clang diagnostic pop
        expect(SDLStaticIconNameAuxiliaryAudio).to(equal(@"0x45"));
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
        expect(SDLStaticIconNameCellServiceSignalStrength5Of5Bars).to(equal(@"0xd3"));
        expect(SDLStaticIconNameChangeLaneLeft).to(equal(@"0xc3"));
        expect(SDLStaticIconNameChangeLaneRight).to(equal(@"0xc1"));
        expect(SDLStaticIconNameCheckBoxChecked).to(equal(@"0x27"));
        expect(SDLStaticIconNameCheckBoxUnchecked).to(equal(@"0x28"));
        expect(SDLStaticIconNameClimate).to(equal(@"0xd1"));
        expect(SDLStaticIconNameClock).to(equal(@"0xfc"));
        expect(SDLStaticIconNameCompose).to(equal(@"0x1A"));
        expect(SDLStaticIconNameContact).to(equal(@"0x5C"));
        expect(SDLStaticIconNameContinue).to(equal(@"0x42"));
        expect(SDLStaticIconNameDash).to(equal(@"0x7F"));
        expect(SDLStaticIconNameDate).to(equal(@"0x87"));
        expect(SDLStaticIconNameDelete).to(equal(@"0x0F"));
        expect(SDLStaticIconNameDestination).to(equal(@"0x94"));
        expect(SDLStaticIconNameDestinationFerryAhead).to(equal(@"0x4D"));
        expect(SDLStaticIconNameEbookmark).to(equal(@"0x2B"));
        expect(SDLStaticIconNameEmpty).to(equal(@"0x01"));
        expect(SDLStaticIconNameEndCall).to(equal(@"0x2C"));
        expect(SDLStaticIconNameFail).to(equal(@"0xD6"));
        expect(SDLStaticIconNameFastForward30Secs).to(equal(@"0x08"));
        expect(SDLStaticIconNameFavoriteHeart).to(equal(@"0x0E"));
        expect(SDLStaticIconNameFavoriteStar).to(equal(@"0x95"));
        expect(SDLStaticIconNameFaxNumber).to(equal(@"0x80"));
        expect(SDLStaticIconNameFilename).to(equal(@"0x50"));
        expect(SDLStaticIconNameFilter).to(equal(@"0x79"));
        expect(SDLStaticIconNameFolder).to(equal(@"0x1C"));
        expect(SDLStaticIconNameFuelPrices).to(equal(@"0xe9"));
        expect(SDLStaticIconNameFullMap).to(equal(@"0x0c"));
        expect(SDLStaticIconNameGenericPhoneNumber).to(equal(@"0x53"));
        expect(SDLStaticIconNameGenre).to(equal(@"0x4E"));
        expect(SDLStaticIconNameGlobalKeyboard).to(equal(@"0xea"));
        expect(SDLStaticIconNameHighwayExitInformation).to(equal(@"0xf4"));
        expect(SDLStaticIconNameHomePhoneNumber).to(equal(@"0x55"));
        expect(SDLStaticIconNameHyperlink).to(equal(@"0x78"));
        expect(SDLStaticIconNameID3TagUnknown).to(equal(@"0x51"));
        expect(SDLStaticIconNameIncomingCalls).to(equal(@"0x57"));
        expect(SDLStaticIconNameInformation).to(equal(@"0x5d"));
        expect(SDLStaticIconNameIPodMediaSource).to(equal(@"0x0D"));
        expect(SDLStaticIconNameJoinCalls).to(equal(@"0x02"));
        expect(SDLStaticIconNameKeepLeft).to(equal(@"0x46"));
        expect(SDLStaticIconNameKeepRight).to(equal(@"0x48"));
        expect(SDLStaticIconNameKey).to(equal(@"0x7D"));
        expect(SDLStaticIconNameLeft).to(equal(@"0x9f"));
        expect(SDLStaticIconNameLeftArrow).to(equal(@"0x4B"));
        expect(SDLStaticIconNameLeftExit).to(equal(@"0xaf"));
        expect(SDLStaticIconNameLineInAudioSource).to(equal(@"0x06"));
        expect(SDLStaticIconNameLocked).to(equal(@"0x22"));
        expect(SDLStaticIconNameMediaControlLeftArrow).to(equal(@"0x17"));
        expect(SDLStaticIconNameMediaControlRecording).to(equal(@"0x20"));
        expect(SDLStaticIconNameMediaControlRightArrow).to(equal(@"0x15"));
        expect(SDLStaticIconNameMediaControlStop).to(equal(@"0x16"));
        expect(SDLStaticIconNameMicrophone).to(equal(@"0xe8"));
        expect(SDLStaticIconNameMissedCalls).to(equal(@"0x58"));
        expect(SDLStaticIconNameMobilePhoneNumber).to(equal(@"0x54"));
        expect(SDLStaticIconNameMoveDown).to(equal(@"0xE5"));
        expect(SDLStaticIconNameMoveUp).to(equal(@"0xe4"));
        expect(SDLStaticIconNameMP3TagArtist).to(equal(@"0x24"));
        expect(SDLStaticIconNameNavigation).to(equal(@"0x8e"));
        expect(SDLStaticIconNameNavigationCurrentDirection).to(equal(@"0x0a"));
        expect(SDLStaticIconNameNegativeRatingThumbsDown).to(equal(@"0x14"));
        expect(SDLStaticIconNameNew).to(equal(@"0x5E"));
        expect(SDLStaticIconNameOfficePhoneNumber).to(equal(@"0x56"));
        expect(SDLStaticIconNameOpened).to(equal(@"0x5F"));
        expect(SDLStaticIconNameOrigin).to(equal(@"0x96"));
        expect(SDLStaticIconNameOutgoingCalls).to(equal(@"0x59"));
        expect(SDLStaticIconNamePause).to(equal(@"0xCF"));
        expect(SDLStaticIconNamePhoneCall1).to(equal(@"0x1D"));
        expect(SDLStaticIconNamePhoneCall2).to(equal(@"0x1E"));
        expect(SDLStaticIconNamePhoneDevice).to(equal(@"0x03"));
        expect(SDLStaticIconNamePhonebook).to(equal(@"0x81"));
        expect(SDLStaticIconNamePhoto).to(equal(@"0x88"));
        expect(SDLStaticIconNamePlay).to(equal(@"0xD0"));
        expect(SDLStaticIconNamePlaylist).to(equal(@"0x4F"));
        expect(SDLStaticIconNamePopUp).to(equal(@"0x76"));
        expect(SDLStaticIconNamePositiveRatingThumbsUp).to(equal(@"0x13"));
        expect(SDLStaticIconNamePower).to(equal(@"0x5b"));
        expect(SDLStaticIconNamePrimaryPhone).to(equal(@"0x1F"));
        expect(SDLStaticIconNameRadioButtonChecked).to(equal(@"0x25"));
        expect(SDLStaticIconNameRadioButtonUnchecked).to(equal(@"0x26"));
        expect(SDLStaticIconNameRecentCalls).to(equal(@"0xe7"));
        expect(SDLStaticIconNameRecentDestinations).to(equal(@"0xf2"));
        expect(SDLStaticIconNameRedo).to(equal(@"0x19"));
        expect(SDLStaticIconNameRefresh).to(equal(@"0x97"));
        expect(SDLStaticIconNameRemoteDiagnosticsCheckEngine).to(equal(@"0x7E"));
        expect(SDLStaticIconNameRendered911Assist).to(equal(@"0xac"));
        expect(SDLStaticIconNameRepeat).to(equal(@"0xe6"));
        expect(SDLStaticIconNameRepeatPlay).to(equal(@"0x73"));
        expect(SDLStaticIconNameReply).to(equal(@"0x04"));
        expect(SDLStaticIconNameRewind30Secs).to(equal(@"0x07"));
        expect(SDLStaticIconNameRight).to(equal(@"0xa3"));
        expect(SDLStaticIconNameRightExit).to(equal(@"0xb1"));
        expect(SDLStaticIconNameRingtones).to(equal(@"0x5A"));
        expect(SDLStaticIconNameRoundaboutLeftHand1).to(equal(@"0xee"));
        expect(SDLStaticIconNameRoundaboutLeftHand2).to(equal(@"0x8c"));
        expect(SDLStaticIconNameRoundaboutLeftHand3).to(equal(@"0x84"));
        expect(SDLStaticIconNameRoundaboutLeftHand4).to(equal(@"0x72"));
        expect(SDLStaticIconNameRoundaboutLeftHand5).to(equal(@"0x6e"));
        expect(SDLStaticIconNameRoundaboutLeftHand6).to(equal(@"0x64"));
        expect(SDLStaticIconNameRoundaboutLeftHand7).to(equal(@"0x60"));
        expect(SDLStaticIconNameRoundaboutRightHand1).to(equal(@"0x62"));
        expect(SDLStaticIconNameRoundaboutRightHand2).to(equal(@"0x6c"));
        expect(SDLStaticIconNameRoundaboutRightHand3).to(equal(@"0x70"));
        expect(SDLStaticIconNameRoundaboutRightHand4).to(equal(@"0x7a"));
        expect(SDLStaticIconNameRoundaboutRightHand5).to(equal(@"0x8a"));
        expect(SDLStaticIconNameRoundaboutRightHand6).to(equal(@"0xec"));
        expect(SDLStaticIconNameRoundaboutRightHand7).to(equal(@"0xf0"));
        expect(SDLStaticIconNameRSS).to(equal(@"0x89"));
        expect(SDLStaticIconNameSettings).to(equal(@"0x49"));
        expect(SDLStaticIconNameSharpLeft).to(equal(@"0xa5"));
        expect(SDLStaticIconNameSharpRight).to(equal(@"0xa7"));
        expect(SDLStaticIconNameShow).to(equal(@"0xe1"));
        expect(SDLStaticIconNameShufflePlay).to(equal(@"0x74"));
        expect(SDLStaticIconNameSkiPlaces).to(equal(@"0xab"));
        expect(SDLStaticIconNameSlightLeft).to(equal(@"0x9d"));
        expect(SDLStaticIconNameSlightRight).to(equal(@"0xa1"));
        expect(SDLStaticIconNameSmartphone).to(equal(@"0x05"));
        expect(SDLStaticIconNameSortList).to(equal(@"0x7B"));
        expect(SDLStaticIconNameSpeedDialNumbersNumber0).to(equal(@"0xE0"));
        expect(SDLStaticIconNameSpeedDialNumbersNumber1).to(equal(@"0xD7"));
        expect(SDLStaticIconNameSpeedDialNumbersNumber2).to(equal(@"0xD8"));
        expect(SDLStaticIconNameSpeedDialNumbersNumber3).to(equal(@"0xD9"));
        expect(SDLStaticIconNameSpeedDialNumbersNumber4).to(equal(@"0xDA"));
        expect(SDLStaticIconNameSpeedDialNumbersNumber5).to(equal(@"0xDB"));
        expect(SDLStaticIconNameSpeedDialNumbersNumber6).to(equal(@"0xDC"));
        expect(SDLStaticIconNameSpeedDialNumbersNumber7).to(equal(@"0xDD"));
        expect(SDLStaticIconNameSpeedDialNumbersNumber8).to(equal(@"0xDE"));
        expect(SDLStaticIconNameSpeedDialNumbersNumber9).to(equal(@"0xDF"));
        expect(SDLStaticIconNameSuccess).to(equal(@"0xD5"));
        expect(SDLStaticIconNameTrackTitle).to(equal(@"0x4C"));
        expect(SDLStaticIconNameTrafficReport).to(equal(@"0x2A"));
        expect(SDLStaticIconNameTurnList).to(equal(@"0x10"));
        expect(SDLStaticIconNameUTurnLeftTraffic).to(equal(@"0xad"));
        expect(SDLStaticIconNameUTurnRightTraffic).to(equal(@"0xa9"));
        expect(SDLStaticIconNameUndo).to(equal(@"0x18"));
        expect(SDLStaticIconNameUnlocked).to(equal(@"0x23"));
        expect(SDLStaticIconNameUSBMediaAudioSource).to(equal(@"0x0B"));
        expect(SDLStaticIconNameVoiceControlScrollbarListItemNo1).to(equal(@"0xC7"));
        expect(SDLStaticIconNameVoiceControlScrollbarListItemNo2).to(equal(@"0xC8"));
        expect(SDLStaticIconNameVoiceControlScrollbarListItemNo3).to(equal(@"0xC9"));
        expect(SDLStaticIconNameVoiceControlScrollbarListItemNo4).to(equal(@"0xCA"));
        expect(SDLStaticIconNameVoiceRecognitionFailed).to(equal(@"0x90"));
        expect(SDLStaticIconNameVoiceRecognitionPause).to(equal(@"0x92"));
        expect(SDLStaticIconNameVoiceRecognitionSuccessful).to(equal(@"0x8F"));
        expect(SDLStaticIconNameVoiceRecognitionSystemActive).to(equal(@"0x11"));
        expect(SDLStaticIconNameVoiceRecognitionSystemListening).to(equal(@"0x91"));
        expect(SDLStaticIconNameVoiceRecognitionTryAgain).to(equal(@"0x93"));
        expect(SDLStaticIconNameWarning).to(equal(@"0xfe"));
        expect(SDLStaticIconNameWeather).to(equal(@"0xeb"));
        expect(SDLStaticIconNameWifiFull).to(equal(@"0x43"));
        expect(SDLStaticIconNameZoomIn).to(equal(@"0x98"));
        expect(SDLStaticIconNameZoomOut).to(equal(@"0x9a"));
    });
});

QuickSpecEnd
