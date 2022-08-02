//
//  SDLSend.swift
//  SmartDeviceLinkSwift
//
//  Created by George Miller on 8/2/22.
//  Copyright © 2022 smartdevicelink. All rights reserved.
//

import Foundation

import SmartDeviceLink

/// TODO - documentation comment
public class SDLSend {
    
    /// TODO - documentation comment
    /// how many send functions do I need?
    public class func sendRPC(_ rpcrequest: SDLRPCRequest) {
        //this seems wrong, since I need the same instance of the sdl manager currently in use.
        //why was SDLLogManager able to do this?
        let sdlmanager = SDLManager()
        sdlmanager.send(rpcrequest)
    }
}
