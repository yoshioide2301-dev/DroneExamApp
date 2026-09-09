//
//  QuestionRepository.swift
//  DroneQuizApp
//
//  章データと設問データの供給元。プロトタイプ段階ではアプリ内蔵の配列で
//  保持しているが、将来的には JSONDecoder を使ってバンドル同梱の
//  questions.json（教則の版ごとに差し替え可能）から読み込む形へ
//  自然に移行できるようインターフェースを分離してある。
//

import Foundation

protocol QuestionRepositoryProtocol {
    func chapters() -> [QuizChapter]
    func questions(chapterID: Int, license: LicenseClass) -> [QuizQuestion]
    func questionCount(chapterID: Int, license: LicenseClass) -> Int
}

final class QuestionRepository: QuestionRepositoryProtocol {
    static let shared = QuestionRepository()

    /// 教則第5版（2024年12月一部改正版を想定）の章立て。
    /// 版が更新された場合はこの配列のみ差し替えれば全画面に反映される。
    private let allChapters: [QuizChapter] = [
        QuizChapter(
            id: 1,
            title: "無人航空機を飛行させるにあたって",
            subtitle: "操縦者の心得と基本的な責務",
            systemIcon: "person.fill.checkmark",
            pageRange: "P.5-18"
        ),
        QuizChapter(
            id: 2,
            title: "無人航空機の飛行に関する規則",
            subtitle: "航空法・関連法令と飛行許可制度",
            systemIcon: "doc.text.magnifyingglass",
            pageRange: "P.19-88"
        ),
        QuizChapter(
            id: 3,
            title: "無人航空機のシステム",
            subtitle: "機体構造・センサー・通信・バッテリー",
            systemIcon: "cpu",
            pageRange: "P.89-142"
        ),
        QuizChapter(
            id: 4,
            title: "無人航空機の操縦者及び運航体制の整備",
            subtitle: "操縦技量・安全運航管理体制",
            systemIcon: "person.2.badge.gearshape",
            pageRange: "P.143-168"
        ),
        QuizChapter(
            id: 5,
            title: "運航上のリスク管理",
            subtitle: "気象・リスクアセスメント・事故対応",
            systemIcon: "exclamationmark.triangle",
            pageRange: "P.169-210"
        )
    ]

