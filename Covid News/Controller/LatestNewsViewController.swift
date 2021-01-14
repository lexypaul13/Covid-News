//
//  LatestNewsViewController.swift
//  Covid News
//
//  Created by Alex Paul on 8/22/20.
//  Copyright © 2020 Alexander Paul. All rights reserved.
//

import UIKit
import CoreData

class LatestNewsViewController: UIViewController {
    
    // MARK: - Properties
    
    // Website API
    var urlSelected = ""
    var news = ArticleManger()
    var filteredArticles: [ArticlesData]! = [] //holds searched articles
    let searchController = UISearchController(searchResultsController: nil)//sets current view to display search results
    
    var isSearchBarEmpty: Bool { // return true if search bar is empty
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
     
    // MARK: - Selectors
    
    @objc func refreshTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - IBOutlet(s)
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        news.performRequest()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTableView), name: Notification.Name("didFinishParsing"), object: nil)
        tableView.dataSource = self
        tableView.delegate = self
 
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.searchResultsUpdater = self //informs class of  any text changes within the searchBar.
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search News" //sets place holder name
        navigationItem.searchController = searchController //adds sreach bar to navigation item
        definesPresentationContext = true //ensures that search bar doesnt remain on screen when user moves to another screemn
    }
    
    // MARK: - IBAction(s)
    
    @IBAction func shareButton(_ sender: UIButton) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
        if let indexPath = self.tableView.indexPathForRow(at: buttonPosition) {
            let newRelease = news.articles?[indexPath.row].urlWebsite
            let activityVC = UIActivityViewController(activityItems: [newRelease ?? 0], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating

extension LatestNewsViewController: UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    // determines what type of data
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredArticles?.count ?? 0
        }
        return news.articles?.count ?? 0
    }
    
    // displays contents of  json file on table cells  and filters for search results
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! NewsTableViewCell
        let stories = news.articles
        var news: ArticlesData
       
        if isFiltering {
            news = filteredArticles![indexPath.row]
        } else {
            news = stories![indexPath.row]
        }
        cell.authorName.text = news.author?.trunc(length: 21)
        
        cell.headLine.text = news.myDescription?.trunc(length: 100)
        cell.newsImage.downloadImage(from: news.urlImage ?? " ")
        cell.timePublication.text = news.publishedAt?.convertToDisplayFormat()
    
        return cell
    }
    
    
    
    
    // perform transition to safari webview
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let stories = news.articles
        
        if segue.identifier == "articles"{
            let destinationController = segue.destination as! ArticleViewController
            destinationController.website = stories![(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    // increses table row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 163
    }
    
    
    /// Save article by swiping left
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let save = UIContextualAction(style: .normal, title: "Save") { (_, _, completionHandler) in
            completionHandler(true)
            guard let article = self.news.articles?[indexPath.row] else { return }
            CoreDataManger.sharedInstance.saveArticle(article: article)
            let alert = UIAlertController(title: "Saved", message: nil,preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        save.backgroundColor = .systemBlue
        
        let swipe =  UISwipeActionsConfiguration(actions: [save])
        return swipe
    }
    
    func updateSearchResults(for searchController: UISearchController) { // updates search result from text typed from the user
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!, news.articles!)
    }
    
    // filters through articles to find matching results and reloadsa table view
    func filterContentForSearchText(_ searchText: String, _ category: [ArticlesData]) {
        filteredArticles =  news.articles?.filter({ (article: ArticlesData) -> Bool in
            return (article.myDescription?.lowercased().contains(searchText.lowercased()) ?? false)
        })
        tableView.reloadData()
    }
    
}
    

