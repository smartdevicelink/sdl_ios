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
        stopRecording()
    }

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
}


// MARK: - Audio Pass Thru Notifications

extension AudioManager {
    /// Called when an audio chunk is recorded.
    ///
    /// - Parameter notification: A SDLRPCNotificationNotification notification
    @objc func audioPassThruDataReceived(notification: SDLRPCNotificationNotification) {
        guard let data = notification.notification.bulkData else {
            return
        }

        // Current audio chunk
        // let _ = AudioManager.convertDataToPCMFormattedAudio(data)
        convertDataToPCMFormattedAudio(data)

        // Save the sound chunk
        audioData.append(data)
    }

    /// Called after a `SDLEndAudioPassThru` request is sent or when a `SDLPerformAudioPassThru` request times out
    ///
    /// - Parameter response: A SDLRPCNotificationNotification notification
    @objc func audioPassThruEnded(response: SDLRPCResponseNotification) {
        guard response.response.success.boolValue == true else {
            return
        }

        // `audioData` contains the complete audio recording for the pass thru. SDL does not provide speech recognition, however the iOS Speech API or another third party library can be used for speech reconition.
        playRecording(audioData)
    }
}


// MARK: - Audio Pass Thru

private extension AudioManager {
    func playRecording(_ data: Data) {
        var recording: AVAudioPlayer?
        do {
            recording = try AVAudioPlayer(data: data)
            recording?.play()
        } catch {
            SDLLog.e("Failed to play recording")
        }
    }

    func convertDataToPCMFormattedAudio(_ data: Data) {
        // Currently, SDL only supports Sampling Rates of 16 khz and Bit Rates of 16 bit.
        let audioFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 16000, channels: 1, interleaved: false)
        let numFrames = UInt32(data.count) / (audioFormat.streamDescription.pointee.mBytesPerFrame)
        let buffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: numFrames)
        buffer.frameLength = numFrames
        let bufferChannels = buffer.int16ChannelData!
        let bufferDataCount = data.copyBytes(to: UnsafeMutableBufferPointer(start: bufferChannels[0], count: data.count))

        // print("Sound chunk has \(bufferDataCount) bytes in \(buffer)")
        //        print("PCM: frame capacity: \(buffer.frameCapacity)")
        //        print("PCM: frame length: \(buffer.frameLength)")
        //
        let elements16 = UnsafeBufferPointer(start: buffer.int16ChannelData?[0], count:data.count)
        var samples = [Int16]()
        for i in stride(from: 0, to: buffer.frameLength, by: 1) {
            samples.append(elements16[Int(i)])
            let decibles = Float(AudioManager.computeDecibels(samples[Int(i)]))
            print("decibles: \(decibles)")

            guard let floorAudioDb = floorAudioDb, decibles != 0 else {
                self.floorAudioDb = floorf(decibles) + 5
                return
            }

            if decibles > floorAudioDb {
                audioRecordingState = .listening
                numberOfSilentPasses = 0
                print("not silent")
            } else {
                numberOfSilentPasses += 1
                print("silent")
            }

            if numberOfSilentPasses == 30 {
                print("silent chunk")
            }
        }
    }

    //    class func checkAmplitude(_ data: Data) {
    //        let pcmAudio = convertDataToPCMFormattedAudio(data)
    //
    //        let elements16 = UnsafeBufferPointer(start: pcmAudio.int16ChannelData?[0], count:data.count)
    //        var samples = [Int16]()
    //        for i in stride(from: 0, to: pcmAudio.frameLength, by: 1) {
    //            samples.append(elements16[Int(i)])
    //            let decibles = computeDecibels(samples[Int(i)])
    //            print("sample: \(samples[Int(i)]), decibles: \(decibles)")
    //        }
    //    }

    func computeSilentPasses(_ silentPassesCount: Int) {
        if audioRecordingState == .listening && numberOfSilentPasses == 30 {
            audioRecordingState = .notListening
            numberOfSilentPasses = 0
            stopRecording()
        }
    }

    func computeSilentPasses(_ currentDb: Float) -> Int {
        guard let floorAudioDb = floorAudioDb else {
            self.floorAudioDb = floorf(currentDb) + 5;
            return 0
        }

        if currentDb > floorAudioDb {
            audioRecordingState = .listening
            numberOfSilentPasses = 0
        } else {
            numberOfSilentPasses += 1
        }

        return numberOfSilentPasses
    }

    //    class func computeAmplitude(_ data: Data) {
    //        let pcmBuffer = convertDataToPCMFormattedAudio(data)
    //
    //        let channelData = UnsafeBufferPointer(start: pcmBuffer.int16ChannelData?[0], count:data.count)
    //        var samples = [Int16]()
    //        for i in stride(from: 0, to: pcmBuffer.frameLength, by: 1) {
    //            samples.append(channelData[Int(i)])
    //            // let decibels = computeDecibels(samples[Int(i)])
    //            print("sample: \(samples[Int(i)])")
    //        }
    //    }

    // https://stackoverflow.com/questions/2445756/how-can-i-calculate-audio-db-level
    class func computeDecibels(_ sample: Int16) -> Double {
        let amplitude = Double(sample) / Double(Int16.max)
        guard amplitude > 0 else { return 0 }

        let decibels = 20 * log10(amplitude)
        return decibels
    }
}

