//
//  AudioManager.swift
//  SmartDeviceLink
//
//  Created by Nicole on 4/17/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

import Foundation
import AVFoundation
import SmartDeviceLink
import SmartDeviceLinkSwift

typealias audioRecordingHandler = ((SDLAudioRecordingState) -> Void)

class AudioManager: NSObject {
    fileprivate let sdlManager: SDLManager!
    fileprivate var audioData: Data?
    fileprivate var audioRecordingState: SDLAudioRecordingState

    init(sdlManager: SDLManager) {
        self.sdlManager = sdlManager
        audioData = Data()
        audioRecordingState = .notListening
        super.init()
    }

    func stopManager() {
        audioRecordingState = .notListening
        audioData = Data()
    }

    /// Starts an audio recording using the in-car microphone. During the recording, a pop-up will let the user know that they are being recorded. The pop-up is only dismissed when the recording stops.
    func startRecording() {
        guard audioRecordingState == .notListening else { return }

        let recordingDurationMilliseconds: UInt32 = 5000
        let performAudioPassThru = SDLPerformAudioPassThru(initialPrompt: "Starting sound recording", audioPassThruDisplayText1: "Say Something", audioPassThruDisplayText2: "Recording for \(recordingDurationMilliseconds / 1000) seconds", samplingRate: .rate16KHZ, bitsPerSample: .sample16Bit, audioType: .PCM, maxDuration: recordingDurationMilliseconds, muteAudio: true, audioDataHandler: audioDataReceivedHandler)

        sdlManager.send(request: performAudioPassThru, responseHandler: audioPassThruEndedHandler)
    }

    /// Manually stops an on-going audio recording.
    func stopRecording() {
        guard audioRecordingState == .listening else { return }
        audioRecordingState = .notListening

        let endAudioPassThruRequest = SDLEndAudioPassThru()
        sdlManager.send(endAudioPassThruRequest)
    }
}


// MARK: - Audio Pass Thru Notifications

private extension AudioManager {
    /// SDL streams the audio data as it is collected.
    var audioDataReceivedHandler: SDLAudioPassThruHandler? {
        return { [unowned self] data in
            guard data != nil else { return }
            if self.audioRecordingState == .notListening {
                self.audioData = Data()
                self.audioRecordingState = .listening
            }
            self.audioData!.append(data!)
        }
    }

    /// Called when `PerformAudioPassThru` request times out or when a `EndAudioPassThru` request is sent
    ///
    /// - Parameter response: A SDLRPCNotificationNotification notification
    var audioPassThruEndedHandler: SDLResponseHandler? {
        return { [unowned self] (request, response, error) in
            guard let response = response else { return }
            self.audioRecordingState = .notListening

            switch response.resultCode {
            case .success: // The `PerformAudioPassThru` timed out or the "Done" button was pressed in the pop-up.
                if let audioData = self.audioData, audioData.count == 0 {
                     self.sdlManager.send(AlertManager.alertWithMessageAndCloseButton("No audio recorded"))
                } else {
                    let pcmBuffer = self.convertDataToPCMFormattedAudio(self.audioData!)
                    self.sdlManager.send(AlertManager.alertWithMessageAndCloseButton("Audio recorded!", textField2: "\(pcmBuffer)"))
                }
            case .aborted: // The "Cancel" button was pressed in the pop-up. Ignore this audio pass thru.
                self.audioData = Data()
                self.sdlManager.send(AlertManager.alertWithMessageAndCloseButton("Recording canceled"))
            default:
                self.audioData = Data()
                self.sdlManager.send(AlertManager.alertWithMessageAndCloseButton("Recording unsuccessful", textField2: "\(response.resultCode.rawValue.rawValue)"))
            }
        }
    }
}


// MARK: - Audio Data Conversion

private extension AudioManager {
    /// Converts the audio data to PCM formatted audio that can be passed, if desired, to the iOS SFSpeech framework (SDL does not provide speech recognition, however the SFSpeech framework or another third party library can be used for speech recognition). The audio format and sample rate should match those set in the `SDLPerformAudioPassThru`.
    ///
    /// - Parameter data: The audio data
    /// - Returns: An AVAudioPCMBuffer object
    func convertDataToPCMFormattedAudio(_ data: Data) -> AVAudioPCMBuffer {
        let audioFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 16000, channels: 1, interleaved: false)
        let numFrames = UInt32(data.count) / (audioFormat.streamDescription.pointee.mBytesPerFrame)
        let buffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: numFrames)
        buffer.frameLength = numFrames
        let bufferChannels = buffer.int16ChannelData!
        let bufferDataCount = data.copyBytes(to: UnsafeMutableBufferPointer(start: bufferChannels[0], count: data.count))

        SDLLog.d("Audio data has \(bufferDataCount) bytes in \(buffer)")

        return buffer
    }
}

