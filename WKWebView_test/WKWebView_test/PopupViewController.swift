//
//  PopupViewController.swift
//  WKWebView_test
//
//  Created by Akihiro Matsuyama on 2020/12/25.
//  Copyright © 2020 Akihiro Matsuyama. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {

    var delegate :WKWebViewController?
    
    @IBAction func backButton(_ sender: Any) {
        //自分自身を閉じる（破棄する）
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
