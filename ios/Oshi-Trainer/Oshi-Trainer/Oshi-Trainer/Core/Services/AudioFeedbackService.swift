import AVFoundation
import UIKit

/// オーディオフィードバックを提供するサービスのプロトコル
protocol AudioFeedbackServiceProtocol {
    /// 音声フィードバックを再生
    func playSound(_ soundType: SoundType)
    /// バイブレーションフィードバックを提供
    func hapticFeedback(_ feedbackType: HapticFeedbackType)
    /// すべての再生を停止
    func stopAll()
    /// ボイスを設定
    func setVoice(_ voiceName: String)
    /// レップカウント音声を再生
    func playRepCount(_ count: Int)
    /// セッション開始音声を再生
    func playSessionStart()
    /// セッション完了音声を再生
    func playSessionComplete()
    /// 速すぎる警告音声を再生
    func playTooFast()
}

/// サウンドタイプ
enum SoundType {
    case buttonTap
    case success
    case error
    case notification
}

/// ハプティックフィードバックタイプ
enum HapticFeedbackType {
    case light
    case medium
    case heavy
    case success
    case warning
    case error
}

/// オーディオフィードバックサービスの実装
final class AudioFeedbackService: AudioFeedbackServiceProtocol {
    static let shared = AudioFeedbackService()

    private let synthesizer = AVSpeechSynthesizer()
    private var currentVoice: AVSpeechSynthesisVoice?

    private init() {
        // デフォルトで日本語ボイスを設定
        currentVoice = AVSpeechSynthesisVoice(language: "ja-JP")
    }

    func playSound(_ soundType: SoundType) {
        let systemSoundID: SystemSoundID

        switch soundType {
        case .buttonTap:
            systemSoundID = 1104 // Tock
        case .success:
            systemSoundID = 1054 // SMS Received
        case .error:
            systemSoundID = 1053 // SMS Alert
        case .notification:
            systemSoundID = 1007 // New Mail
        }

        AudioServicesPlaySystemSound(systemSoundID)
    }

    func hapticFeedback(_ feedbackType: HapticFeedbackType) {
        switch feedbackType {
        case .light:
            let impactGenerator = UIImpactFeedbackGenerator(style: .light)
            impactGenerator.impactOccurred()
        case .medium:
            let impactGenerator = UIImpactFeedbackGenerator(style: .medium)
            impactGenerator.impactOccurred()
        case .heavy:
            let impactGenerator = UIImpactFeedbackGenerator(style: .heavy)
            impactGenerator.impactOccurred()
        case .success:
            let notificationGenerator = UINotificationFeedbackGenerator()
            notificationGenerator.notificationOccurred(.success)
        case .warning:
            let notificationGenerator = UINotificationFeedbackGenerator()
            notificationGenerator.notificationOccurred(.warning)
        case .error:
            let notificationGenerator = UINotificationFeedbackGenerator()
            notificationGenerator.notificationOccurred(.error)
        }
    }

    func stopAll() {
        synthesizer.stopSpeaking(at: .immediate)
    }

    func setVoice(_ voiceName: String) {
        // ボイス名で検索
        if let voice = AVSpeechSynthesisVoice.speechVoices().first(where: { $0.name == voiceName }) {
            currentVoice = voice
        } else {
            // 見つからない場合はデフォルトの日本語ボイスを使用
            currentVoice = AVSpeechSynthesisVoice(language: "ja-JP")
        }
    }

    func playRepCount(_ count: Int) {
        speak("\(count)回目")
    }

    func playSessionStart() {
        speak("トレーニング開始")
    }

    func playSessionComplete() {
        speak("お疲れ様でした")
    }

    func playTooFast() {
        speak("もう少しゆっくり")
    }

    private func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = currentVoice
        utterance.rate = 0.5
        utterance.pitchMultiplier = 1.0
        utterance.volume = 1.0
        synthesizer.speak(utterance)
    }
}
