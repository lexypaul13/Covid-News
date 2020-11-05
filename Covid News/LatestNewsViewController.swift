//
//  LatestNewsViewController.swift
//  Covid News
//
//  Created by Alex Paul on 8/22/20.
//  Copyright © 2020 Alexander Paul. All rights reserved.
//

import UIKit

class LatestNewsViewController: UIViewController {
    
    //Website API
    let website = "http://newsapi.org/v2/everything?q=coronavirus&sortBy=popularity&apiKey=d32071cd286c4f6b9c689527fc195b03&pageSize=50&page=2"
    var urlSelected = ""
    var news = ArticleManger()
    var filteredArticles:[ArticlesData]! = [] //holds searched articles
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    
    @IBOutlet weak var table_view: UITableView!
    
    let indDateFormatter =  ISO8601DateFormatter()
    let outDateFormtter : DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy"
        df.locale = Locale(identifier: "en_US_POSIX")
        return df
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        news.performRequest()

        table_view.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = true
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search News"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    @IBAction func shareButton(_ sender: UIButton) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.table_view)
        if let indexPath = self.table_view.indexPathForRow(at:buttonPosition) {
            let newRelease = news.articles?[indexPath.row].urlWebsite
            let activityVC = UIActivityViewController(activityItems:[newRelease ?? 0], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC,animated: true, completion: nil)
            
        }
        
        
    }
    
}


extension LatestNewsViewController: UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering{
            return filteredArticles?.count ?? 0
        }
        return news.articles?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! NewsTableViewCell
        var articleToUse = news.articles?.count
        
        if isFiltering{
            articleToUse = news.articles?.count
        }
        
        let row = news.articles?[indexPath.row]
        cell.authorName.text = row?.author
        cell.headLine.text = row?.title
        //         cell.newsImage.downloadImage(url:(row?.urlImage ?? "nill"))
        cell.timePublication.text = row?.publishedAt
        if let dateString = news.articles?[indexPath.row].publishedAt,
           let date = indDateFormatter.date(from: dateString){
            let formattedString = outDateFormtter.string(from: date)
            cell.timePublication.text = formattedString
        } else {
            cell.timePublication.text = "----------"
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 163
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!, filteredArticles)
    }
    
    func filterContentForSearchText(_ searchText:String ,_ category: [ArticlesData]){
        filteredArticles =  news.articles?.filter({ (article:ArticlesData) -> Bool in
            return article.title!.lowercased().contains(searchText.lowercased())
            
        })
        table_view.reloadData()
    }
    
}


extension UIImageView {
    
    func downloadImage( url: String){
        let news = ArticleManger()
        news.performRequest()
        
        DispatchQueue.main.async {
            
        }
        
    }
    
    
    
    
    
    
}
