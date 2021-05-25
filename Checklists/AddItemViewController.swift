//
//  AddItemViewController.swift
//  Checklists
//
//  Created by yanjixian on 2021/5/25.
//

import UIKit

class AddItemViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
    }

    // MARK: - Actions
    @IBAction func cancel() {
      navigationController?.popViewController(animated: true)
    }
  
    @IBAction func save() {
        let item = ChecklistItem()
        item.text = "item1"
        item.checked = false
      
        navigationController?.popViewController(animated: true)
    }
   
}
