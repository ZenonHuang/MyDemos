//
//  ViewController.swift
//  SwiftPlugin
//
//  Created by zz go on 2023/5/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func tapButton(_ sender: Any) {
        
        let gameVC = HZGameViewController()
        self.navigationController?.pushViewController(gameVC, animated: true)
    }
    
}

