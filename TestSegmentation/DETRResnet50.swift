//
//  Untitled.swift
//  TestSegmentation
//
//  Created by user5773 on 9/16/24.
//
import CoreML
import Vision
import UIKit
import CoreVideo

class DETRResnet50Model {
    private let model: DETRResnet50SemanticSegmentationF16
    let labels: [String] = ["--", "person", "bicycle", "car", "motorcycle", "airplane", "bus", "train", "truck", "boat", "traffic light", "fire hydrant", "--", "stop sign", "parking meter", "bench", "bird", "cat", "dog", "horse", "sheep", "cow", "elephant", "bear", "zebra", "giraffe", "--", "backpack", "umbrella", "--", "--", "handbag", "tie", "suitcase", "frisbee", "skis", "snowboard", "sports ball", "kite", "baseball bat", "baseball glove", "skateboard", "surfboard", "tennis racket", "bottle", "--", "wine glass", "cup", "fork", "knife", "spoon", "bowl", "banana", "apple", "sandwich", "orange", "broccoli", "carrot", "hot dog", "pizza", "donut", "cake", "chair", "couch", "potted plant", "bed", "--", "dining table", "--", "--", "toilet", "--", "tv", "laptop", "mouse", "remote", "keyboard", "cell phone", "microwave", "oven", "toaster", "sink", "refrigerator", "--", "book", "clock", "vase", "scissors", "teddy bear", "hair drier", "toothbrush", "--", "banner", "blanket", "--", "bridge", "--", "--", "--", "--", "cardboard", "--", "--", "--", "--", "--", "--", "counter", "--", "curtain", "--", "--", "door", "--", "--", "--", "--", "--", "floor (wood)", "flower", "--", "--", "fruit", "--", "--", "gravel", "--", "--", "house", "--", "light", "--", "--", "mirror", "--", "--", "--", "--", "net", "--", "--", "pillow", "--", "--", "platform", "playingfield", "--", "railroad", "river", "road", "--", "roof", "--", "--", "sand", "sea", "shelf", "--", "--", "snow", "--", "stairs", "--", "--", "--", "--", "tent", "--", "towel", "--", "--", "wall (brick)", "--", "--", "--", "wall (stone)", "wall (tile)", "wall (wood)", "water (other)", "--", "window (blind)", "window (other)", "--", "--", "tree", "fence", "ceiling", "sky (other)", "cabinet", "table", "floor (other)", "pavement", "mountain", "grass", "dirt", "paper", "food (other)", "building (other)", "rock", "wall (other)", "rug"]

    // 背景および不要なクラスは透明に、その他のクラスに対して色を割り当て　　//CameraViewModelに渡す為にprivate letは使わない
    let classColors: [Int: UIColor] = [  //CameraViewModelに渡す為にprivate letは使わない
        0: .clear,  // 背景
        1: .red,    // person
        2: .green,  // bicycle
        3: .blue,   // car
        4: .cyan,   // motorcycle
        5: .magenta, // airplane
        6: .yellow, // bus
        7: .orange, // train
        8: .purple, // truck
        9: .brown,  // boat
        10: .lightGray, // traffic light
        11: .darkGray,  // fire hydrant
        12: .clear,     // 無効クラス（透明）
        13: .red,       // stop sign
        14: .green,     // parking meter
        15: .blue,      // bench
        16: .cyan,      // bird
        17: .magenta,   // cat
        18: .yellow,    // dog
        19: .orange,    // horse
        20: .purple,    // sheep
        21: .brown,     // cow
        22: .red,       // elephant
        23: .green,     // bear
        24: .blue,      // zebra
        25: .cyan,      // giraffe
        26: .clear,     // 無効クラス（透明）
        27: .yellow,    // backpack
        28: .orange,    // umbrella
        29: .clear,     // 無効クラス（透明）
        30: .clear,     // 無効クラス（透明）
        31: .red,       // handbag
        32: .green,     // tie
        33: .blue,      // suitcase
        34: .cyan,      // frisbee
        35: .magenta,   // skis
        36: .yellow,    // snowboard
        37: .orange,    // sports ball
        38: .purple,    // kite
        39: .brown,     // baseball bat
        40: .red,       // baseball glove
        41: .green,     // skateboard
        42: .blue,      // surfboard
        43: .cyan,      // tennis racket
        44: .magenta,   // bottle
        45: .clear,     // 無効クラス（透明）
        46: .orange,    // wine glass
        47: .purple,    // cup
        48: .brown,     // fork
        49: .red,       // knife
        50: .green,     // spoon
        51: .blue,      // bowl
        52: .cyan,      // banana
        53: .magenta,   // apple
        54: .yellow,    // sandwich
        55: .orange,    // orange
        56: .purple,    // broccoli
        57: .brown,     // carrot
        58: .red,       // hot dog
        59: .green,     // pizza
        60: .blue,      // donut
        61: .cyan,      // cake
        62: .magenta,   // chair
        63: .yellow,    // couch
        64: .orange,    // potted plant
        65: .purple,    // bed
        66: .clear,     // 無効クラス（透明）
        67: .red,       // dining table
        68: .clear,     // 無効クラス（透明）
        69: .clear,     // 無効クラス（透明）
        70: .cyan,      // toilet
        71: .clear,     // 無効クラス（透明）
        72: .yellow,    // tv
        73: .orange,    // laptop
        74: .purple,    // mouse
        75: .brown,     // remote
        76: .red,       // keyboard
        77: .green,     // cell phone
        78: .blue,      // microwave
        79: .cyan,      // oven
        80: .magenta,   // toaster
        81: .yellow,    // sink
        82: .orange,    // refrigerator
        83: .clear,     // 無効クラス（透明）
        84: .brown,     // book
        85: .red,       // clock
        86: .green,     // vase
        87: .blue,      // scissors
        88: .cyan,      // teddy bear
        89: .magenta,   // hair drier
        90: .yellow,    // toothbrush
        91: .clear,     // 無効クラス（透明）
        92: .orange,    // banner
        93: .purple,    // blanket
        94: .clear,     // 無効クラス（透明）
        95: .green,     // bridge
        96: .clear,     // 無効クラス（透明）
        97: .clear,     // 無効クラス（透明）
        98: .clear,     // 無効クラス（透明）
        99: .clear,     // 無効クラス（透明）
        100: .orange,   // cardboard
        101: .clear,    // 無効クラス（透明）
        102: .clear,    // 無効クラス（透明）
        103: .clear,    // 無効クラス（透明）
        104: .clear,    // 無効クラス（透明）
        105: .clear,    // 無効クラス（透明）
        106: .cyan,     // counter
        107: .clear,    // 無効クラス（透明）
        108: .orange,   // curtain
        109: .clear,    // 無効クラス（透明）
        110: .clear,    // 無効クラス（透明）
        111: .clear,    // 無効クラス（透明）
        // 他のクラスも透明に設定
    ]

