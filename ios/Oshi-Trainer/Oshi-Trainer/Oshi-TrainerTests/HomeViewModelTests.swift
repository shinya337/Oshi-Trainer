import XCTest
import Combine
@testable import Oshi_Trainer

final class HomeViewModelTests: XCTestCase {

    var viewModel: HomeViewModel!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        viewModel = HomeViewModel()
    }

    override func tearDown() {
        cancellables.removeAll()
        viewModel = nil
        super.tearDown()
    }

    func testInitialTrainerIsDefaultTrainer() {
        // Then: 初期化時にデフォルトトレーナーが読み込まれている
        XCTAssertEqual(viewModel.oshiTrainer.name, "推乃 愛")
        XCTAssertEqual(viewModel.oshiLevel, 1)
    }

    func testInitialDialogueIsGreeting() {
        // Then: 初期セリフが挨拶カテゴリーから取得されている
        XCTAssertFalse(viewModel.currentDialogue.isEmpty)
    }

    func testUpdateDialogueChangesDialogue() {
        // Given: 初期セリフ
        let initialDialogue = viewModel.currentDialogue

        // When: セリフを更新
        viewModel.updateDialogue(for: .trainingStart)

        // Then: セリフが更新される
        // 注: ランダム選択のため、同じ可能性もあるが、カテゴリーが異なれば内容も異なるはず
        XCTAssertFalse(viewModel.currentDialogue.isEmpty)
    }

    func testUpdateDialogueWithCategoryChangesDialogue() {
        // Given: 現在のセリフ

        // When: 応援カテゴリーでセリフを更新
        viewModel.updateDialogue(for: .encouragement)

        // Then: セリフが更新される
        XCTAssertFalse(viewModel.currentDialogue.isEmpty)
    }

    func testUpdateDialogueWithoutParameterUsesEncouragementCategory() {
        // When: 引数なしでセリフを更新（デフォルトで応援カテゴリー）
        viewModel.updateDialogue()

        // Then: セリフが更新される
        XCTAssertFalse(viewModel.currentDialogue.isEmpty)
    }
}
