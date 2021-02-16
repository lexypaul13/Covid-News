//
//  ArticlesManagers.swift
//  Covid News
//
//  Created by Alex Paul on 11/2/20.
//  Copyright © 2020 Alexander Paul. All rights reserved.
//

import UIKit

class ArticleManger{
    
    var articles: [ArticlesData]? = []
    var baseUrl = "http://newsapi.org/v2/everything?q=covid&sortBy=popularity"
    var apiKey =  "&apiKey=d32071cd286c4f6b9c689527fc195b03&"
    
    func performRequest(page:Int) {
        let endPoint = baseUrl + apiKey + "pageSize=20&page=\(page)"
        guard let aritcleUrl = URL(string: endPoint) else {
            print("Invalid Url")
            return
        }
        let request = URLRequest(url: aritcleUrl)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) -> Void in
            guard let self = self else { return }
            if  error != nil {
                print(error?.localizedDescription ?? "")
                return
            }
            if let data = data {self.articles = self.parseData(data: data)}})
        task.resume()
    }
    
    
    
    func parseData(data: Data) -> [ArticlesData]? {
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            let jsonArticles = jsonResult?["articles"] as? [AnyObject] ?? []
          
            for jsonArticle in jsonArticles {
                let article = ArticlesData()
                article.author = jsonArticle["author"] as? String
                article.myDescription = jsonArticle["description"] as? String
                article.publishedAt = jsonArticle["publishedAt"] as? String
                article.urlImage = jsonArticle["urlToImage"] as? String
                article.urlWebsite = jsonArticle["url"] as? String
                articles?.append(article)
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