    init() {
        self.model = try! DETRResnet50SemanticSegmentationF16()
    }
    
    // 画像を448x448にリサイズ＆トリミングする関数
    func preprocessImage(_ image: UIImage) -> UIImage {
        let targetSize = CGSize(width: 448, height: 448)
        let aspectRatio = image.size.width / image.size.height
        
        var scaledSize: CGSize
        if aspectRatio > 1 {
            // 横長の画像
            scaledSize = CGSize(width: targetSize.height * aspectRatio, height: targetSize.height)
        } else {
            // 縦長の画像
            scaledSize = CGSize(width: targetSize.width, height: targetSize.width / aspectRatio)
        }
        
        // 描画するコンテキストを作成
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
        
        // 余分な部分を中央にトリミング
        let origin = CGPoint(x: (targetSize.width - scaledSize.width) / 2, y: (targetSize.height - scaledSize.height) / 2)
        image.draw(in: CGRect(origin: origin, size: scaledSize))
        
        // リサイズされた画像を取得
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage!
    }

    
    // セグメンテーション推論を行う
    func predict(image: UIImage, completion: @escaping ((UIImage?, [Int: Int])?) -> Void) {
        let resizedImage = preprocessImage(image)
        guard let pixelBuffer = resizedImage.toCVPixelBuffer() else {
            completion(nil)
            return
        }

        let request = VNCoreMLRequest(model: try! VNCoreMLModel(for: model.model)) { request, error in
                    if let results = request.results as? [VNCoreMLFeatureValueObservation],
                       let segmentationMask = results.first?.featureValue.multiArrayValue {
                        if let (maskImage, classPixelCounts) = self.createSegmentationMask(from: segmentationMask) {
                            let overlayImage = self.overlaySegmentationMask(on: resizedImage, maskImage: maskImage)
                            completion((overlayImage, classPixelCounts)) // ピクセルカウントも返す
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }

        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        try? handler.perform([request])
    }

    
    //セグメンテーションされた各クラスのピクセル数をカウントする関数
    func calculateClassAreaRatios(from multiArray: MLMultiArray) -> [Int: Double] {
        let width = 448
        let height = 448
        var classPixelCounts = [Int: Int]() // クラスごとのピクセル数を保持
        
        for y in 0..<height {
            for x in 0..<width {
                let index = y * width + x
                let classLabel = multiArray[index].int32Value
                classPixelCounts[Int(classLabel), default: 0] += 1
            }
        }
        
        // 全ピクセル数を使って面積比を計算
        let totalPixels = width * height
        var classAreaRatios = [Int: Double]()
        for (classLabel, pixelCount) in classPixelCounts {
            classAreaRatios[classLabel] = Double(pixelCount) / Double(totalPixels)
        }
        
        return classAreaRatios
    }

    
    // セグメンテーションマスクを色分けしてUIImageに変換し、ピクセルカウントも行う
    func createSegmentationMask(from multiArray: MLMultiArray) -> (UIImage?, [Int: Int])? {
        let width = 448
        let height = 448
        var pixelData = [UInt8](repeating: 0, count: width * height * 4) // RGBA: 4チャンネル
        
        // クラスごとのピクセル数を保持する辞書
        var classPixelCounts = [Int: Int]()
        
        for y in 0..<height {
            for x in 0..<width {
                let index = y * width + x
                let classLabel = multiArray[index].int32Value
                
                // クラスごとのピクセル数をカウント
                classPixelCounts[Int(classLabel), default: 0] += 1

                let color = classColors[Int(classLabel)] ?? UIColor.clear // クラスがない部分は透明
                
                // CGColorのコンポーネントを取得し、足りない部分はデフォルト値を使う
                let components = color.cgColor.components ?? [0, 0, 0, 0]
                let red = UInt8((components.count > 0 ? components[0] : 0) * 255)  // R
                let green = UInt8((components.count > 1 ? components[1] : 0) * 255) // G
                let blue = UInt8((components.count > 2 ? components[2] : 0) * 255)  // B
                let alpha = UInt8((components.count > 3 ? components[3] : 1) * 255) // A (デフォルトは1)

                let pixelIndex = index * 4
                pixelData[pixelIndex] = red
                pixelData[pixelIndex + 1] = green
                pixelData[pixelIndex + 2] = blue
                pixelData[pixelIndex + 3] = alpha
            }
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)

        // ピクセルデータを使ってCGImageを生成
        guard let context = CGContext(data: &pixelData, width: width, height: height,
                                      bitsPerComponent: 8, bytesPerRow: 4 * width,
                                      space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {
            return nil
        }

        guard let cgImage = context.makeImage() else { return nil }
        
        // 上下反転させた画像を作成するためのグラフィックスコンテキスト
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        if let flippedContext = UIGraphicsGetCurrentContext() {
            // 座標系を修正（反転させない）
            flippedContext.translateBy(x: 0, y: 0)
            flippedContext.scaleBy(x: 1.0, y: 1.0) // デフォルトの座標系をそのまま使用

            // 正しい向きで画像を描画
            flippedContext.draw(cgImage, in: CGRect(origin: .zero, size: CGSize(width: width, height: height)))
            
            // UIImageを取得
            let normalImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return (normalImage, classPixelCounts) // 画像とクラスのピクセル数を返す
        }
        
        return nil
    }


    // 元画像にセグメンテーションマスクをオーバーレイ
    func overlaySegmentationMask(on image: UIImage, maskImage: UIImage?) -> UIImage? {
        guard let maskImage = maskImage else { return nil }
        
        // オーバーレイのためのグラフィックスコンテキストを作成
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(origin: .zero, size: image.size))
        maskImage.draw(in: CGRect(origin: .zero, size: image.size), blendMode: .normal, alpha: 0.5)
        
        // オーバーレイされた画像を取得
        let overlayImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // オーバーレイ画像を90度回転させる
        return overlayImage?.rotate(radians: .pi / 2)
    }

}

extension UIImage {
    func toCVPixelBuffer() -> CVPixelBuffer? {
        let width = Int(self.size.width)
        let height = Int(self.size.height)

        let attributes: [CFString: Any] = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue!,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue!
        ]
        
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32ARGB, attributes as CFDictionary, &pixelBuffer)
        
        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(buffer, .readOnly)
        let pixelData = CVPixelBufferGetBaseAddress(buffer)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(data: pixelData, width: width, height: height,
                                      bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
                                      space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) else {
            CVPixelBufferUnlockBaseAddress(buffer, .readOnly)
            return nil
        }
        
        UIGraphicsPushContext(context)
        self.draw(in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
        UIGraphicsPopContext()
        
        CVPixelBufferUnlockBaseAddress(buffer, .readOnly)
        
        return buffer
    }
    
    func rotate(radians: CGFloat) -> UIImage? {
        var newSize = CGRect(origin: .zero, size: self.size)
            .applying(CGAffineTransform(rotationAngle: radians)).size
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContext(newSize)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        // Move the origin to the middle of the image so we can rotate around the center.
        context.translateBy(x: newSize.width / 2, y: newSize.height / 2)
        // Rotate the image context.
        context.rotate(by: radians)

        // Now, draw the rotated/scaled image into the context
        self.draw(in: CGRect(x: -self.size.width / 2, y: -self.size.height / 2, width: self.size.width, height: self.size.height))

        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return rotatedImage
    }

}

