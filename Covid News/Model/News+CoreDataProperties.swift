//
//  News+CoreDataProperties.swift
//  Covid News
//
//  Created by Alex Paul on 11/23/20.
//  Copyright © 2020 Alexander Paul. All rights reserved.
//
//

import Foundation
import CoreData

extension News {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<News> {
    return NSFetchRequest<News>(entityName: "News")
  }
  
  @NSManaged public var author: String?
  @NSManaged public var myDescription: String?
  @NSManaged public var publishedAt: String?
  @NSManaged public var title: String?
  @NSManaged public var urlImage: String?
  @NSManaged public var urlWebsite: String?
  
}

extension News: Identifiable {
  
}
