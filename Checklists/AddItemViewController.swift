//
//  AddItemViewController.swift
//  Checklists
//
//  Created by yanjixian on 2021/5/25.
//

import UIKit


protocol AddItemViewControllerDelegate: AnyObject {
    func addItemViewControllerDidCancel(_ controller: AddItemViewController)
    func addItemViewController(_ controller: AddItemViewController, didFinishAdding item: ChecklistItem)
}

class AddItemViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    
    weak var delegate: AddItemViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        
        return
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // MARK: - Table View Delegates
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
      return nil
    }

    

    // MARK: - Actions
    @IBAction func cancel() {
        delegate?.addItemViewControllerDidCancel(self)
    }
  
    @IBAction func save() {
        let item = ChecklistItem()
        item.text = textField.text!
        item.checked = false
      
        delegate?.addItemViewController(self, didFinishAdding: item)
    }
   
//    @IBAction func keyUp(_ sender: UITextField) {
//        if sender.text == nil || sender.text!.isEmpty {
//            doneBtn.isEnabled = false
//        } else {
//            doneBtn.isEnabled = true
//        }
//    }
    
    // MARK: - Text Field Delegates
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        // NSRange convert to Range
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        if newText.isEmpty {
            doneBtn.isEnabled = false
        } else {
            doneBtn.isEnabled = true
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
      doneBtn.isEnabled = false
      return true
    }
}
