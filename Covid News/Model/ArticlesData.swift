//
//  ArticlesData.swift
//  Covid News
//
//  Created by Alex Paul on 11/2/20.
//  Copyright © 2020 Alexander Paul. All rights reserved.
//

import Foundation

class ArticlesData: Codable {
  var author: String?
  var title: String?
  var myDescription: String?
  var publishedAt: String?
  var urlImage: String?
  var urlWebsite: String?
}


extension ArticlesData{
    var unwrappedAuthor: String{
        "\(author ?? "Unavailable")"
    }
    
    var unwrappedTitle:String {
        "\(title ?? "Unavilable")"
    }
    
    var unwrappedmyDescription:String {
        "\(myDescription ?? "Unavilable")"
    }
    
    var unwrappedPublishedAt:String {
        "\(publishedAt ?? "Unavilable")"
    }
    
    var unwrappedUrlWebsite:String {
        "\(urlWebsite ?? "Unavailable")"
    }
    
}
