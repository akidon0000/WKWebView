//
//  ViewController.swift
//  WKWebView_test
//
//  Created by Akihiro Matsuyama on 2020/12/21.
//  Copyright © 2020 Akihiro Matsuyama. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
	
	@IBAction func webButton(_ sender: Any) {
		webView_move()
	}
	
	@IBAction func cameraButton(_ sender: Any) {
		cameraView_move()
	}
	override func viewDidLoad() {
        super.viewDidLoad()
    }
	func webView_move(){
		let vc = R.storyboard.wkWebView.wkWebStory()!
		self.present(vc, animated: true, completion: nil)
	}
	func cameraView_move(){
		let vc = R.storyboard.cameraView.cameraStry()!
		self.present(vc, animated: true, completion: nil)
	}
}
