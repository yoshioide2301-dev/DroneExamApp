//
//  QuizSessionViewModel.swift
//  DroneQuizApp
//
//  1つの章に対するクイズセッション（出題順・現在の設問・正誤判定・
//  スコア集計）を管理する状態クラス。QuizView から生成・保持される。
//

import Foundation
import Combine

@MainActor
final class QuizSessionViewModel: ObservableObject {

    // MARK: - Published State

    /// 出題対象の設問（シャッフル済み）
    @Published private(set) var questions: [QuizQuestion]
    /// 現在表示中の設問インデックス
    @Published private(set) var currentIndex: Int = 0
    /// ユーザーが選択中の選択肢（未回答なら nil）
    @Published private(set) var selectedChoiceIndex: Int? = nil
    /// 現在の設問の正誤が確定済みかどうか
    @Published private(set) var isAnswerRevealed: Bool = false
    /// 正解数
    @Published private(set) var correctCount: Int = 0
    /// 章内の全設問に回答し終えたか
    @Published private(set) var isSessionCompleted: Bool = false

    // MARK: - Context

    let chapter: QuizChapter
    let license: LicenseClass

    private let repository: QuestionRepositoryProtocol

    // MARK: - Init

    init(
        chapter: QuizChapter,
        license: LicenseClass,
        repository: QuestionRepositoryProtocol = QuestionRepository.shared
    ) {
        self.chapter = chapter
        self.license = license
        self.repository = repository
        self.questions = repository.questions(chapterID: chapter.id, license: license).shuffled()
    }

    // MARK: - Derived Values

    var currentQuestion: QuizQuestion? {
        guard questions.indices.contains(currentIndex) else { return nil }
        return questions[currentIndex]
    }

    var totalCount: Int { questions.count }

    var progress: Double {
        guard totalCount > 0 else { return 0 }
        return Double(currentIndex) / Double(totalCount)
    }

    var questionNumberLabel: String {
        "\(min(currentIndex + 1, totalCount)) / \(totalCount)"
    }

    var isLastQuestion: Bool {
        currentIndex == totalCount - 1
    }

    var scoreText: String {
        "\(correctCount) / \(totalCount) 問正解"
    }

    // MARK: - Actions

    /// 選択肢をタップした際に呼び出す。一度確定した回答は変更不可。
    func selectChoice(_ index: Int) {
        guard !isAnswerRevealed, currentQuestion != nil else { return }
        selectedChoiceIndex = index
        isAnswerRevealed = true

        if let question = currentQuestion, question.isCorrect(choiceIndex: index) {
            correctCount += 1
        }
    }

    func isChoiceCorrect(_ index: Int) -> Bool {
        currentQuestion?.correctChoiceIndex == index
    }

    /// 次の設問へ進む。最終問の場合はセッション完了扱いにする。
    func advance() {
        guard isAnswerRevealed else { return }

        if isLastQuestion {
            isSessionCompleted = true
            return
        }

        currentIndex += 1
        selectedChoiceIndex = nil
        isAnswerRevealed = false
    }

    /// 同じ章をもう一度最初から解き直す。
    func restart() {
        questions = repository.questions(chapterID: chapter.id, license: license).shuffled()
        currentIndex = 0
        selectedChoiceIndex = nil
        isAnswerRevealed = false
        correctCount = 0
        isSessionCompleted = false
    }
}
