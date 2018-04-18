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

private enum SearchManagerState {
    case listening, notListening
}

class AudioManager: NSObject {
    fileprivate let sdlManager: SDLManager!
    fileprivate var audioData = Data()
    fileprivate var audioRecordingState: SearchManagerState

    fileprivate var floorAudioDb: Float?
    fileprivate var numberOfSilentPasses = 0;


    init(sdlManager: SDLManager) {
        self.sdlManager = sdlManager
        audioRecordingState = .notListening
        super.init()

        NotificationCenter.default.addObserver(self, selector: #selector(audioPassThruDataReceived(notification:)), name: .SDLDidReceiveAudioPassThru, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(audioPassThruEnded(response:)), name: SDLDidReceivePerformAudioPassThruResponse, object: nil)
    }

    func stop() {
        NotificationCenter.default.removeObserver(self)
        stopRecording()
    }
}


// MARK: - Audio Pass Thru Notifications

extension AudioManager {
    @objc func audioPassThruDataReceived(notification: SDLRPCNotificationNotification) {
        // This audio data is only the current chunk of audio data
        guard let data = notification.notification.bulkData else {
            return
        }

        // Check Db level for the current audio chunk
        AudioManager.convertDataToPCMFormattedAudio(data)

        // Save the audio chunk
        audioData.append(data)
    }

    // Can be triggered by an SDLEndAudioPassThru request or when a `SDLPerformAudioPassThru` requst times out
    @objc func audioPassThruEnded(response: SDLRPCResponseNotification) {
        guard response.response.success.boolValue == true else {
            return
        }

        // Do something with the audio recording. SDL does not provide speech recognition, however the iOS Speech APIs or another third party library can be used for speech reconition. The `convertDataToPCMFormattedAudio()` method is an example of how to convert the audio data to PCM formatted audio to be used with the iOS SFSpeech framework.
    }
}


// MARK: - Audio Pass Thru

private extension AudioManager {
    func startRecording() {
        guard audioRecordingState == .notListening else { return }
        audioData = Data()

        let audioPassThruRequest = SDLPerformAudioPassThru(initialPrompt: nil, audioPassThruDisplayText1: "Listening", audioPassThruDisplayText2: "Say something...", samplingRate: .rate16KHZ, bitsPerSample: .sample16Bit, audioType: .PCM, maxDuration: 5000, muteAudio: true)

        sdlManager.send(request: audioPassThruRequest) { (_, response, error) in
            SDLLog.d("Audio Pass Thru request sent \(response?.resultCode == .success ? "successfully" : "unsuccessfully"). Error: \(error != nil ? error!.localizedDescription : "no error")")
        }
    }

    func stopRecording() {
        guard audioRecordingState == .listening else { return }
        audioRecordingState = .notListening

        let endAudioPassThruRequest = SDLEndAudioPassThru()
        sdlManager.send(endAudioPassThruRequest)
    }

    func playRecording(_ data: Data) {
        var recording: AVAudioPlayer?
        do {
            recording = try AVAudioPlayer(data: data)
            recording?.play()
        } catch {
            SDLLog.e("Failed to play recording")
        }
    }

    class func convertDataToPCMFormattedAudio(_ data: Data) -> AVAudioPCMBuffer {
        // Currently, SDL only supports Sampling Rates of 16 khz and Bit Rates of 16 bit.
        let audioFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 16000, channels: 1, interleaved: false)
        let numFrames = UInt32(data.count) / (audioFormat.streamDescription.pointee.mBytesPerFrame)
        let buffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: numFrames)
        buffer.frameLength = numFrames
        let bufferChannels = buffer.int16ChannelData!
        let bufferDataCount = data.copyBytes(to: UnsafeMutableBufferPointer(start: bufferChannels[0], count: data.count))

        SDLLog.d("PCM Data has \(bufferDataCount) bytes in buffer: \(buffer)")
        return buffer
    }

    func computeSilentPasses(_ currentDataChunk: Data) {
        let currentDb: Float = 0 // db
        guard let floorAudioDb = floorAudioDb else {
            self.floorAudioDb = floorf(currentDb) + 5;
            return
        }

        if currentDb > floorAudioDb {
            audioRecordingState = .listening
            numberOfSilentPasses = 0
        } else {
            numberOfSilentPasses += 1
        }

        if audioRecordingState == .listening && numberOfSilentPasses == 30 {
            audioRecordingState = .notListening
            numberOfSilentPasses = 0
            stopRecording()
        }
    }

    // https://stackoverflow.com/questions/2445756/how-can-i-calculate-audio-db-level
    class func computeVolumeRMS(_ currentDataChunk: Data) {
        let amplitude = 0 / 32767.0
        let dB = 20 * log10(amplitude)
        // https://stackoverflow.com/questions/5800649/detect-silence-when-recording/5800854#5800854
    }
}
