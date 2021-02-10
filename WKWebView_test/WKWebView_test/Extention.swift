//
//  Extention.swift
//  WKWebView_test
//
//  Created by Akihiro Matsuyama on 2020/12/23.
//  Copyright © 2020 Akihiro Matsuyama. All rights reserved.
//

import UIKit
import WebKit
import AVFoundation



extension WKWebViewController: WKUIDelegate {

    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {

        // Create new WKWebView with custom configuration here
        let configuration = WKWebViewConfiguration()

        return WKWebView(frame: webView.frame, configuration: configuration)
    }
}

//MARK: カメラ設定メソッド
extension CameraViewController{
    // カメラの画質の設定
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }

    // デバイスの設定
    func setupDevice() {
        // カメラデバイスのプロパティ設定
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        // プロパティの条件を満たしたカメラデバイスの取得
        let devices = deviceDiscoverySession.devices

        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                mainCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                innerCamera = device
            }
        }
        // 起動時のカメラを設定
        currentDevice = mainCamera
    }

    // 入出力データの設定
    func setupInputOutput() {
        do {
            // 指定したデバイスを使用するために入力を初期化
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice!)
            // 指定した入力をセッションに追加
            captureSession.addInput(captureDeviceInput)
            // 出力データを受け取るオブジェクトの作成
            photoOutput = AVCapturePhotoOutput()
            // 出力ファイルのフォーマットを指定
            photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        } catch {
            print(error)
        }
    }

    // カメラのプレビューを表示するレイヤの設定
    func setupPreviewLayer() {
        // 指定したAVCaptureSessionでプレビューレイヤを初期化
        self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        // プレビューレイヤが、カメラのキャプチャーを縦横比を維持した状態で、表示するように設定
        self.cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        // プレビューレイヤの表示の向きを設定
        self.cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait

        self.cameraPreviewLayer?.frame = view.frame
        self.view.layer.insertSublayer(self.cameraPreviewLayer!, at: 0)
    }
}

//// imagePickerViewの設定用
//extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
//
//    // カメラの利用
//    func addCameraView() {
//
//        // シミュレーターでやるとカメラが使えないから、クラッシュしないようにアラート表示させる方へ分岐
//        if !UIImagePickerController.isSourceTypeAvailable(.camera){
//
//            let alertController = UIAlertController.init(title: nil, message: "Device has no camera.", preferredStyle: .alert)
//
//            let okAction = UIAlertAction.init(title: "Alright", style: .default, handler: {(alert: UIAlertAction!) in
//            })
//
//            alertController.addAction(okAction)
//            self.present(alertController, animated: true, completion: nil)
//
//        }
//        else{
//            //imagePickerViewを表示する
//            let pickerController = UIImagePickerController()
//            pickerController.sourceType = .camera
//            pickerController.delegate = self
//            self.present(pickerController, animated: true, completion: nil)
//        }
//    }
//
//    // ライブラリーの利用
//    func addImagePickerView() {
//        //imagePickerViewを表示する
//        let pickerController = UIImagePickerController()
//        pickerController.sourceType = .photoLibrary
//        pickerController.delegate = self
//        self.present(pickerController, animated: true, completion: nil)
//    }
//
//    // 以下の二つは、sourceTypeがcameraでもphotoLibraryでも共通
//    // pickerの選択がキャンセルされた時の処理
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//         dismiss(animated: true, completion: nil)
//    }
//    // 画像が選択(撮影)された時の処理
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        print("The image was selected")
//        print(info[UIImagePickerController.InfoKey.originalImage] as! UIImage)
//
//        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage? else {return}
//
//        // imageを格納
////        imageView.image = selectedImage
//
//        self.dismiss(animated: true, completion: nil)
//    }
//}
