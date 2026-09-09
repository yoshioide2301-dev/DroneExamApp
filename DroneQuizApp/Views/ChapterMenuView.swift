//
//  ChapterMenuView.swift
//  DroneQuizApp
//
//  アプリのホーム画面。資格区分（一等/二等）を切り替えつつ、
//  国土交通省「無人航空機の飛行の安全に関する教則」の章立てに沿って
//  クイズを選択できる。
//

import SwiftUI

struct ChapterMenuView: View {
    @State private var selectedLicense: LicenseClass = .second
    private let repository: QuestionRepositoryProtocol = QuestionRepository.shared

    private var chapters: [QuizChapter] {
        repository.chapters()
    }

    var body: some View {
        NavigationStack {
            ZStack {
                QuizTheme.backgroundGradient
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        header

                        LicenseSegmentedPicker(selection: $selectedLicense)
                            .padding(.horizontal)

                        complianceBanner

                        VStack(alignment: .leading, spacing: 12) {
                            Text("章から選ぶ")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .padding(.horizontal)

                            VStack(spacing: 12) {
                                ForEach(chapters) { chapter in
                                    NavigationLink {
                                        QuizView(chapter: chapter, license: selectedLicense)
                                    } label: {
                                        ChapterCard(
                                            chapter: chapter,
                                            questionCount: repository.questionCount(
                                                chapterID: chapter.id,
                                                license: selectedLicense
                                            )
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("ドローン国家資格 学科対策")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
        }
        .preferredColorScheme(.dark)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("無人航空機操縦士 学科試験")
                .font(.title2.weight(.bold))
                .foregroundStyle(.white)
            Text("\(selectedLicense.shortLabel)資格の出題範囲を、教則の章ごとに演習できます。")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.6))
        }
        .padding(.horizontal)
    }

    private var complianceBanner: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.seal.fill")
                .foregroundStyle(QuizTheme.accent)
            VStack(alignment: .leading, spacing: 2) {
                Text("国土交通省 教則第5版 準拠")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white)
                Text("全設問に該当教則ページを明示")
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.55))
            }
            Spacer()
        }
        .padding(14)
        .background(QuizTheme.accent.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(QuizTheme.accent.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}

#Preview {
    ChapterMenuView()
}
