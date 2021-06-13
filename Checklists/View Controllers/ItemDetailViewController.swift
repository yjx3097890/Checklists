//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by yanjixian on 2021/5/25.
//

import UIKit


protocol ItemDetailViewControllerDelegate: AnyObject {
    func itemDetailViewController(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    weak var delegate: ItemDetailViewControllerDelegate?
    
    var itemToEdit: ChecklistItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            shouldRemindSwitch.isOn = item.shouldNotify
            dueDatePicker.date = item.date
            doneBtn.isEnabled = true
        } else {
            dueDatePicker.date = Date(timeIntervalSinceNow: 600)
        }
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
        delegate?.itemDetailViewController(self)
    }
  
    @IBAction func save() {
      
        if let itemToEdit = itemToEdit {
            itemToEdit.text = textField.text!
            itemToEdit.shouldNotify = shouldRemindSwitch.isOn
            itemToEdit.date = dueDatePicker.date
            itemToEdit.scheduleNotification()
            delegate?.itemDetailViewController(self, didFinishEditing: itemToEdit)
        } else {
            let item = ChecklistItem(label: textField.text!, date: dueDatePicker.date, shouldNotify: shouldRemindSwitch.isOn)
            item.scheduleNotification()
            delegate?.itemDetailViewController(self, didFinishAdding: item)
        }
    }
    
    @IBAction func shouldRemindToggle(_ switchControl: UISwitch) {
        textField.resignFirstResponder()
        if switchControl.isOn  {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound], completionHandler: {auth,_ in
                print(auth ? "permit": "deny")
            })
        }
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
