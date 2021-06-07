//
//  AllTableViewController.swift
//  Checklists
//
//  Created by yanjixian on 2021/5/31.
//

import UIKit


class AllTableViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
   
     let cellIdentifier = "ChecklistCell"
    var dataModel: DataModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true

        // 注册可用的 cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // TODO:  xiugai
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
        
        let index = dataModel.indexOfSelectedChecklist
        if index != -1 && index < dataModel.list.count {
            let checklist = dataModel.list[index]
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        }
        
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataModel.list.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        // Configure the cell...

        cell.textLabel?.text = dataModel.list[indexPath.row].name
        cell.accessoryType = .detailDisclosureButton
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let checklist = dataModel.list[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        
        dataModel.indexOfSelectedChecklist = indexPath.row
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
//        let checklist = alllist[indexPath.row]
//        performSegue(withIdentifier: "ShowEditChecklist", sender: checklist)
        let controller = storyboard?.instantiateViewController(identifier: "ListDetailViewController") as! ListDetailViewController
        controller.delegate = self
        
        let checklist = dataModel.list[indexPath.row]
        controller.checklistToEdit = checklist
        
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      
        dataModel.list.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
   
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
        dataModel.list.append(checklist)
        tableView.insertRows(at: [IndexPath(row: dataModel.list.count - 1, section: 0)], with: .automatic)
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        if let index = dataModel.list.firstIndex(of: checklist) {
            let indexPath = IndexPath(row: index, section: 0)
            let cell = tableView.cellForRow(at: indexPath)
            cell?.textLabel?.text = checklist.name
        }
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation Controller Delegate
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
    }
    
   

}
