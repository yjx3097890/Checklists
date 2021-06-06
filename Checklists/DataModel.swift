//
//  File.swift
//  Checklists
//
//  Created by yan jixian on 2021/6/6.
//

import Foundation

class DataModel {
    var list: [Checklist] = []
    
    init () {
        load()
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
            } catch  {
                print("\(error.localizedDescription)")
            }
        }
        
    }
}

func documentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

func dataFilePath() -> URL {
    return documentsDirectory().appendingPathComponent("Checklists.plist")
}
