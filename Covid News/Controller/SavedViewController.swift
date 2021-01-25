//
//  SavedViewController.swift
//  Covid News
//
//  Created by Alex Paul on 12/31/20.
//  Copyright © 2020 Alexander Paul. All rights reserved.
//

import UIKit
import WebKit

class SavedViewController: UIViewController {
    @IBOutlet weak var savedArticle: WKWebView!
    weak var website: News?
    
    override func viewDidLoad() {
      super.viewDidLoad()
        loadWebsite()
      }

  func loadWebsite(){
       if let url = URL(string: website?.urlWebsite ?? "" ) {
        let request = URLRequest(url: url)
        savedArticle.load(request)
        }
      }
    

}
    

