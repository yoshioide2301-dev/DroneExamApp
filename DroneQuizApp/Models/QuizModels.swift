//
//  QuizModels.swift
//  DroneQuizApp
//
//  無人航空機操縦者技能証明（一等・二等）学科試験対策アプリの中核データモデル。
//  国土交通省「無人航空機の飛行の安全に関する教則」の版数に依存しない
//  拡張可能な構造として設計している。
//

import Foundation

/// 技能証明の区分（一等 / 二等）。
/// 一部の設問はどちらの区分にも出題されるため、設問側は Set で複数区分を保持できる。
enum LicenseClass: String, Codable, CaseIterable, Identifiable, Hashable {
    case first = "一等"
    case second = "二等"

    var id: String { rawValue }

    /// 一覧・バッジ表示用の短縮ラベル
    var shortLabel: String {
        switch self {
        case .first: return "一等"
        case .second: return "二等"
        }
    }

    var accentColorName: String {
        switch self {
        case .first: return "LicenseFirstAccent"
        case .second: return "LicenseSecondAccent"
        }
    }
}

/// 教則の章（第5版時点の章立てを既定値としつつ、将来の改訂で
/// 章数・章名が変わっても QuizChapter を差し替えるだけで追従できる。
struct QuizChapter: Identifiable, Codable, Hashable {
    /// 教則上の章番号（表示・並び替えに使用）
    let id: Int
    let title: String
    let subtitle: String
    /// SF Symbols のシステムアイコン名
    let systemIcon: String
    /// 教則内の該当ページ範囲（例: "P.5-18"）。版が変わっても差し替え可能。
    let pageRange: String
}

/// 教則の版数情報。将来「第6版」等がリリースされた際に
/// 設問データ側の referenceEdition と紐付けて出典を明示する。
struct ReferenceEdition: Codable, Hashable {
    let name: String
    let publishedYear: Int
}

/// 1問分のクイズ設問。
struct QuizQuestion: Identifiable, Codable, Hashable {
    let id: UUID
    /// この設問が出題対象となる技能証明区分（複数可）
    let applicableLicenses: Set<LicenseClass>
    /// 紐づく教則の章番号（QuizChapter.id と対応）
    let chapterID: Int
    let category: String
    let questionText: String
    let choices: [String]
    /// choices 配列内の正解インデックス
    let correctChoiceIndex: Int
    /// 正誤判定後に表示する解説文
    let explanation: String
    /// 出典の教則版（例: "無人航空機の飛行の安全に関する教則（第5版）"）
    let referenceEdition: String
    /// 出典ページ（例: "P.42"）
    let referencePage: String

    init(
        id: UUID = UUID(),
        applicableLicenses: Set<LicenseClass>,
        chapterID: Int,
        category: String,
        questionText: String,
        choices: [String],
        correctChoiceIndex: Int,
        explanation: String,
        referenceEdition: String,
        referencePage: String
    ) {
        self.id = id
        self.applicableLicenses = applicableLicenses
        self.chapterID = chapterID
        self.category = category
        self.questionText = questionText
        self.choices = choices
        self.correctChoiceIndex = correctChoiceIndex
        self.explanation = explanation
        self.referenceEdition = referenceEdition
        self.referencePage = referencePage
    }

    func isCorrect(choiceIndex: Int) -> Bool {
        choiceIndex == correctChoiceIndex
    }
}
