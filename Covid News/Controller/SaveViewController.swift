//
//  ViewController.swift
//  Covid News
//
//  Created by Alex Paul on 12/5/20.
//  Copyright © 2020 Alexander Paul. All rights reserved.
//

import UIKit
import CoreData
class SaveViewController: UIViewController {
    
    var context = CoreDataManger.sharedInstance.context
    var fetchRequest = CoreDataManger.sharedInstance.loadArticles()
    var fetchedResultController:NSFetchedResultsController = NSFetchedResultsController<NSFetchRequestResult>()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // fetchNews.loadArticles()
        
        tableView.dataSource = self
        tableView.delegate = self
        fetchedResultController = getResultFetchedResultController()
        fetchedResultController.delegate = self
        do{
            try fetchedResultController.performFetch()
        }catch _ {
            
        }
        // Do any additional setup after loading the view.
    }
    
    
}

extension SaveViewController: UITableViewDataSource, UITableViewDelegate,NSFetchedResultsControllerDelegate {
    
    func getResultFetchedResultController()->NSFetchedResultsController<NSFetchRequestResult>{
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultController
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        let numberOfSections = fetchedResultController.sections?.count ?? 0
        
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionNumbers = fetchedResultController.sections?[section].numberOfObjects ?? 0
        return sectionNumbers
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 163
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! SaveTableViewCell
        let news = fetchedResultController.object(at: indexPath as IndexPath) as! News
        
        cell.authorName.text = news.author
        cell.headLine.text = news.myDescription
        cell.timePublication.text = news.publishedAt?.convertToDisplayFormat()
        cell.newsImage.downloadImage(from: news.urlImage ?? "")
      
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete{
            let managedObjectContext = CoreDataManger.sharedInstance.context
            let managedObject :NSManagedObject = fetchedResultController.object(at: indexPath) as! NSManagedObject
            
            managedObjectContext.delete(managedObject)
            do{
                try managedObjectContext.save()
            }catch _ {
            }
        }
    }
    

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
    
    
    
    
}
