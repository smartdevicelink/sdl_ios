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
import Speech

typealias audioRecordingHandler = ((SDLAudioRecordingState) -> Void)

fileprivate enum SearchManagerState {
    case listening, notListening, notAuthorized, badRegion
}

@available(iOS 10.0, *)
class AudioManager: NSObject {
    fileprivate let sdlManager: SDLManager!
    fileprivate var audioData: Data?
    fileprivate var audioRecordingState: SDLAudioRecordingState
    fileprivate var speechRecognitionListenState: SearchManagerState

    // Speech recognition
    fileprivate var speechRecognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    fileprivate var speechRecognizer: SFSpeechRecognizer?
    fileprivate var speechRecognitionTask: SFSpeechRecognitionTask?
    private let speechDefaultLocale = Locale(identifier: "en-US")

    init(sdlManager: SDLManager) {
        self.sdlManager = sdlManager
        audioData = Data()
        audioRecordingState = .notListening
        speechRecognizer = SFSpeechRecognizer(locale: speechDefaultLocale)
        speechRecognitionListenState = .notAuthorized

        super.init()

        speechRecognizer?.delegate = self
        speechRecognitionListenState = AudioManager.checkAuthorization(speechRecognizer: speechRecognizer)

        if speechRecognitionListenState == .notAuthorized {
            requestSFSpeechRecognizerAuthorization()
        }
    }

    func stopManager() {
        audioRecordingState = .notListening
        audioData = Data()
    }

    /// Starts an audio recording using the in-car microphone. During the recording, a pop-up will let the user know that they are being recorded. The pop-up is only dismissed when the recording stops.
    func startRecording() {
        guard audioRecordingState == .notListening else { return }

        startSpeechRecognitionTask()

        let recordingDurationMilliseconds: UInt32 = 6000
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

@available(iOS 10.0, *)
private extension AudioManager {
    /// SDL streams the audio data as it is collected.
    var audioDataReceivedHandler: SDLAudioPassThruHandler? {
        return { [weak self] data in
            guard let data = data else { return }
            if self?.audioRecordingState == .notListening {
                self?.audioData = Data()
                self?.audioRecordingState = .listening
            }

            guard let buffer = self?.createPCMBuffer(with: data) else { return }
            self?.speechRecognitionRequest!.append(buffer)
        }
    }

    /// Called when `PerformAudioPassThru` request times out or when a `EndAudioPassThru` request is sent
    ///
    /// - Parameter response: A SDLRPCNotificationNotification notification
    var audioPassThruEndedHandler: SDLResponseHandler? {
        return { [weak self] (request, response, error) in
            guard let response = response else { return }

            switch response.resultCode {
            case .success: // The `PerformAudioPassThru` timed out or the "Done" button was pressed in the pop-up.
                SDLLog.d("Audio Pass Thru ended successfully")
            case .aborted: // The "Cancel" button was pressed in the pop-up. Ignore this audio pass thru.
                SDLLog.d("Audio recording canceled")
                // self?.audioData = Data()
                // self?.sdlManager.send(AlertManager.alertWithMessageAndCloseButton("Recording canceled"))
            default:
                SDLLog.d("Audio recording something happened?: \(response.resultCode)")
                // self?.audioData = Data()
                // self?.sdlManager.send(AlertManager.alertWithMessageAndCloseButton("Recording unsuccessful", textField2: "\(response.resultCode.rawValue.rawValue)"))
            }

            self?.stopSpeechRecognitionTask()
        }
    }
}

// MARK: - Audio Data Conversion

@available(iOS 10.0, *)
private extension AudioManager {
    /// Converts the audio data to PCM formatted audio that can be passed, if desired, to the iOS SFSpeech framework (SDL does not provide speech recognition, however the SFSpeech framework or another third party library can be used for speech recognition). The audio format and sample rate should match those set in the `SDLPerformAudioPassThru`.
    ///
    /// - Parameter data: The audio data
    /// - Returns: An AVAudioPCMBuffer object
    func createPCMBuffer(with data: Data) -> AVAudioPCMBuffer {
        audioData?.append(data)

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

@available(iOS 10.0, *)
private extension AudioManager {
    func startSpeechRecognitionTask() {
        speechRecognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let speechRecognitionRequest = speechRecognitionRequest, let speechRecognizer = speechRecognizer else {
            SDLLog.e("Unable to do speech recognition")
            return
        }

        speechRecognitionRequest.shouldReportPartialResults = true
        speechRecognitionRequest.taskHint = .search

        speechRecognitionTask = speechRecognizer.recognitionTask(with: speechRecognitionRequest) { [weak self] result, error in
            print("Audio: \(String(describing: result)), error: \(String(describing: error))")
            guard let result = result else { return }

            if error != nil {
                SDLLog.e("Speech recognition error: \(error!.localizedDescription)")
            }

            let speechTranscription = result.bestTranscription.formattedString
            if result.isFinal {
                SDLLog.d("Ongoing transcription: \(speechTranscription)")
            } else {
                self?.sdlManager.send(AlertManager.alertWithMessageAndCloseButton("You said: \(speechTranscription.isEmpty ? "No speech detected" : speechTranscription)"))
            }
        }
    }

    /// Cleans up a speech detection session that has ended
    func stopSpeechRecognitionTask() {
        audioRecordingState = .notListening

        if speechRecognitionTask != nil {
            speechRecognitionTask!.cancel()
            // speechRecognitionTask = nil
        }

        if speechRecognitionRequest != nil {
            speechRecognitionRequest!.endAudio()
            // speechRecognitionRequest = nil
        }
    }
}

// MARK: - SFSpeechRecognizerDelegate

@available(iOS 10.0, *)
extension AudioManager: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        speechRecognitionListenState = AudioManager.checkAuthorization(speechRecognizer: speechRecognizer)
    }

    fileprivate static func checkAuthorization(speechRecognizer: SFSpeechRecognizer?) -> SearchManagerState {
        // Check the speech recognizer init'd successfully
        guard speechRecognizer != nil else {
            return .badRegion
        }

        // Check auth status
        switch SFSpeechRecognizer.authorizationStatus() {
        case .authorized:
            return .notListening
        default:
            return .notAuthorized
        }
    }
}

@available(iOS 10.0, *)
private extension AudioManager {
    func requestSFSpeechRecognizerAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            /* The callback may not be called on the main thread. Add an
             operation to the main queue to update the record button's state.
             */
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.speechRecognitionListenState = .listening
                default:
                    self.speechRecognitionListenState = .notAuthorized
                }
            }
        }
    }
}

