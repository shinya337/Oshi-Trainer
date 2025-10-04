import Foundation
import UIKit
import Combine

/// トレーナー作成のエラー型
enum TrainerCreationError: Error {
    case nameEmpty
    case imageNotSelected
    case imageSaveFailed
    case dataSaveFailed

    var localizedDescription: String {
        switch self {
        case .nameEmpty:
            return "名前を入力してください"
        case .imageNotSelected:
            return "キャラクター画像を選択してください"
        case .imageSaveFailed:
            return "画像の保存に失敗しました。再度お試しください。"
        case .dataSaveFailed:
            return "データの保存に失敗しました。"
        }
    }
}

/// トレーナー作成画面のViewModel
class TrainerCreationViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var errorMessage: String? = nil
    @Published var isCreating: Bool = false

    // MARK: - Private Properties

    private let dataService: DataServiceProtocol
    private let imagePersistenceService: ImagePersistenceService
    private let audioService: AudioFeedbackServiceProtocol

    // MARK: - Initialization

    init(
        dataService: DataServiceProtocol = UserDefaultsDataService(),
        imagePersistenceService: ImagePersistenceService? = nil,
        audioService: AudioFeedbackServiceProtocol = AudioFeedbackService.shared
    ) {
        self.dataService = dataService

        // ImagePersistenceServiceの初期化（エラー時はデフォルト実装を使用）
        if let service = imagePersistenceService {
            self.imagePersistenceService = service
        } else {
            do {
                self.imagePersistenceService = try ImagePersistenceService()
            } catch {
                print("❌ ImagePersistenceService初期化エラー: \(error)")
                // エラー時は再試行（通常は成功する）
                self.imagePersistenceService = try! ImagePersistenceService()
            }
        }

        self.audioService = audioService
    }

    // MARK: - Public Methods

    /// トレーナーを作成
    func createTrainer(
        name: String,
        image: UIImage,
        themeColor: String,
        personalityType: PersonalityType,
        firstPerson: String?,
        secondPerson: String?,
        characterVoice: String,
        encouragementStyle: EncouragementStyle = .balanced,
        feedbackFrequency: FeedbackFrequency = .medium
    ) async -> Result<OshiTrainerTemplate, TrainerCreationError> {
        // 作成中状態を設定
        await MainActor.run {
            isCreating = true
            errorMessage = nil
        }

        // 入力検証
        let validationResult = validateInput(name: name, image: image)
        if case .failure(let error) = validationResult {
            await MainActor.run {
                isCreating = false
                errorMessage = error.localizedDescription
            }
            return .failure(error)
        }

        // 名前の文字数制限（30文字）
        let trimmedName = String(name.prefix(30))

        // 画像を保存
        let imageSaveResult = imagePersistenceService.saveImage(image)
        guard case .success(let fileName) = imageSaveResult else {
            await MainActor.run {
                isCreating = false
                errorMessage = TrainerCreationError.imageSaveFailed.localizedDescription
            }
            return .failure(.imageSaveFailed)
        }

        // デフォルト値の適用
        let finalFirstPerson = firstPerson?.isEmpty == false ? firstPerson! : personalityType.defaultFirstPerson
        let finalSecondPerson = secondPerson?.isEmpty == false ? secondPerson! : personalityType.defaultSecondPerson

        // OshiTrainerTemplateを生成
        let template = OshiTrainerTemplate(
            name: trimmedName,
            themeColor: themeColor,
            characterImage: fileName,
            personalityType: personalityType,
            firstPerson: finalFirstPerson,
            secondPerson: finalSecondPerson,
            characterVoice: characterVoice,
            encouragementStyle: encouragementStyle,
            feedbackFrequency: feedbackFrequency
        )

        // データサービスに保存
        let saveResult = dataService.saveTrainerTemplate(template)
        if case .failure = saveResult {
            await MainActor.run {
                isCreating = false
                errorMessage = TrainerCreationError.dataSaveFailed.localizedDescription
            }
            return .failure(.dataSaveFailed)
        }

        // 成功 - 作成したトレーナーのIDを一時保存
        await MainActor.run {
            isCreating = false
            UserDefaults.standard.set(template.id.uuidString, forKey: "lastCreatedTrainerId")
        }
        return .success(template)
    }

    /// ボイスサンプルを再生
    func playSampleVoice(voiceName: String) {
        // 既存の再生を停止
        audioService.stopAll()

        // ボイスを切り替え
        audioService.setVoice(voiceName)

        // ランダムなサンプルカテゴリを選択
        let sampleCategories: [() -> Void] = [
            { self.audioService.playRepCount(Int.random(in: 1...10)) },
            { self.audioService.playSessionStart() },
            { self.audioService.playSessionComplete() },
            { self.audioService.playTooFast() }
        ]

        // ランダムに1つ選んで再生
        if let randomSample = sampleCategories.randomElement() {
            randomSample()
        }
    }

    // MARK: - Private Methods

    /// 入力検証
    private func validateInput(name: String, image: UIImage?) -> Result<Void, TrainerCreationError> {
        // 名前が空でないことを確認
        if name.trimmingCharacters(in: .whitespaces).isEmpty {
            return .failure(.nameEmpty)
        }

        // 画像が選択されていることを確認
        if image == nil {
            return .failure(.imageNotSelected)
        }

        return .success(())
    }
}
