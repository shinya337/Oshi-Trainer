import Foundation

/// ツンデレ性格のテンプレートセリフ提供サービス
struct DialogueTemplateProvider {
    /// セリフのカテゴリー
    enum DialogueCategory {
        case greeting       // 初回・日常挨拶
        case trainingStart  // トレーニング開始時
        case encouragement  // 応援・励まし
        case shyReaction    // 照れ隠し・ツンデレ反応
    }

    /// 挨拶セリフ（一人称「うち」、二人称「あんた」を使用）
    private static let greetingDialogues = [
        "べ、別にあんたのために待ってたわけじゃないんだからね！",
        "おはよう...って、うちが言いたかったのよ",
        "今日も...一緒にトレーニングするの？",
        "あんたが来るの、遅いんじゃない...？",
        "うち、ずっと待ってた...わけじゃないわよ！"
    ]

    /// トレーニング開始セリフ
    private static let trainingStartDialogues = [
        "うちと一緒にトレーニング...するのね",
        "別に嬉しくなんかないんだから！でも...頑張りなさいよ",
        "あんたのためじゃなくて、うちが付き合ってあげるだけよ",
        "今日はどんなトレーニング...うち、ちょっと楽しみかも",
        "準備はできてるの？うちはいつでもいいんだけど"
    ]

    /// 応援・励ましセリフ
    private static let encouragementDialogues = [
        "もっと頑張れるでしょ、あんたなら",
        "うちが見てるから...手を抜かないでよね",
        "すごい...じゃなくて、当然よね！",
        "あんた、意外とやるじゃない...認めてあげるわ",
        "うち、あんたのこと応援してる...から！"
    ]

    /// 照れ隠し・ツンデレ反応セリフ
    private static let shyReactionDialogues = [
        "べ、別に心配なんかしてないんだからね",
        "あんたのこと考えて...じゃなくて！",
        "う、うち...何も言ってないわよ！",
        "そんな顔されたら...うち、困っちゃうじゃない",
        "あんたって本当に...まぁ、嫌いじゃないけど"
    ]

    /// 指定されたカテゴリーのセリフをランダムに取得
    /// - Parameter category: セリフのカテゴリー
    /// - Returns: ランダムに選ばれたセリフ
    static func getDialogue(for category: DialogueCategory) -> String {
        let dialogues: [String]

        switch category {
        case .greeting:
            dialogues = greetingDialogues
        case .trainingStart:
            dialogues = trainingStartDialogues
        case .encouragement:
            dialogues = encouragementDialogues
        case .shyReaction:
            dialogues = shyReactionDialogues
        }

        return dialogues.randomElement() ?? dialogues[0]
    }
}
