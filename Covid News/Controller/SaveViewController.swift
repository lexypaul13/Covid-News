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
    var newsData = CoreDataManger.sharedInstance.newsCoreData
    var fetchRequest = CoreDataManger.sharedInstance.loadArticles()
    
    var fetchedResultController:NSFetchedResultsController = NSFetchedResultsController<NSFetchRequestResult>()
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureFetchResults()
        configureTableView()
    }
    
    func configureTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    func configureFetchResults(){
        fetchedResultController = getResultFetchedResultController()
        fetchedResultController.delegate = self
        do{
            try fetchedResultController.performFetch()
        }catch _ {
            
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let task: News = fetchedResultController.object(at: indexPath ?? []) as! News
        if segue.identifier == "articles2"{
            let destinationController = segue.destination as! SavedViewController
            destinationController.website = task
        }
        
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
        cell.authorName.text = news.unwrappedAuthor.trunc(length: 21)
        cell.headLine.text = news.unwrappedmyDescription.trunc(length: 82)
        cell.timePublication.text = news.unwrappedPublishedAt.convertToDisplayFormat()
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
