//
//  AudioManager.swift
//  SmartDeviceLink
//
//  Created by Nicole on 4/17/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

import Foundation
import SmartDeviceLink
import SmartDeviceLinkSwift
import Speech

fileprivate enum AudioRecordingState {
    case listening, notListening
}

fileprivate enum SpeechRecognitionAuthState {
    case authorized, notAuthorized, badRegion
}

class AudioManager: NSObject {
    fileprivate let sdlManager: SDLManager
    fileprivate var audioData: Data?
    fileprivate var audioRecordingState: AudioRecordingState

    fileprivate var speechRecognitionAuthState: SpeechRecognitionAuthState
    fileprivate var speechRecognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    fileprivate var speechRecognizer: SFSpeechRecognizer?
    fileprivate var speechRecognitionTask: SFSpeechRecognitionTask?
    fileprivate var speechTranscription: String = ""
    private let speechDefaultLocale = Locale(identifier: "en-US")

    init(sdlManager: SDLManager) {
        self.sdlManager = sdlManager
        audioData = Data()
        audioRecordingState = .notListening
        speechRecognitionAuthState = .notAuthorized
        speechRecognizer = SFSpeechRecognizer(locale: speechDefaultLocale)

        super.init()

        speechRecognizer?.delegate = self
        speechRecognitionAuthState = AudioManager.checkAuthorization(speechRecognizer: speechRecognizer)

        if speechRecognitionAuthState != .authorized {
            requestSFSpeechRecognizerAuthorization()
        }
    }

    /// Resets the manager to its default values
    func stopManager() {
        audioRecordingState = .notListening
        audioData = Data()
        speechTranscription = ""
    }

    /// Starts an audio recording using the in-car microphone. During the recording, a pop-up will let the user know that they are being recorded. The pop-up is only dismissed when the recording stops.
    func startRecording() {
        guard speechRecognitionAuthState == .authorized else {
            SDLLog.w("This app does not have permission to access the Speech Recognition API")
            AlertManager.sendAlert(textField1: AlertSpeechPermissionsWarningText, sdlManager: sdlManager)
            return
        }

        guard audioRecordingState == .notListening else {
            SDLLog.w("Audio recording already in progress")
            return
        }

        startSpeechRecognitionTask()
        let recordingDurationMilliseconds: UInt32 = 10000
        let performAudioPassThru = SDLPerformAudioPassThru(initialPrompt: "Starting sound recording", audioPassThruDisplayText1: "Say Something", audioPassThruDisplayText2: "Recording for \(recordingDurationMilliseconds / 1000) seconds", samplingRate: .rate16KHZ, bitsPerSample: .sample16Bit, audioType: .PCM, maxDuration: recordingDurationMilliseconds, muteAudio: true, audioDataHandler: audioDataReceivedHandler)

        sdlManager.send(request: performAudioPassThru, responseHandler: audioPassThruEndedHandler)
    }

