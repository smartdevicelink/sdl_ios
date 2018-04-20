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

typealias audioRecordingHandler = ((AudioRecordingState) -> Void)

enum AudioRecordingState {
    case listening, notListening
}

class AudioManager: NSObject {
    fileprivate let sdlManager: SDLManager!
    fileprivate var audioData: Data?
    fileprivate var audioRecordingState: AudioRecordingState

    init(sdlManager: SDLManager) {
        self.sdlManager = sdlManager
        audioData = Data()
        audioRecordingState = .notListening
        super.init()

        NotificationCenter.default.addObserver(self, selector: #selector(audioPassThruEnded(response:)), name: SDLDidReceivePerformAudioPassThruResponse, object: nil)
    }

    func stopManager() {
        audioRecordingState = .notListening
        audioData = Data()
    }

    /// Starts an audio recording using the in-car microphone. During the recording, a pop-up will let the user know that they are being recorded. The pop-up is only dismissed when the recording stops.
    func startRecording() {
        guard audioRecordingState == .notListening else { return }

        let recordingDurationMilliseconds: UInt32 = 5000
        let audioPassThruRequest = SDLPerformAudioPassThru(initialPrompt: "Starting sound recording", audioPassThruDisplayText1: "Say Something", audioPassThruDisplayText2: "Recording for \(recordingDurationMilliseconds / 1000) seconds", samplingRate: .rate16KHZ, bitsPerSample: .sample16Bit, audioType: .PCM, maxDuration: recordingDurationMilliseconds, muteAudio: true, audioDataHandler: audioDataHandler)

        sdlManager.send(request: audioPassThruRequest)
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

extension AudioManager {
    /// SDL streams the audio data as it is collected.
    fileprivate var audioDataHandler: SDLAudioPassThruHandler? {
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
    @objc func audioPassThruEnded(response: SDLRPCResponseNotification) {
        guard audioRecordingState == .listening else { return }
        audioRecordingState = .notListening

        switch response.response.resultCode {
        case .success: // The `PerformAudioPassThru` timed out or the "Done" button was pressed in the pop-up.
            if audioData == nil {
                 sdlManager.send(AlertManager.alertWithMessageAndCloseButton("No audio recorded"))
            } else {
                // `audioData` contains the complete audio recording for the pass thru. SDL does not provide speech recognition, however the iOS Speech API or another third party library can be used for speech reconition.
                let pcmBuffer = convertDataToPCMFormattedAudio(audioData!)
                sdlManager.send(AlertManager.alertWithMessageAndCloseButton("Audio recorded!", textField2: "\(pcmBuffer)"))
            }
        case .aborted: // The "Cancel" button was pressed in the pop-up. Ignore this audio pass thru.
            audioData = Data()
            sdlManager.send(AlertManager.alertWithMessageAndCloseButton("Recording cancelled"))
        default:
            sdlManager.send(AlertManager.alertWithMessageAndCloseButton("Recording unsuccessful", textField2: "\(response.response.resultCode.rawValue.rawValue)"))
        }
    }
}


// MARK: - Audio Data Conversion

private extension AudioManager {
    /// Converts the audio data to PCM formatted audio that can be passed to iOS SFSpeech Framework, if desired. When doing the converstion, the audio format and sample rate should match those set in the `SDLPerformAudioPassThru`.
    ///
    /// - Parameter data: The audio data
    /// - Returns: A AVAudioPCMBuffer object
    func convertDataToPCMFormattedAudio(_ data: Data) -> AVAudioPCMBuffer {
        //
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

