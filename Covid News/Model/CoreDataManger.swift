//
//  CoreDataManger.swift
//  Covid News
//
//  Created by Alex Paul on 11/27/20.
//  Copyright © 2020 Alexander Paul. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManger: NSObject {
  
  // MARK: - Properties
  static let sharedInstance = CoreDataManger()
    
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  //let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
  
  var newsCoreData: [News] = []
  var article = ArticlesData()
  
  // MARK: - Lifecycle
  
  private override init() {}
  
  // MARK: - Core Data Saving support
  
  /// Saves an ArticlesData object as a News object
  func saveArticle(article: ArticlesData) {
    
    // Create an new 'News' object
    let news = News(context: context)
    news.setValue("\(article.author ?? "")", forKeyPath: "author")
    news.setValue("\(article.myDescription ?? "")", forKeyPath: "myDescription")
    news.setValue("\(article.publishedAt ?? "")", forKeyPath: "publishedAt")
    news.setValue("\(article.title ?? "")", forKeyPath: "title")
    news.setValue("\(article.urlImage ?? "")", forKeyPath: "urlImage")
    news.setValue("\(article.urlWebsite ?? "")", forKeyPath: "urlWebsite")
    
    // Save to CoreData
    do {
      try context.save()
    } catch let error {
      print("Failed to create Person: \(error.localizedDescription)")
    }
  }
  
    func loadArticles()-> NSFetchRequest<NSFetchRequestResult>{
         let fetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "News")
         fetchRequest.fetchLimit = newsCoreData.count
         let sortDescriptor = NSSortDescriptor(key: "publishedAt", ascending: true)
         fetchRequest.sortDescriptors = [sortDescriptor]

         return fetchRequest
    }

    
   /** func loadArticles()->NSFetchedResultsController<NSFetchRequestResult>{
        let fetchRequest = NSFetchRequest<News>(entityName: "News")
        do{
            let fetchedResults = try context.fetch(fetchRequest)
         }catch let error as NSError {
            // something went wrong, print the error.
            print(error.description)
        }
        
    } **/
    
    
  /// Prints the Core Data path and can be viewed in Finder
  func printCoreDataDBPath() {
    let path = FileManager
      .default
      .urls(for: .applicationSupportDirectory, in: .userDomainMask)
      .last?
      .absoluteString
      .replacingOccurrences(of: "file://", with: "")
      .removingPercentEncoding
    print("Core Data DB Path: \(path ?? "Not found")")
  }
  
  
   
  
}