    /// Manually stop an ongoing audio recording.
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
        return { [weak self] data in
            guard let data = data else { return }
            if self?.audioRecordingState == .notListening {
                self?.audioRecordingState = .listening
            }

            guard let buffer = self?.createPCMBuffer(with: data) else { return }
            self?.speechRecognitionRequest!.append(buffer)
        }
    }

    /// Called when `PerformAudioPassThru` request times out or when a `EndAudioPassThru` request is sent
    var audioPassThruEndedHandler: SDLResponseHandler? {
        return { [weak self] (request, response, error) in
            guard let self = self, let response = response else { return }

            switch response.resultCode {
            case .success: // The `PerformAudioPassThru` timed out or the "Done" button was pressed in the pop-up.
                SDLLog.d("Audio Pass Thru ended successfully")
                AlertManager.sendAlert(textField1: "You said: \(self.speechTranscription.isEmpty ? "No speech detected" : self.speechTranscription)", sdlManager: self.sdlManager)
            case .aborted: // The "Cancel" button was pressed in the pop-up. Ignore this audio pass thru.
                SDLLog.d("Audio recording canceled")
            default:
                SDLLog.d("Audio recording not successful: \(response.resultCode)")
            }

            self.stopSpeechRecognitionTask()
        }
    }

    /// Converts the audio data to PCM formatted audio that can be passed, if desired, to the iOS SFSpeech framework (SDL does not provide speech recognition, however the SFSpeech framework or another third party library can be used for speech recognition). The audio format and sample rate should match those set in the `SDLPerformAudioPassThru`.
    ///
    /// - Parameter data: The audio data
    /// - Returns: An AVAudioPCMBuffer object
    func createPCMBuffer(with data: Data) -> AVAudioPCMBuffer? {
        audioData?.append(data)

        guard let audioFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 16000, channels: 1, interleaved: false) else { return nil }
        let numFrames = UInt32(data.count) / (audioFormat.streamDescription.pointee.mBytesPerFrame)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: numFrames) else  { return nil }
        buffer.frameLength = numFrames
        let bufferChannels = buffer.int16ChannelData!
        let bufferDataCount = data.copyBytes(to: UnsafeMutableBufferPointer(start: bufferChannels[0], count: data.count))

        SDLLog.v("Audio data has \(bufferDataCount) bytes in \(buffer)")

        return buffer
    }
}

// MARK: - Speech Recognition

private extension AudioManager {
    /// Configures speech recognition
    func startSpeechRecognitionTask() {
        speechRecognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let speechRecognitionRequest = speechRecognitionRequest, let speechRecognizer = speechRecognizer else {
            SDLLog.e("Unable to do speech recognition")
            return
        }

        speechRecognitionRequest.shouldReportPartialResults = true
        speechRecognitionRequest.taskHint = .search

        speechRecognitionTask = speechRecognizer.recognitionTask(with: speechRecognitionRequest) { [weak self] result, error in
            guard let result = result else { return }

            if error != nil {
                SDLLog.e("Speech recognition error: \(error!.localizedDescription)")
            }

            let speechTranscription = result.bestTranscription.formattedString
            SDLLog.d("Ongoing transcription: \(speechTranscription)")
            self?.speechTranscription = speechTranscription
        }
    }

    /// Cleans up a speech detection session that has ended
    func stopSpeechRecognitionTask() {
        audioRecordingState = .notListening
        audioData = Data()
        speechTranscription = ""

        guard self.speechRecognitionTask != nil, self.speechRecognitionRequest != nil else { return }
        self.speechRecognitionTask!.cancel()
        self.speechRecognitionRequest!.endAudio()
        self.speechRecognitionTask = nil
        self.speechRecognitionRequest = nil
    }
}

// MARK: - Speech Recognition Authorization

extension AudioManager: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        speechRecognitionAuthState = AudioManager.checkAuthorization(speechRecognizer: speechRecognizer)
    }

    /// Checks the current authorization status of the Speech Recognition API. The user can change this status via the native Settings app.
    ///
    /// - Parameter speechRecognizer: The SFSpeechRecognizer
    /// - Returns: The current authorization status
    fileprivate static func checkAuthorization(speechRecognizer: SFSpeechRecognizer?) -> SpeechRecognitionAuthState {
        // Check if the speech recognizer init'd successfully
        guard speechRecognizer != nil else {
            return .badRegion
        }

        // Check authorization status
        switch SFSpeechRecognizer.authorizationStatus() {
        case .authorized:
            return .authorized
        default:
            return .notAuthorized
        }
    }

    /// Asks the user via an alert if they want to authorize this app to access the Speech Recognition API.
    fileprivate func requestSFSpeechRecognizerAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.speechRecognitionAuthState = .authorized
                default:
                    self.speechRecognitionAuthState = .notAuthorized
                }
            }
        }
    }
}