    /// プロトタイプ用サンプル設問。
    /// 本番投入時は同一シグネチャの JSON を Bundle からロードする形に差し替える想定。
    private let allQuestions: [QuizQuestion] = [
        QuizQuestion(
            applicableLicenses: [.first, .second],
            chapterID: 1,
            category: "操縦者の心得",
            questionText: "無人航空機の操縦者に求められる基本姿勢として、最も適切なものはどれか。",
            choices: [
                "飛行前点検は機体が新しい場合には省略してよい",
                "常に自らの技量と機体の性能を過信せず、安全を最優先して飛行させる",
                "第三者の安全確保は操縦者ではなく運航管理者のみの責務である",
                "天候が悪い場合でも予定通り飛行を強行するべきである"
            ],
            correctChoiceIndex: 1,
            explanation: "操縦者は自己の技量及び無人航空機の性能を過信せず、常に安全を最優先して飛行させることが求められる。飛行前点検の省略や天候不良時の強行は安全運航の原則に反する。",
            referenceEdition: "無人航空機の飛行の安全に関する教則（第5版）",
            referencePage: "P.7"
        ),
        QuizQuestion(
            applicableLicenses: [.first, .second],
            chapterID: 2,
            category: "航空法規",
            questionText: "航空法における「無人航空機」の定義に該当する重量条件として正しいものはどれか。",
            choices: [
                "100g未満の機体を除く、構造上人が乗ることができない飛行機・回転翼航空機等",
                "重量にかかわらずすべての遠隔操作可能な飛行体",
                "250g未満の機体のみを対象とする",
                "商用利用される機体のみを対象とする"
            ],
            correctChoiceIndex: 0,
            explanation: "航空法上、無人航空機は「構造上人が乗ることができない飛行機、回転翼航空機、滑空機、飛行船であって、遠隔操作又は自動操縦により飛行させることができるもの（機体重量が100g未満のものを除く）」と定義される。",
            referenceEdition: "無人航空機の飛行の安全に関する教則（第5版）",
            referencePage: "P.21"
        ),
        QuizQuestion(
            applicableLicenses: [.first],
            chapterID: 2,
            category: "航空法規",
            questionText: "レベル4飛行（有人地帯における目視外飛行）を行うために一等無人航空機操縦士に求められるものとして正しいものはどれか。",
            choices: [
                "二等資格のみで実施可能である",
                "第一種機体認証を受けた機体と一等資格、および運航ルールの遵守が必要",
                "資格は不要で許可承認のみで足りる",
                "目視内飛行であれば同様の要件は不要"
            ],
            correctChoiceIndex: 1,
            explanation: "有人地帯上空での目視外飛行（レベル4）を行うには、第一種機体認証を受けた機体と一等無人航空機操縦士の資格に加え、運航ルールの遵守及び必要な許可・承認が必要となる。",
            referenceEdition: "無人航空機の飛行の安全に関する教則（第5版）",
            referencePage: "P.56"
        ),
        QuizQuestion(
            applicableLicenses: [.first, .second],
            chapterID: 3,
            category: "機体システム",
            questionText: "リチウムポリマー（LiPo）バッテリーの取り扱いとして適切なものはどれか。",
            choices: [
                "満充電のまま長期間保管してよい",
                "高温環境下での保管・充電を避け、膨張等の異常があれば使用を中止する",
                "外装が膨張していても飛行に支障がなければ使用を継続してよい",
                "水濡れした場合でも乾燥させれば問題なく使用できる"
            ],
            correctChoiceIndex: 1,
            explanation: "LiPoバッテリーは高温下での保管・充電により発火のリスクが高まる。外装の膨張や変形が見られる場合は直ちに使用を中止し、適切な方法で処分する必要がある。",
            referenceEdition: "無人航空機の飛行の安全に関する教則（第5版）",
            referencePage: "P.112"
        ),
        QuizQuestion(
            applicableLicenses: [.first, .second],
            chapterID: 3,
            category: "機体システム",
            questionText: "GNSS（衛星測位システム）を用いた位置保持機能に関する記述として正しいものはどれか。",
            choices: [
                "GNSS信号の受信状況にかかわらず常に高精度な位置保持ができる",
                "周囲の建造物や電波環境によって測位精度が低下することがある",
                "GNSSを利用すればセンサー異常時も自動で安全な着陸ができる",
                "屋内飛行でも屋外と同等の精度が得られる"
            ],
            correctChoiceIndex: 1,
            explanation: "GNSSによる位置保持は、周囲の建造物・電波状況・上空の開け具合等により測位精度が低下する場合があり、操縦者はその特性を理解した上で運用する必要がある。",
            referenceEdition: "無人航空機の飛行の安全に関する教則（第5版）",
            referencePage: "P.98"
        ),
        QuizQuestion(
            applicableLicenses: [.first, .second],
            chapterID: 4,
            category: "運航体制",
            questionText: "複数人で無人航空機を運航する際の役割分担に関する記述として最も適切なものはどれか。",
            choices: [
                "操縦者以外に見張員を配置する必要は原則ない",
                "操縦者と補助者（見張員等）の役割・連絡方法を事前に明確にしておく",
                "見張員は操縦技量が操縦者と同等でなければならない",
                "運航計画は操縦者が口頭で当日決定すればよい"
            ],
            correctChoiceIndex: 1,
            explanation: "安全な運航体制を整備するためには、操縦者・補助者（見張員等）の役割分担や連絡方法をあらかじめ明確にし、運航計画に基づいて実施することが求められる。",
            referenceEdition: "無人航空機の飛行の安全に関する教則（第5版）",
            referencePage: "P.150"
        ),
        QuizQuestion(
            applicableLicenses: [.first, .second],
            chapterID: 5,
            category: "気象・リスク管理",
            questionText: "無人航空機の飛行における気象リスクの説明として適切なものはどれか。",
            choices: [
                "風速のみを確認すれば気象リスクの評価として十分である",
                "降雨・積雪・低温等は機体の性能や安全性に影響するため飛行判断に含める必要がある",
                "気象条件は機体の飛行可否に影響しない",
                "夜間飛行であれば気象条件の確認は不要である"
            ],
            correctChoiceIndex: 1,
            explanation: "風速だけでなく、降雨・積雪・気温・視程等の気象条件は機体の性能や安全性に大きく影響するため、飛行の可否判断において総合的に評価する必要がある。",
            referenceEdition: "無人航空機の飛行の安全に関する教則（第5版）",
            referencePage: "P.182"
        ),
        QuizQuestion(
            applicableLicenses: [.first, .second],
            chapterID: 5,
            category: "気象・リスク管理",
            questionText: "飛行中に予期しない事故（墜落等）が発生した場合の対応として最も適切なものはどれか。",
            choices: [
                "軽微な事故であれば報告する必要はない",
                "負傷者の救護等を最優先し、必要に応じて国土交通大臣へ報告する",
                "事故の記録は不要であり口頭説明のみでよい",
                "事故原因の究明は義務ではない"
            ],
            correctChoiceIndex: 1,
            explanation: "事故発生時は負傷者の救護等の人命に関わる対応を最優先し、無人航空機による人の死傷等の事故が発生した場合は国土交通大臣への報告が義務付けられている。",
            referenceEdition: "無人航空機の飛行の安全に関する教則（第5版）",
            referencePage: "P.201"
        )
    ]

    private init() {}

    func chapters() -> [QuizChapter] {
        allChapters.sorted { $0.id < $1.id }
    }

    func questions(chapterID: Int, license: LicenseClass) -> [QuizQuestion] {
        allQuestions
            .filter { $0.chapterID == chapterID && $0.applicableLicenses.contains(license) }
    }

    /// 指定区分・章に紐づく設問数（章一覧の出題数バッジ表示に使用）
    func questionCount(chapterID: Int, license: LicenseClass) -> Int {
        questions(chapterID: chapterID, license: license).count
    }
}
