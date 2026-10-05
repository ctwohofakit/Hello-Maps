//
//  NotificationManager.swift
//  Hello-Maps
//
//  Created by Kit Sitou on 9/15/26.
//

import UserNotifications
import Foundation
import UIKit


//notification pop up design "don't forget to bring your bags! Grab your reusable bags before haeading inside,
//insdie app, pop up screen with confirmation, or forgot to use to collect matrix
//local UNUsernotificaiton push notificaiton
//authorization status: -notdeterminded, granted, declined
//local notification vs remote notification(from server)

//1. setUNUserNotifiationCenter-ask user premission
//2. set center = setUNUserNotificaitonCenter.current
//3. call requestAurthoriztion, check authorization status, remind user if they reject they need to grant permission from setting for the app reminder to work
//4. UI--UN mutablt notification content object, content.title , content.body
//5. trigger--using Calendar.current.dateComponents()
//6. UNCalendarNotificationTrigger
// https://www.youtube.com/watch?v=JuqQUP0pnZY
@MainActor  //ui state change happen on mainactor, so if we have state hange for ui need mainactor
final class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate{
    static let shared = NotificationManager()
    @Published var showBagConfirmation = false
    
    override private init(){
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    //requset user premission
    func requestPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, error in
            if let error = error {
                print ("permission error \(error.localizedDescription)")
                return
            }
            
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }
    
    //in app notification will still on
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void){
        completionHandler([.banner, .sound, .badge])
    }
    
    func scheduleNotification(){
        let content = UNMutableNotificationContent()
        content.title = "Bag Reminder!!!"
        content.body = "Don't forget to bring your reusable bag before heading inside."
        content.sound = .default
        showBagConfirmation = true 
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "reusableBagReminder", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Local notification scheduled!")
            }
        }
    }
    
    //user tap on notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        print("user tapped notification")
            showBagConfirmation = true
            print("showBagConfirmation state =\(showBagConfirmation)")
        }
    
}
