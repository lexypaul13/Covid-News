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
    
    var url : String =  "http://newsapi.org/v2/everything?domains=cdc.gov&apiKey=d32071cd286c4f6b9c689527fc195b03"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: url ) {
        let request = URLRequest(url: url)
            print(articlePage.load(request)!)
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
}
