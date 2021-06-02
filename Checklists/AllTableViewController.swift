//
//  AllTableViewController.swift
//  Checklists
//
//  Created by yanjixian on 2021/5/31.
//

import UIKit

class AllTableViewController: UITableViewController, ListDetailViewControllerDelegate {
   
    var alllist = Array<Checklist>()
    let cellIdentifier = "ChecklistCell"
    
    func save() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(alllist)
            try data.write(to: dataFilePath(), options: .atomic)
        } catch {
            print("\(error.localizedDescription)")
        }
    }
    
    func load() {
        if let data = try? Data(contentsOf: dataFilePath()) {
            let decoder = PropertyListDecoder()
            do {
                alllist = try decoder.decode([Checklist].self, from: data)
            } catch  {
                print("\(error.localizedDescription)")
            }
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true

        // 注册可用的 cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        //
       load()
        
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
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
//        let checklist = alllist[indexPath.row]
//        performSegue(withIdentifier: "ShowEditChecklist", sender: checklist)
        let controller = storyboard?.instantiateViewController(identifier: "ListDetailViewController") as! ListDetailViewController
        controller.delegate = self
        
        let checklist = alllist[indexPath.row]
        controller.checklistToEdit = checklist
        
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      
        alllist.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        save()
    }
    
 
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let target = segue.destination as! ChecklistTableViewController
            target.checklist = sender as? Checklist
        } else if segue.identifier == "ShowEditChecklist" {
//            let target = segue.destination as! ListDetailViewController
//            target.checklistToEdit = sender as? Checklist
//            target.delegate = self
        } else if segue.identifier == "ShowAddChecklist" {
            let target = segue.destination as! ListDetailViewController
            target.delegate = self
        }
    }
    
    // MARK: - List Detail View Controller Delegate
    func listDetailViewControllerCacel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
        alllist.append(checklist)
        tableView.insertRows(at: [IndexPath(row: alllist.count - 1, section: 0)], with: .automatic)
        navigationController?.popViewController(animated: true)
        save()
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        if let index = alllist.firstIndex(of: checklist) {
            let indexPath = IndexPath(row: index, section: 0)
            let cell = tableView.cellForRow(at: indexPath)
            cell?.textLabel?.text = checklist.name
            save()
        }
        navigationController?.popViewController(animated: true)
    }

}
