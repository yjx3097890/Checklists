//
//  Checklist.swift
//  Checklists
//
//  Created by yan jixian on 2021/5/31.
//

import UIKit

class Checklist: NSObject, Codable {

    var name: String = ""
    var items: Array<ChecklistItem> = []
    var iconName = "No Icon"
    
    
    init(name: String, iconName: String = "No Icon") {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
//    func countUncheckedItems() -> Int {
//        var count = 0
//        for todo in items where todo.checked == false {
//            count += 1
//        }
//        return count
//    }
    
    func countUncheckedItems() -> Int {
        items.reduce(0) { current, item in
            current + (item.checked ? 0 : 1)
        }
    }
}
