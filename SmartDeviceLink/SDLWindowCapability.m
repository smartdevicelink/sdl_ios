//
//  SDLWindowCapability.m
//  SmartDeviceLink

#import "SDLWindowCapability.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLTextField.h"
#import "SDLImageField.h"
#import "SDLButtonCapabilities.h"
#import "SDLSoftButtonCapabilities.h"

@implementation SDLWindowCapability

- (void)setWindowID:(nullable NSNumber<SDLUInt> *)windowID {
    [self.store sdl_setObject:windowID forName:SDLRPCParameterNameWindowId];
}

- (nullable NSNumber<SDLUInt> *)windowID {
    return [self.store sdl_objectForName:SDLRPCParameterNameWindowId ofClass:NSNumber.class error:nil];
}

- (void)setTextFields:(nullable NSArray<SDLTextField *> *)textFields {
    [self.store sdl_setObject:textFields forName:SDLRPCParameterNameTextFields];
}

- (nullable NSArray<SDLTextField *> *)textFields {
    return [self.store sdl_objectsForName:SDLRPCParameterNameTextFields ofClass:SDLTextField.class error:nil];
}

- (void)setImageFields:(nullable NSArray<SDLImageField *> *)imageFields {
    [self.store sdl_setObject:imageFields forName:SDLRPCParameterNameImageFields];
}

- (nullable NSArray<SDLImageField *> *)imageFields {
    return [self.store sdl_objectsForName:SDLRPCParameterNameImageFields ofClass:SDLImageField.class error:nil];
}

- (void)setImageTypeSupported:(nullable NSArray<SDLImageType> *)imageTypeSupported {
    [self.store sdl_setObject:imageTypeSupported forName:SDLRPCParameterNameImageTypeSupported];
}

- (nullable NSArray<SDLImageType> *)imageTypeSupported {
    return [self.store sdl_enumsForName:SDLRPCParameterNameImageTypeSupported error:nil];
}

- (void)setTemplatesAvailable:(nullable NSArray<NSString *> *)templatesAvailable {
    [self.store sdl_setObject:templatesAvailable forName:SDLRPCParameterNameTemplatesAvailable];
}

- (nullable NSArray<NSString *> *)templatesAvailable {
    return [self.store sdl_objectsForName:SDLRPCParameterNameTemplatesAvailable ofClass:NSString.class error:nil];
}

- (void)setNumCustomPresetsAvailable:(nullable NSNumber<SDLInt> *)numCustomPresetsAvailable {
    [self.store sdl_setObject:numCustomPresetsAvailable forName:SDLRPCParameterNameNumberCustomPresetsAvailable];
}

- (nullable NSNumber<SDLInt> *)numCustomPresetsAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameNumberCustomPresetsAvailable ofClass:NSNumber.class error:nil];
}

- (void)setButtonCapabilities:(nullable NSArray<SDLButtonCapabilities *> *)buttonCapabilities {
    [self.store sdl_setObject:buttonCapabilities forName:SDLRPCParameterNameButtonCapabilities];
}

- (nullable NSArray<SDLButtonCapabilities *> *)buttonCapabilities {
    return [self.store sdl_objectsForName:SDLRPCParameterNameButtonCapabilities ofClass:SDLButtonCapabilities.class error:nil];
}


- (void)setSoftButtonCapabilities:(nullable NSArray<SDLSoftButtonCapabilities *> *)softButtonCapabilities {
    [self.store sdl_setObject:softButtonCapabilities forName:SDLRPCParameterNameSoftButtonCapabilities];
}

- (nullable NSArray<SDLSoftButtonCapabilities *> *)softButtonCapabilities {
    return [self.store sdl_objectsForName:SDLRPCParameterNameSoftButtonCapabilities ofClass:SDLSoftButtonCapabilities.class error:nil];
}

@end
