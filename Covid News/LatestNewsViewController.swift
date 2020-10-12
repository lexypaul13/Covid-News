//
//  LatestNewsViewController.swift
//  Covid News
//
//  Created by Alex Paul on 8/22/20.
//  Copyright © 2020 Alexander Paul. All rights reserved.
//

import UIKit

class LatestNewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UISearchResultsUpdating  {
    
    let urlRequest = "http://newsapi.org/v2/everything?q=coronavirus&sortBy=popularity&apiKey=d32071cd286c4f6b9c689527fc195b03&pageSize=50&page=2" //Website API
    var urlSelected = ""
    
    var articles: [Articles]? = [] // holds array of model object
    var filteredArticles:[Articles]! = [] //holds searched articles
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
        table_view.dataSource = self
        table_view.cellLayoutMarginsFollowReadableWidth = true
        navigationController?.navigationBar.prefersLargeTitles = true
        retriveData()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search News"
        navigationItem.searchController = searchController
        definesPresentationContext = true

 
    }
    
    func retriveData(  ){
        guard let aritcleUrl = URL(string: urlRequest) else { //send a request to the server
            return
        }
        let request = URLRequest(url: aritcleUrl)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in //collects content from website
            if  error != nil { // checks if content is available
                print(error ?? 0)
                return
            }
            if let data = data { // converts data to an array of Article objects
                self.articles = self.parseData(data: data)
            }
            
            
        })
        
        task.resume()
        return
    }
    
    
    func parseData(data:Data)-> [Articles]   {
        var articles: [Articles]? = [] // holds parsed data
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            
            let jsonArticles = jsonResult?["articles"] as? [AnyObject] ?? [] // gets first head of json file and converts it to dictionary
            
            for jsonArticle in jsonArticles{ // captures data and stores it in the model object
                let article = Articles()
                article.author = jsonArticle["author"] as? String
                article.title = jsonArticle["description"] as? String
                article.publishedAt = jsonArticle["publishedAt"] as? String
                article.urlImage = jsonArticle["urlToImage"] as? String
                article.urlWebsite = jsonArticle["url"] as? String
                articles?.append(article) //put article data in the array
            }
            
            print(jsonArticles)
            
            DispatchQueue.main.async {
                
                if(articles!.count > 0)
                {
                    self.table_view.reloadData()
                }
            }
            
        } catch {
            print("Nothing my guy\(error)")
        }
        
        return articles ??  [] // returns an array of articles
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 163
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //determines what data source should be used when user types
      
        if isFiltering{
            return filteredArticles?.count ?? 0
    }
        return articles?.count ?? 0

    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! NewsTableViewCell
        var news: Articles
        var articlesToUse = articles
       
        if isFiltering{
            articlesToUse = articles
            
        }
        news = articles![indexPath.row]
        cell.authorName.text = articlesToUse?[indexPath.row].author
        cell.headLine.text = articlesToUse?[indexPath.row].title
        cell.newsImage.downloadImage(from:(articlesToUse?[indexPath.row].urlImage ?? "nill"))
        cell.timePublication.text = news.publishedAt
        
        if let dateString = articlesToUse?[indexPath.row].publishedAt,
        let date = indDateFormatter.date(from: dateString){
                   let formattedString = outDateFormtter.string(from: date)
                   cell.timePublication.text = formattedString
               } else {
                   cell.timePublication.text = "----------"
               }
        
               return cell
           }
 
     
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "article"{
            if table_view.indexPathForSelectedRow != nil{
                let destinationController = segue.destination as! ArticleViewController
                destinationController.url = self.urlSelected
            }
        }
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.urlSelected = self.articles?[indexPath.row].urlWebsite ?? ""
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!, articles!)
    }
    
    
    
    func filterContentForSearchText(_ searchText:String ,_ category: [Articles]){
        filteredArticles =  articles?.filter({ (article:Articles) -> Bool in
            return article.title!.lowercased().contains(searchText.lowercased())

        })
        table_view.reloadData()
    }
    
    
    
    
    @IBAction func shareButton(_ sender: UIButton) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.table_view)
        if let indexPath = self.table_view.indexPathForRow(at:buttonPosition) {
            let newRelease = articles?[indexPath.row].urlWebsite
            let activityVC = UIActivityViewController(activityItems:[newRelease ?? 0], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC,animated: true, completion: nil)

        }
       

    }
    
     
        
    }
    

extension UIImageView {
    
    func downloadImage(from url: String){
        
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
            
            if error != nil {
                print(error ?? 0)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
                
            }
        }
        task.resume()
    }
    
    
    
}



    
  

