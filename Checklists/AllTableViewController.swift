//
//  AllTableViewController.swift
//  Checklists
//
//  Created by yanjixian on 2021/5/31.
//

import UIKit

class AllTableViewController: UITableViewController {
    
    var alllist = Array<Checklist>()
    let cellIdentifier = "ChecklistCell"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true

        // 注册可用的 cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        // 1
        var list = Checklist(name: "Birthdays")
        alllist.append(list)

        // 2
        list = Checklist(name: "Groceries")
        alllist.append(list)

        list = Checklist(name: "Cool Apps")
        alllist.append(list)

        list = Checklist(name: "To Do")
        alllist.append(list)
        
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return alllist.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        // Configure the cell...

        cell.textLabel?.text = alllist[indexPath.row].name
        cell.accessoryType = .detailDisclosureButton
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let checklist = alllist[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
 
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let target = segue.destination as! ChecklistTableViewController
            target.checklist = sender as? Checklist
        }
    }

}
