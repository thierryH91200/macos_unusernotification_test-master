//
//  ViewController.swift
//  NotificationTest
//
//  Created by Dmitry Mikhaltchenkov on 10/10/2019.
//  Copyright © 2019 Dmitry MIkhaltchenkov. All rights reserved.
//

import Foundation
import Cocoa
import UserNotifications

class ViewController: NSViewController {
    
    private var center: UNUserNotificationCenter?
    private let handler = NotificationHandler()
    private let notifyCategoryIdentifier = "test"
    private let notificationsHelper = NotificationsHelper()
    
    @IBAction func showNotify(_ sender: Any) {
        notificationsHelper.scheduleNotification(timeInterval: 1, repeats: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.center = UNUserNotificationCenter.current()
        self.center?.delegate = self.handler
        self.initNotifications()
        notificationsHelper.requestPermission(for:  [.alert, .sound, .badge])
    }
            
    private func initNotifications() {
        guard let center = self.center else { return }
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Successful authorized!")
                // Define the custom actions.
                let byeAction = UNNotificationAction(identifier: NotificationActionsEnum.bye.rawValue, title: NSLocalizedString("Bye", comment: ""), options: UNNotificationActionOptions(rawValue: 0))
                
                let sayHelloAction = UNNotificationAction(identifier: NotificationActionsEnum.sayHello.rawValue, title: NSLocalizedString("Hello", comment: ""), options: UNNotificationActionOptions(rawValue: 0))
                
                // Define the notification type
                let testCategory = UNNotificationCategory(identifier: self.notifyCategoryIdentifier, actions: [byeAction, sayHelloAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: .customDismissAction)
                
                center.setNotificationCategories([testCategory])
            } else {
                print("Authorization denied!")
                return
            }
        }
    }
}
