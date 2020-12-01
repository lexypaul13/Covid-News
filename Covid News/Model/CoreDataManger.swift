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
 
    // MARK: - Core Data Saving support
    
    func createData(){
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        DispatchQueue.main.async(execute: { [self] in
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Now let’s create an entity and new user records.
        let newsEntity = NSEntityDescription.entity(forEntityName: "News", in: managedContext)!
        let news = NSManagedObject(entity: newsEntity, insertInto: managedContext)

        for article in self.newsCoreData{
         news.setValue("\(article.author ?? "")", forKeyPath: "author")
         news.setValue("\(article.myDescription ?? "")", forKeyPath: "myDescription")
         news.setValue("\(article.publishedAt ?? "")", forKeyPath: "publishedAt")
         news.setValue("\(article.title ?? "")", forKeyPath: "title")
         news.setValue("\(article.urlImage ?? "")", forKeyPath: "urlImage")
         news.setValue("\(article.urlWebsite ?? "")", forKeyPath: "urlWebsite")
 
        }
        
       //Now we have set all the values. The next step is to save them inside the Core Data
        
        do {
            try managedContext.save()
            newsCoreData.append(news as! News)
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

    }
        )}
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
