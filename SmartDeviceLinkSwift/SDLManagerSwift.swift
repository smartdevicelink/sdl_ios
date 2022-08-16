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
    @available(iOS 13.0.0, *)
    //pass in the request.
    //instead of passing in the response handler, the response handler is done in the continueation, which is called when the internal send returns
    public class func sendRPCRequest(_ request: SDLRPCRequest, using manager: SDLManager) async throws -> (SDLRPCRequest, SDLRPCResponse){
        try await withCheckedThrowingContinuation{ continuation in
            manager.send(request: request) {req, res, err in
                if let error = err {
                    continuation.resume(throwing: error)
                } else if let request = req, let response = res {
                    continuation.resume(returning: (request, response))
                } else {
                    continuation.resume(throwing: SendError.unknownError)
                }
            }
        }
    }
    
    
    
    enum SendError: Error {
        case unknownError
    }
    
}
