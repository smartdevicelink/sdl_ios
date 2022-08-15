//
//  SDLManagerSwift.swift
//  SmartDeviceLinkSwift
//
//  Created by George Miller on 8/8/22.
//  Copyright © 2022 smartdevicelink. All rights reserved.
//

import Foundation

import SmartDeviceLink

public class SDLManagerSwift {
    
    public class func sendRPC(rpc: SDLRPCMessage) -> Void{
        do {
            try await(SDLManager.send(rpc));
        } catch {
            //my dude, an error has occured
        }
    }

    public class func sendRequest(request:SDLRPCRequest){
        sendRequest(request: request, responseHandler: nil)
    }
    
    public class func sendRequest(request: SDLRPCRequest, responseHandler:handler()->Void){
        SDLManager.send(request: request, responseHandler: responseHandler);
    }
    
    public class func sendRequest(request: SDLRPCRequest, progressHandler: progressHandler()->Void ,responseHandler:handler()->Void){
        SDLManager.send(request: request, progressHandler: progressHandler  responseHandler: responseHandler);
    }
}
