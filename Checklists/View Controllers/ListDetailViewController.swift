//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by yanjixian on 2021/6/2.
//

import UIKit

protocol ListDetailViewControllerDelegate: AnyObject {
    func listDetailViewControllerCacel(_ controller: ListDetailViewController)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
  
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var iconImage: UIImageView!
    
    var iconName = "Folder"
    
    
    weak var delegate: ListDetailViewControllerDelegate?
    var checklistToEdit: Checklist?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let checklist = checklistToEdit {
            title = "Edit Checklist"
            textField.text = checklist.name
            doneButton.isEnabled = true
            iconName = checklist.iconName
        }
        iconImage.image = UIImage(named: iconName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath.section == 1 ? indexPath: nil
    }
    
    // MARK: - Text Field Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let newText = oldText.replacingCharacters(in: Range(range, in: oldText)!, with: string)
        doneButton.isEnabled = !newText.isEmpty
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneButton.isEnabled = false
        return true
    }
    
    // MARK: - Icon Picker Delegate
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String) {
        self.iconName = iconName
        iconImage.image = UIImage(named: iconName)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickIcon" {
            let controller = segue.destination as! IconPickerViewController
            controller.delegate = self
        }
    }
    
    // MARK: - Actions
    @IBAction func cancel() {
        delegate?.listDetailViewControllerCacel(self)
    }
    
    @IBAction func done() {
        if let checklist = checklistToEdit {
            checklist.name = textField.text!
            checklist.iconName = iconName
            delegate?.listDetailViewController(self, didFinishEditing: checklist)
        } else {
            let checklist = Checklist(name: textField.text!, iconName: iconName)
            delegate?.listDetailViewController(self, didFinishAdding: checklist)
        }
    }
    
}
