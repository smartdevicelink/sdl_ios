//
//  SDLFileTypeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLFileType.h"

QuickSpecBegin(SDLFileTypeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLFileTypeGraphicBmp).to(equal(@"GRAPHIC_BMP"));
        expect(SDLFileTypeGraphicJpeg).to(equal(@"GRAPHIC_JPEG"));
        expect(SDLFileTypeGraphicPng).to(equal(@"GRAPHIC_PNG"));
        expect(SDLFileTypeAudioWave).to(equal(@"AUDIO_WAVE"));
        expect(SDLFileTypeAudioMp3).to(equal(@"AUDIO_MP3"));
        expect(SDLFileTypeAudioAac).to(equal(@"AUDIO_AAC"));
        expect(SDLFileTypeBinary).to(equal(@"BINARY"));
        expect(SDLFileTypeJson).to(equal(@"JSON"));
    });
});

QuickSpecEnd
