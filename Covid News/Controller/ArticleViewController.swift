//
//  ArticleViewController.swift
//  Covid News
//
//  Created by Alex Paul on 8/29/20.
//  Copyright © 2020 Alexander Paul. All rights reserved.
//

import UIKit
import WebKit
class ArticleViewController: UIViewController {

    @IBOutlet weak var articlePage: WKWebView!
    
    
    var url : String =  "http://newsapi.org/v2/everything?q=coronavirus&sortBy=popularity&apiKey=d32071cd286c4f6b9c689527fc195b03&pageSize=50&page=2"
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        if let url = URL(string: url ) {
        let request = URLRequest(url: url)
            articlePage.load(request)
        // Do any additional setup after loading the view.
    }
}
    
    
}
