//
//  ArticlesManagers.swift
//  Covid News
//
//  Created by Alex Paul on 11/2/20.
//  Copyright © 2020 Alexander Paul. All rights reserved.
//

import UIKit
import CoreData

class ArticleManger{
    
    //var website = "http://newsapi.org/v2/everything?q=coronavirus&sortBy=popularity&apiKey=d32071cd286c4f6b9c689527fc195b03&pageSize=20&page=1"
    var articles: [ArticlesData]? = [] // holds array of model object
    let cache   = NSCache<NSString, UIImage>()
    var date: String?
    var baseUrl = "http://newsapi.org/v2/everything?q=coronavirus&sortBy=popularity"
    var apiKey = "&apiKey=d32071cd286c4f6b9c689527fc195b03&"
    var pageNumber = "pageSize=50&page=2"
    
    //send a request to the server
    func performRequest(page:Int) {
        let endPoint = baseUrl + "&apiKey=d32071cd286c4f6b9c689527fc195b03&" + "pageSize=20&page=\(page)"
        guard let aritcleUrl = URL(string: endPoint) else {return}
        let request = URLRequest(url: aritcleUrl)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) -> Void in //collects content from website
            guard let self = self else { return }
            if  error != nil { // checks if content is available
                print(error ?? 0)
                return
            }
            if let data = data { self.articles = self.parseData(data: data) }})
        task.resume()
    }
    
    
    
    func parseData(data: Data) -> [ArticlesData]? {
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            let jsonArticles = jsonResult?["articles"] as? [AnyObject] ?? [] // gets first head of json file and converts it to dictionary
            for jsonArticle in jsonArticles { // captures data and stores it in the model object
                let article = ArticlesData()
                article.author = jsonArticle["author"] as? String
                article.myDescription = jsonArticle["description"] as? String
                article.publishedAt = jsonArticle["publishedAt"] as? String
                article.urlImage = jsonArticle["urlToImage"] as? String
                article.urlWebsite = jsonArticle["url"] as? String
                articles?.append(article) //put article data in the array
            }
            articles?.sort(by:{ $0.publishedAt! > $1.publishedAt! })
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name("didFinishParsing"), object: nil)
        } catch {
            print("\(error)")
        }
        return articles ?? []
    }
}
