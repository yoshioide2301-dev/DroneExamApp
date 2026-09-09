//
//  QuizUIComponents.swift
//  DroneQuizApp
//
//  ChapterMenuView / QuizView から共通利用する再利用可能な UI パーツ。
//

import SwiftUI

// MARK: - Design Tokens

enum QuizTheme {
    static let backgroundTop = Color(red: 0.06, green: 0.09, blue: 0.16)
    static let backgroundBottom = Color(red: 0.03, green: 0.05, blue: 0.10)
    static let cardBackground = Color(.secondarySystemGroupedBackground)
    static let accent = Color(red: 0.17, green: 0.45, blue: 0.98)
    static let success = Color(red: 0.20, green: 0.70, blue: 0.45)
    static let failure = Color(red: 0.90, green: 0.30, blue: 0.30)

    static var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [backgroundTop, backgroundBottom],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

// MARK: - License Segmented Picker

/// 一等 / 二等 を切り替えるビジネスライクなセグメントピッカー
struct LicenseSegmentedPicker: View {
    @Binding var selection: LicenseClass

    var body: some View {
        HStack(spacing: 0) {
            ForEach(LicenseClass.allCases) { license in
                let isSelected = selection == license
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selection = license
                    }
                } label: {
                    Text("\(license.shortLabel)資格")
                        .font(.subheadline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .foregroundStyle(isSelected ? .white : .white.opacity(0.6))
                        .background(
                            isSelected ? QuizTheme.accent : Color.white.opacity(0.08)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

// MARK: - Chapter Card

/// 章選択メニューの1行を表すカード。教則の該当ページ・出題数を表示する。
struct ChapterCard: View {
    let chapter: QuizChapter
    let questionCount: Int

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(QuizTheme.accent.opacity(0.15))
                    .frame(width: 52, height: 52)
                Image(systemName: chapter.systemIcon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(QuizTheme.accent)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text("第\(chapter.id)章")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(QuizTheme.accent)
                    Text(chapter.pageRange)
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.4))
                }
                Text(chapter.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                Text(chapter.subtitle)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.55))
                    .lineLimit(1)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 6) {
                Text("\(questionCount)問")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.7))
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white.opacity(0.3))
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }
}

// MARK: - Progress Bar

struct QuizProgressBar: View {
    let progress: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.12))
                Capsule()
                    .fill(QuizTheme.accent)
                    .frame(width: geometry.size.width * max(0, min(progress, 1)))
                    .animation(.easeInOut(duration: 0.25), value: progress)
            }
        }
        .frame(height: 6)
    }
}

// MARK: - Choice Row

/// クイズ画面における1つの選択肢ボタン。
/// 未回答 / 正解 / 不正解(選択中) / 不正解(非選択) の4状態を色分けする。
struct ChoiceRow: View {
    let index: Int
    let text: String
    let isRevealed: Bool
    let isSelected: Bool
    let isCorrectChoice: Bool
    let action: () -> Void

    private let labels = ["A", "B", "C", "D", "E"]

    private var borderColor: Color {
        guard isRevealed else { return Color.white.opacity(0.1) }
        if isCorrectChoice { return QuizTheme.success }
        if isSelected { return QuizTheme.failure }
        return Color.white.opacity(0.08)
    }

    private var backgroundColor: Color {
        guard isRevealed else { return Color.white.opacity(0.05) }
        if isCorrectChoice { return QuizTheme.success.opacity(0.16) }
        if isSelected { return QuizTheme.failure.opacity(0.16) }
        return Color.white.opacity(0.03)
    }

    private var badgeColor: Color {
        guard isRevealed else { return Color.white.opacity(0.1) }
        if isCorrectChoice { return QuizTheme.success }
        if isSelected { return QuizTheme.failure }
        return Color.white.opacity(0.1)
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(badgeColor)
                        .frame(width: 30, height: 30)
                    if isRevealed && isCorrectChoice {
                        Image(systemName: "checkmark")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.white)
                    } else if isRevealed && isSelected {
                        Image(systemName: "xmark")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.white)
                    } else {
                        Text(labels[safe: index] ?? "?")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.white.opacity(0.85))
                    }
                }

                Text(text)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.92))
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 0)
            }
            .padding(14)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(borderColor, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
        .disabled(isRevealed)
    }
}

// MARK: - Explanation Card

/// 正誤判定後に表示する解説カード。教則の版・該当ページを明示する。
struct ExplanationCard: View {
    let isCorrect: Bool
    let explanation: String
    let referenceEdition: String
    let referencePage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: isCorrect ? "checkmark.seal.fill" : "exclamationmark.triangle.fill")
                    .foregroundStyle(isCorrect ? QuizTheme.success : QuizTheme.failure)
                Text(isCorrect ? "正解です" : "不正解です")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.white)
            }

            Text(explanation)
                .font(.footnote)
                .foregroundStyle(.white.opacity(0.8))
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 6) {
                Image(systemName: "book.closed.fill")
                    .font(.caption2)
                Text("\(referenceEdition) \(referencePage)")
                    .font(.caption2.weight(.medium))
            }
            .foregroundStyle(.white.opacity(0.45))
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke((isCorrect ? QuizTheme.success : QuizTheme.failure).opacity(0.35), lineWidth: 1)
        )
    }
}

// MARK: - Safe Array Access

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
