//
//  PieChartView.swift
//  TestSegmentation
//
//  Created by user5773 on 9/16/24.
//
import SwiftUI
import Charts

struct PieChartView: View {
    let classAreaRatios: [Int: Double] // 各クラスの面積比
    let detectedClasses: [(Int, String, UIColor)] // クラス番号、クラス名、色

    var body: some View {
        VStack {
            Spacer() // 画像が押し上げられないようにするための余白

            // チャート描画部分
            ZStack {
                Chart {
                    ForEach(detectedClasses, id: \.0) { classInfo in
                        let classLabel = classInfo.0
                        let classColor = classInfo.2
                        
                        if let areaRatio = classAreaRatios[classLabel] {
                            SectorMark(
                                angle: .value("Ratio", areaRatio),
                                innerRadius: .ratio(0.5),
                                outerRadius: .ratio(1.0)
                            )
                            .foregroundStyle(Color(classColor)) // クラスに対応する色を設定
                        }
                    }
                }
                .frame(height: 300) // グラフの高さを指定
                .padding()
                
                HStack {
                    // カスタム凡例をスクロールで表示し、余分なスペースを確保しない
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(detectedClasses, id: \.0) { classInfo in
                                HStack {
                                    // クラスに対応する色を四角で表示
                                    Rectangle()
                                        .fill(Color(classInfo.2))
                                        .frame(width: 20, height: 20)
                                    
                                    // クラス名を表示
                                    Text(classInfo.1)
                                        .foregroundColor(.white) // クラス名を白で表示
                                }
                            }
                        }
                    }
                    .frame(height: 300) // 凡例の高さを制限
                    .padding()
                    .background(Color.clear) // 背景を透明にする
                    
                    Spacer()
                }
                // 背景の透明化
                .background(Color.clear) // 背景を透明にする
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black) // 背景色を黒に設定
        .edgesIgnoringSafeArea(.bottom) // 下端の安全領域を無視
    }
}

// プレビュー用のデータを追加
struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleClassAreaRatios: [Int: Double] = [
            1: 0.4,  // Class 1: 40%
            2: 0.3,  // Class 2: 30%
            3: 0.2,  // Class 3: 20%
            4: 0.1   // Class 4: 10%
        ]

        let sampleDetectedClasses: [(Int, String, UIColor)] = [
            (1, "Person", .red),
            (2, "Car", .blue),
            (3, "Bicycle", .green),
            (4, "Dog", .yellow)
        ]

        PieChartView(classAreaRatios: sampleClassAreaRatios, detectedClasses: sampleDetectedClasses)
    }
}
