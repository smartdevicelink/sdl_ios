//
//  SDLMacros.h
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 10/17/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#ifndef SDLMacros_h
#define SDLMacros_h

#ifndef SDL_SUPPORTS_CLASS_PROPERTIES
    #if defined(SWIFT_CLASS_EXTRA)
        #define SDL_SUPPORTS_CLASS_PROPERTIES FOUNDATION_SWIFT_SDK_EPOCH_AT_LEAST(8)
    #else
        #define SDL_SUPPORTS_CLASS_PROPERTIES NO
    #endif
#endif

#endif /* SDLMacros_h */
