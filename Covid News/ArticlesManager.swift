//
//  ArticlesManagers.swift
//  Covid News
//
//  Created by Alex Paul on 11/2/20.
//  Copyright © 2020 Alexander Paul. All rights reserved.
//

import Foundation



class ArticleManger{
    let website = "http://newsapi.org/v2/everything?q=coronavirus&sortBy=popularity&apiKey=d32071cd286c4f6b9c689527fc195b03&pageSize=50&page=2" //Website API
    var articles: [ArticlesData]? = [] // holds array of model object

    func fetchArticles() {
        performRequest(urlString: website)
    }
    
    
    func performRequest(urlString: String){
        if let url = URL(string: website) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil{
                    print(error ?? 0)
                    return
                }
                if let data = data {
                    self.articles = self.parseData(data: data)
                    
                }
                
            }
            task.resume()
            return
        }
    }
    func parseData(data :Data)->[ArticlesData]?  {
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            
            let jsonArticles = jsonResult?["articles"] as? [AnyObject] ?? [] // gets first head of json file and converts it to dictionary
            let article = ArticlesData()
            
            for jsonArticle in jsonArticles{ // captures data and stores it in the model object
                article.author = jsonArticle["author"] as? String
                article.title = jsonArticle["description"] as? String
                article.publishedAt = jsonArticle["publishedAt"] as? String
                article.urlImage = jsonArticle["urlToImage"] as? String
                article.urlWebsite = jsonArticle["url"] as? String
                articles?.append(article) //put article data in the array
            }
            print(jsonArticles)
        }catch{
           print("\(error)")
            
        }
        return articles ?? []
    }
    
}
