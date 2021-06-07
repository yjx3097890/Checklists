//
//  ChecklistTableViewController.swift
//  Checklists
//
//  Created by yanjixian on 2021/5/19.
//

import UIKit

class ChecklistTableViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
   
    var checklist: Checklist!
    
    
    func configureCheckmark(for cell: UITableViewCell,with item: ChecklistItem) {
        
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked {
            label.text = "√"
      } else {
        label.text = ""
      }
    }
    
    func configureText(
      for cell: UITableViewCell,
      with item: ChecklistItem
    ) {
      let label = cell.viewWithTag(1000) as! UILabel
      label.text = item.text
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // navigationController?.navigationBar.prefersLargeTitles = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Disable large titles for this view controller
        navigationItem.largeTitleDisplayMode = .never
        title = checklist.name

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return checklist.items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let item = checklist.items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
         return cell
    }
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            
            let item = checklist.items[indexPath.row]
            item.checked.toggle()
           
            configureCheckmark(for: cell, with: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    // Override to support conditional editing of the table view.
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            checklist.items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
         } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "AddItem" {
            (segue.destination as? ItemDetailViewController)?.delegate = self
        } else if segue.identifier == "EditItem" {
            let addController = segue.destination as? ItemDetailViewController
            addController?.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                addController?.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    
    
    // MARK: - Actions

    
    // MARK: - addItem delegate
    func itemDetailViewController(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
      
        checklist.items.append(item)
        let indexPath = IndexPath(row: checklist.items.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
 
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        
        if let index = checklist.items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
         }
        
        navigationController?.popViewController(animated: true)
    }

}
