//
//  LatestNewsViewController.swift
//  Covid News
//
//  Created by Alex Paul on 8/22/20.
//  Copyright © 2020 Alexander Paul. All rights reserved.
//

import UIKit

class LatestNewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let newsData = Articles() //Model object
    
    let urlRequest = "https://newsapi.org/v2/everything?q=coronavirus&apiKey=d32071cd286c4f6b9c689527fc195b03" //Website API
    var urlSelected = ""

    var articles: [Articles]? = [] // holds array of Articles data
    
    
    @IBOutlet weak var table_view: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table_view.cellLayoutMarginsFollowReadableWidth = true
        navigationController?.navigationBar.prefersLargeTitles = true
        retriveData()
        
        
    }
    
    func retriveData(){
        guard let aritcleUrl = URL(string: urlRequest) else { //send a request to the server
            return
        }
        
        let request = URLRequest(url: aritcleUrl)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in //collects content from website
            
            if  error != nil { // checks if content is available
                print(error ?? 0)
                return
            }
            if let data = data { // converts data to an array of Article objects
                self.articles = self.parseData(data: data)
                
                
                
            }
            
            
        })
        
        task.resume()
    }
    
    
    func parseData(data:Data)-> [Articles]   {
        var articles: [Articles]? = [] // holds parsed data
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            
            let jsonArticles = jsonResult?["articles"] as? [AnyObject] ?? [] // gets first head of json file and converts it to dictionary
            
            for jsonArticle in jsonArticles{ // captures data and stores it in the model object
                let article = Articles()
                article.author = jsonArticle["author"] as? String
                article.title = jsonArticle["description"] as? String
                article.publishedAt = jsonArticle["publishedAt"] as? String
                article.urlImage = jsonArticle["urlToImage"] as? String
                article.urlWebsite = jsonArticle["url"] as? String
                articles?.append(article) //put article data in the array
            }
            

            DispatchQueue.main.async {
                
                if(articles!.count > 0)
                {
                    self.table_view.reloadData()
                }
            }
            
        } catch {
            print("Nothing my guy\(error)")
        }
        
        return articles ??  [] // returns an array of articles
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 163
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! NewsTableViewCell
        cell.authorName.text = articles?[indexPath.row].author
        cell.headLine.text = articles?[indexPath.row].title
        cell.timePublication.text = articles?[indexPath.row].publishedAt
        cell.newsImage.downloadImage(from:(self.articles?[indexPath.item].urlImage ?? "nill"))
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "article"{
            if table_view.indexPathForSelectedRow != nil{
                let destinationController = segue.destination as! ArticleViewController
                destinationController.url = self.urlSelected
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.urlSelected = self.articles?[indexPath.row].urlWebsite ?? ""
    }
    
    
    
    
}

 

extension UIImageView {
    
    func downloadImage(from url: String){
        
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
            
            if error != nil {
                print(error ?? 0)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
}

