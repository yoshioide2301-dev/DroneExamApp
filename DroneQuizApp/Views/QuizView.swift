//
//  QuizView.swift
//  DroneQuizApp
//
//  1章分のクイズを出題するメイン演習画面。
//  タップで選択 → 即時正誤判定 → 解説表示 → 次の問題、というテンポの良い
//  導線を重視している。全問終了後は結果サマリーを表示する。
//

import SwiftUI

struct QuizView: View {
    @StateObject private var viewModel: QuizSessionViewModel
    @Environment(\.dismiss) private var dismiss

    init(chapter: QuizChapter, license: LicenseClass) {
        _viewModel = StateObject(
            wrappedValue: QuizSessionViewModel(chapter: chapter, license: license)
        )
    }

    var body: some View {
        ZStack {
            QuizTheme.backgroundGradient
                .ignoresSafeArea()

            if viewModel.isSessionCompleted {
                resultView
            } else if let question = viewModel.currentQuestion {
                quizContent(for: question)
            } else {
                emptyStateView
            }
        }
        .navigationTitle("第\(viewModel.chapter.id)章")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .preferredColorScheme(.dark)
    }

    // MARK: - Quiz Content

    private func quizContent(for question: QuizQuestion) -> some View {
        VStack(spacing: 0) {
            VStack(spacing: 10) {
                HStack {
                    Text(viewModel.questionNumberLabel)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.white.opacity(0.6))
                    Spacer()
                    Label(question.category, systemImage: "tag.fill")
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(QuizTheme.accent)
                }
                QuizProgressBar(progress: viewModel.progress)
            }
            .padding(.horizontal)
            .padding(.top, 12)

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(question.questionText)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.white)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 12)

                    VStack(spacing: 10) {
                        ForEach(question.choices.indices, id: \.self) { index in
                            ChoiceRow(
                                index: index,
                                text: question.choices[index],
                                isRevealed: viewModel.isAnswerRevealed,
                                isSelected: viewModel.selectedChoiceIndex == index,
                                isCorrectChoice: viewModel.isChoiceCorrect(index),
                                action: { viewModel.selectChoice(index) }
                            )
                        }
                    }

                    if viewModel.isAnswerRevealed,
                       let selected = viewModel.selectedChoiceIndex {
                        ExplanationCard(
                            isCorrect: question.isCorrect(choiceIndex: selected),
                            explanation: question.explanation,
                            referenceEdition: question.referenceEdition,
                            referencePage: question.referencePage
                        )
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 120)
            }
            .animation(.easeInOut(duration: 0.2), value: viewModel.isAnswerRevealed)
        }
        .safeAreaInset(edge: .bottom) {
            if viewModel.isAnswerRevealed {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.advance()
                    }
                } label: {
                    Text(viewModel.isLastQuestion ? "結果を見る" : "次の問題へ")
                        .font(.subheadline.weight(.bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .foregroundStyle(.white)
                        .background(QuizTheme.accent)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
                .background(
                    LinearGradient(
                        colors: [QuizTheme.backgroundBottom.opacity(0), QuizTheme.backgroundBottom],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 90)
                    .allowsHitTesting(false)
                )
            }
        }
    }

    // MARK: - Result View

    private var resultView: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: resultIcon)
                .font(.system(size: 56, weight: .semibold))
                .foregroundStyle(resultColor)

            VStack(spacing: 6) {
                Text("第\(viewModel.chapter.id)章 完了")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.white)
                Text(viewModel.scoreText)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.65))
            }

            VStack(spacing: 12) {
                Button {
                    viewModel.restart()
                } label: {
                    Text("もう一度解く")
                        .font(.subheadline.weight(.bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .foregroundStyle(.white)
                        .background(QuizTheme.accent)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }

                Button {
                    dismiss()
                } label: {
                    Text("章一覧に戻る")
                        .font(.subheadline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .foregroundStyle(.white.opacity(0.8))
                        .background(Color.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
            }
            .padding(.horizontal, 32)

            Spacer()
            Spacer()
        }
    }

    private var resultAccuracy: Double {
        guard viewModel.totalCount > 0 else { return 0 }
        return Double(viewModel.correctCount) / Double(viewModel.totalCount)
    }

    private var resultIcon: String {
        resultAccuracy >= 0.8 ? "star.circle.fill" : "arrow.clockwise.circle.fill"
    }

    private var resultColor: Color {
        resultAccuracy >= 0.8 ? QuizTheme.success : QuizTheme.accent
    }

    // MARK: - Empty State

    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "tray")
                .font(.system(size: 40))
                .foregroundStyle(.white.opacity(0.3))
            Text("この章にはまだ設問がありません")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.6))
        }
    }
}

#Preview {
    NavigationStack {
        QuizView(
            chapter: QuizChapter(
                id: 2,
                title: "無人航空機の飛行に関する規則",
                subtitle: "航空法・関連法令と飛行許可制度",
                systemIcon: "doc.text.magnifyingglass",
                pageRange: "P.19-88"
            ),
            license: .second
        )
    }
}
