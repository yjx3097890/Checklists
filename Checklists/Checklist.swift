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
    
    init(name: String) {
        self.name = name
        super.init()
    }
    
}
