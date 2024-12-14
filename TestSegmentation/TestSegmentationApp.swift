//
//  TestSegmentationApp.swift
//  TestSegmentation
//
//  Created by user5773 on 9/16/24.
//

import SwiftUI

@main
struct TestSegmentationApp: App {
    var body: some Scene {
        WindowGroup {
            // CameraViewModelのインスタンスを生成して渡す
            ContentView(cameraViewModel: CameraViewModel())
        }
    }
}

