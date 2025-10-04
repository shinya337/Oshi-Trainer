import Foundation
import Intents

/// INSendMessageIntentを作成するユーティリティ
class INSendMessageIntentBuilder {
    /// INPersonとメッセージ本文からINSendMessageIntentを作成
    /// - Parameters:
    ///   - person: 送信者となるINPerson
    ///   - message: メッセージ本文
    ///   - conversationId: 会話ID（トレーナーID）
    /// - Returns: INSendMessageIntent
    static func createIntent(
        from person: INPerson,
        message: String,
        conversationId: String
    ) -> INSendMessageIntent {
        // INSendMessageIntentを作成
        let intent = INSendMessageIntent(
            recipients: nil,
            outgoingMessageType: .outgoingMessageText,
            content: message,
            speakableGroupName: INSpeakableString(spokenPhrase: person.displayName),
            conversationIdentifier: conversationId,
            serviceName: "推しトレ",
            sender: person,
            attachments: nil
        )

        // 画像を明示的に設定
        if let personImage = person.image {
            intent.setImage(personImage, forParameterNamed: \INSendMessageIntent.sender)
        }

        print("📨 INSendMessageIntent作成: sender=\(person.displayName), message=\(message)")

        return intent
    }

    /// INInteractionを作成してdonateする
    /// - Parameter intent: INSendMessageIntent
    static func donateInteraction(for intent: INSendMessageIntent) {
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.direction = .incoming

        interaction.donate { error in
            if let error = error {
                print("❌ INInteraction donateエラー: \(error)")
            } else {
                print("✅ INInteraction donateに成功しました")
            }
        }
    }
}
