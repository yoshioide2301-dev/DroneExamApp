//
//  DroneQuizApp.swift
//  DroneQuizApp
//
//  アプリのエントリーポイント。起動後は章選択メニュー（ChapterMenuView）を表示する。
//

import SwiftUI

@main
struct DroneQuizApp: App {
    var body: some Scene {
        WindowGroup {
            ChapterMenuView()
        }
    }
}
