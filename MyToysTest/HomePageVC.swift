//
//  HomePageVC.swift
//  MyToysTest
//
//  Created by LiLietz on 09.06.17.
//  Copyright © 2017 LiLietz. All rights reserved.
//

import UIKit

class HomePageVC: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var currentUrl: String = Constants.myToysUrl
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.webViewLoad(urlString: self.currentUrl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewLoad(urlString: String) {
        if let url = URL(string: urlString) {
            let request: URLRequest = URLRequest(url: url)
            self.webView.loadRequest(request)
        }
    }
    
    @IBAction func tappedMenuButton(_ sender: Any) {
        let menuNC = UINavigationController()
        let vc = MenuTVC()
        menuNC.viewControllers.append(vc)
        
        self.present(menuNC, animated: true, completion: nil)
    }
    
    
}
