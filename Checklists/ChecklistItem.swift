//
//  ChecklistItem.swift
//  Checklists
//
//  Created by yanjixian on 2021/5/24.
//

import Foundation

class ChecklistItem: Equatable {
    static func == (lhs: ChecklistItem, rhs: ChecklistItem) -> Bool {
        lhs.id == rhs.id
    }
    
    var id = UUID.init()
    var text = ""
    var checked = false
    
}
