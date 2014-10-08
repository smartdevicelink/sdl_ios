//  SDLShow.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLRPCRequest.h>

#import <AppLink/SDLTextAlignment.h>
#import <AppLink/SDLImage.h>

@interface SDLShow : SDLRPCRequest {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSString* mainField1;
@property(strong) NSString* mainField2;
@property(strong) NSString* mainField3;
@property(strong) NSString* mainField4;
@property(strong) SDLTextAlignment* alignment;
@property(strong) NSString* statusBar;
@property(strong) NSString* mediaClock;
@property(strong) NSString* mediaTrack;
@property(strong) SDLImage* graphic;
@property(strong) SDLImage* secondaryGraphic;
@property(strong) NSMutableArray* softButtons;
@property(strong) NSMutableArray* customPresets;

@end
