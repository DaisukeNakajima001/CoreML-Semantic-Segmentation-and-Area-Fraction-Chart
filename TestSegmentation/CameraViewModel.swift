//
//  CameraViewModel.swift
//  TestSegmentation
//
//  Created by user5773 on 9/16/24.
//
import AVFoundation
import UIKit
import CoreML
import Vision

class CameraViewModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Published var overlayImage: UIImage? = nil // セグメンテーション結果のオーバーレイ画像
    @Published var classPixelCounts: [Int: Int] = [:] // 各クラスのピクセル数を保持
    @Published var classAreaRatios: [Int: Double] = [:] // 各クラスの面積比率
    @Published var isPaused: Bool = false // 一時停止のフラグを追加
    
    let classColors: [Int: UIColor] // クラスごとの色を保持
    
    private let session = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    private let model = DETRResnet50Model()

    private var lastUpdateTime: Date = Date() // 最後にピクセルカウントを行った時間

    override init() {
        self.classColors = model.classColors // DETRResnet50Modelから色を取得
        super.init()
        setupCamera()
    }

    // カメラの設定
    private func setupCamera() {
        session.sessionPreset = .photo

        guard let camera = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: camera) else { return }
        session.addInput(input)

        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        session.addOutput(videoOutput)
    }

    // カメラの起動
    func startCamera() {
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
        }
    }

    // カメラの停止
    func stopCamera() {
        session.stopRunning()
    }
    
    // クラスピクセルの比率を計算する関数
    private func calculateClassAreaRatios(from classPixelCounts: [Int: Int]) -> [Int: Double] {
        let totalPixels = classPixelCounts.reduce(0) { $0 + $1.value } // 総ピクセル数を計算
        guard totalPixels > 0 else { return [:] } // 総ピクセルが0なら空の辞書を返す

        var areaRatios: [Int: Double] = [:]
        for (classLabel, pixelCount) in classPixelCounts {
            areaRatios[classLabel] = Double(pixelCount) / Double(totalPixels) // クラスごとの比率を計算
        }
        return areaRatios
    }
    
    // 検出されたクラスのみ取得する関数
        func getDetectedClasses() -> [(Int, String, UIColor)] {
            let detectedClasses = classPixelCounts.keys.filter { classPixelCounts[$0] != 0 }
            return detectedClasses.compactMap { classLabel in
                guard let color = classColors[classLabel], let className = model.labels[safe: classLabel] else { return nil }
                return (classLabel, className, color)
            }
        }

    // カメラのフレームが取得された際に呼ばれるデリゲートメソッド
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard !isPaused, let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let currentTime = Date()
        if currentTime.timeIntervalSince(lastUpdateTime) >= 0.1 {
            lastUpdateTime = currentTime
            
            DispatchQueue.global(qos: .userInitiated).async {
                let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
                let uiImage = UIImage(ciImage: ciImage)
                
                self.model.predict(image: uiImage) { [weak self] result in
                    guard let self = self, let (overlayImage, classPixelCounts) = result else { return }
                    DispatchQueue.main.async {
                        self.overlayImage = overlayImage
                        self.classPixelCounts = classPixelCounts
                        self.classAreaRatios = self.calculateClassAreaRatios(from: classPixelCounts)
                    }
                }
            }
        }
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}






