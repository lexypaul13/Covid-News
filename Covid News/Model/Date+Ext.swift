//
//  Date+Ext.swift
//  Covid News
//
//  Created by Alex Paul on 12/30/20.
//  Copyright © 2020 Alexander Paul. All rights reserved.
//

import Foundation
extension Date{
    
    func convertToMonthYearFormat()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: self)
    }
}
