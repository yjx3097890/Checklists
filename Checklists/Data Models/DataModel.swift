//
//  File.swift
//  Checklists
//
//  Created by yan jixian on 2021/6/6.
//

import Foundation

class DataModel {
    var list: [Checklist] = []
    var indexOfSelectedChecklist: Int {
        get {
            UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
        }
    }
    
    init () {
        load()
        registerDefaults()
        handleFirstTime()
    }
    
    
    func save() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(list)
            try data.write(to: dataFilePath(), options: .atomic)
        } catch {
            print("\(error.localizedDescription)")
        }
    }
    
    func load() {
        if let data = try? Data(contentsOf: dataFilePath()) {
            let decoder = PropertyListDecoder()
            do {
                list = try decoder.decode([Checklist].self, from: data)
                sortChecklist()
            } catch  {
                print("\(error.localizedDescription)")
            }
        }
        
    }
    
    func sortChecklist() {
        list.sort { l1, l2 in
            l1.name.localizedStandardCompare(l2.name) == .orderedAscending
        }
    }
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }

    func registerDefaults() {
        let dict: Dictionary<String, Any> = [
            "ChecklistIndex": -1,
            "FirstTime": true
        ]
        UserDefaults.standard.register(defaults: dict)
        
    }
    
    func handleFirstTime() {
        let first = UserDefaults.standard.bool(forKey: "FirstTime")
        if first {
            let checklist = Checklist(name: "List")
            list.append(checklist)
            indexOfSelectedChecklist = 0
            UserDefaults.standard.set(false, forKey: "FirstTime")
            
        }
    }
    
}


