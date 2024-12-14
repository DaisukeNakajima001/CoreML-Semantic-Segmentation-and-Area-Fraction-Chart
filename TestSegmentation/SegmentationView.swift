//
//  SegmentationView.swift
//  TestSegmentation
//
//  Created by user5773 on 9/16/24.
//

import SwiftUI

struct SegmentationView: View {
    @ObservedObject var cameraViewModel: CameraViewModel
    var body: some View {
        VStack {
            // SafeAreaの上端に画像を移動
            if let overlayImage = cameraViewModel.overlayImage {
                Image(uiImage: overlayImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 448, height: 448)
                    .border(Color.gray, width: 1)
                    .padding(.top, -30)
            } else {
                Text("Processing...")
                    .font(.headline)
                    .foregroundColor(.gray)
            }
            
            Spacer() // 画像の下にスペースを追加して、画面上端に移動
        }
        .onAppear {
            cameraViewModel.startCamera() // カメラの起動
        }
        .onDisappear {
            cameraViewModel.stopCamera() // カメラの停止
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        //.background(Color.black.opacity(0.7))
        .edgesIgnoringSafeArea(.top)  // 上部のSafeAreaを無視
    }
}



