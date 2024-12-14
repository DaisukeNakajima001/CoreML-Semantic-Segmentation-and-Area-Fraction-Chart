//
//  ContentView.swift
//  TestSegmentation
//
//  Created by user5773 on 9/16/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var cameraViewModel: CameraViewModel

    var body: some View {
        ZStack {

            VStack {
                // SegmentationView をカメラモデルに対応させる
                SegmentationView(cameraViewModel: cameraViewModel)
                    .edgesIgnoringSafeArea(.all)
                Spacer()
                // cameraViewModel インスタンスから classAreaRatios を取得してグラフを描画
                PieChartView(
                    classAreaRatios: cameraViewModel.classAreaRatios,
                    detectedClasses: cameraViewModel.getDetectedClasses()
                )
                //.frame(height: 500) // グラフの高さを指定
                    .padding(.bottom, -20)
            }
            
            // 一時停止ボタンを画面右下に配置
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        cameraViewModel.isPaused.toggle() // 一時停止と再開を切り替え
                    }) {
                        Image(systemName: cameraViewModel.isPaused ? "play.circle" : "pause.circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .clipShape(Circle())
                    }
                    .padding([.trailing, .bottom], 30)
                }
            }
            
        }
        .padding()
        
        
    }
}


