//
//  String+Ext.swift
//  Covid News
//
//  Created by Alex Paul on 12/30/20.
//  Copyright © 2020 Alexander Paul. All rights reserved.
//

import Foundation

extension String{
func convertToDate() -> Date?{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    return dateFormatter.date(from: self)
}
    
    func convertToDisplayFormat()->String{
        guard let date = self.convertToDate()  else { return "N/A"}
        return date.convertToMonthYearFormat()
        }
    }
    
    
    
    

