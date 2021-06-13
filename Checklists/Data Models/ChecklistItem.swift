//
//  ChecklistItem.swift
//  Checklists
//
//  Created by yanjixian on 2021/5/24.
//

import Foundation
import UserNotifications

class ChecklistItem: Equatable, Codable {
    static func == (lhs: ChecklistItem, rhs: ChecklistItem) -> Bool {
        lhs.id == rhs.id
    }
    
    var id = UUID.init()
    var text = ""
    var checked = false
    var itemId = 0
    var date = Date()
    var shouldNotify = false
    
    init(label text: String, checked: Bool = false, date: Date, shouldNotify: Bool = false) {
        itemId = DataModel.nextItemId()
        self.text = text
        self.checked = checked
        self.date = date
        self.shouldNotify = shouldNotify
    }
    
    deinit {
        cancleNotification()
    }
    
    func scheduleNotification() {
        cancleNotification()
        if shouldNotify && date > Date() {
            let content = UNMutableNotificationContent()
            content.body = text
            content.sound = .default
            content.title = "Reminder:"
            
            let calender = Calendar(identifier: .gregorian)
            let components = calender.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            let request = UNNotificationRequest(identifier: String(itemId), content: content, trigger: trigger)
            
            let center = UNUserNotificationCenter.current()
            center.add(request)
            
        }
    }
    
    func cancleNotification() {
        let center = UNUserNotificationCenter.current()
        center.removeDeliveredNotifications(withIdentifiers: [String(itemId)])
    }
    
}
