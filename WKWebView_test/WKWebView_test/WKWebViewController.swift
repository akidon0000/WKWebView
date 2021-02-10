//
//  WKWebViewController.swift
//  WKWebView_test
//
//  Created by Akihiro Matsuyama on 2020/12/24.
//  Copyright © 2020 Akihiro Matsuyama. All rights reserved.
//

import UIKit
import WebKit

import WebViewJavascriptBridge

class WKWebViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
    
    var webView: WKWebView!
    var bridge:WebViewJavascriptBridge?
    
    @IBAction func imgButton(_ sender: Any) {
        self.bridge = WebViewJavascriptBridge.init(forWebView: webView)
        // WKWebView内のjavascriptからSwift内のデータを取得
        self.bridge!.registerHandler("image") { (data, callback) in
            if let imagePath = Bundle.main.path(forResource: "PNG", ofType: "png") {
                // PNGデータをUIImageに
                let image = UIImage(contentsOfFile: imagePath)
                // Data型へ変換
                let data = image?.pngData()
                // PNGのデータをbase64エンコードしてWebViewで表示できるよう修正
                let base64Image = data?.base64EncodedString(options: .endLineWithLineFeed)
                callback!(base64Image)
            }
        }
        let request = URLRequest(url: URL(string: "http://127.0.0.1:5500/Test/test.html")!)
        self.webView.load(request)
    }
    
    @IBAction func actionButton(_ sender: Any) {
        
        let longitude:String = "123.456"
        let latitude:String = "654.321"

        webView.evaluateJavaScript("writeCoordinate(\(longitude),\(latitude));", completionHandler: nil)
        webView.evaluateJavaScript("coordinateButton();", completionHandler: nil)
        
        //        webView.evaluateJavaScript(execJsFunc, completionHandler: { (object, error) -> Void in
        //            // jsの関数実行結果
        //        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userController = WKUserContentController()
        userController.add(self, name: "hoge")
        
        let webConfig = WKWebViewConfiguration()
        webConfig.userContentController = userController
        
        // WKWebView生成
        webView = WKWebView(frame: CGRect(x: 0,
                                          y: 0,
                                          width: self.view.frame.size.width,
                                          height: self.view.frame.size.height-44),
                            configuration: webConfig)
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        
        
        
        
        
        // 表示するアドレス設定
//        http://127.0.0.1:5500/Test/test.html
//        http://applease.jp
//        let request = URLRequest(url: URL(string: "http://applease.jp")!)
        let request = URLRequest(url: URL(string: "http://applease.jp/index.html")!)
        self.webView.load(request)
        
        
        
        
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "hoge" {
            let vc = R.storyboard.wkWebView.popupWKweb()!
            self.present(vc, animated: true, completion: nil)
            vc.delegate = self
        }
//        print("HTMLからの通信")
    }
    
    // MARK: - 読み込み設定（リクエスト前）
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("リクエスト前")
        
        /*
         * WebView内の特定のリンクをタップした時の処理などが書ける(2019/11/16追記)
         */
        let url = navigationAction.request.url
        print("読み込もうとしているページのURLが取得できる: ", url ?? "")
        // リンクをタップしてページを読み込む前に呼ばれるので、例えば、urlをチェックして
        // ①AppStoreのリンクだったらストアに飛ばす
        // ②Deeplinkだったらアプリに戻る
        // みたいなことができる
        
        /*  これを設定しないとアプリがクラッシュする
         *  .allow  : 読み込み許可
         *  .cancel : 読み込みキャンセル
         */
        decisionHandler(.allow)
    }
    
    // MARK: - 読み込み準備開始
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("読み込み準備開始")
    }
    
    // MARK: - 読み込み設定（レスポンス取得後）
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print("レスポンス取得後")
        
        /*  これを設定しないとアプリがクラッシュする
         *  .allow  : 読み込み許可
         *  .cancel : 読み込みキャンセル
         */
        decisionHandler(.allow)
        // 注意：受け取るレスポンスはページを読み込みタイミングのみで、Webページでの操作後の値などは受け取れない
    }
    
    // MARK: - 読み込み開始
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("読み込み開始")
    }
    
    // MARK: - ユーザ認証（このメソッドを呼ばないと認証してくれない）
    func webView(_ webView: WKWebView,
                 didReceive challenge: URLAuthenticationChallenge,
                 completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("ユーザ認証")
        completionHandler(.useCredential, nil)
    }
    
    // MARK: - 読み込み完了
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("読み込み完了")
    }
    
    // MARK: - 読み込み失敗検知
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError: Error) {
        print("読み込み失敗検知")
    }
    
    // MARK: - 読み込み失敗
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError: Error) {
        print("読み込み失敗")
    }
    
    // MARK: - リダイレクト
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation:WKNavigation!) {
        print("リダイレクト")
    }
}
