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
    weak var website: ArticlesData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: website?.unwrappedUrlWebsite ?? "" ) {
            let request = URLRequest(url: url)
            articlePage.load(request)
         }
    }
    
}
