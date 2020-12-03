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
  
  static let sharedInstance = CoreDataManger()
  private override init() {}
  
  var newsCoreData: [News] = []
  var article = ArticlesData()
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
  
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

//extension CoreDataStack {
//
//    func applicationDocumentsDirectory() {
//        // The directory the application uses to store the Core Data store file. This code uses a directory named "yo.BlogReaderApp" in the application's documents directory.
//        if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
//            print(url.absoluteString)
//        }
//    }
//}
