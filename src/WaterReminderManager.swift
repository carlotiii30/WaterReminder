import Foundation
import UserNotifications

class WaterReminderManager: ObservableObject {
    @Published var lastDrinkTime: Date? {
        didSet {
            UserDefaults.standard.set(lastDrinkTime, forKey: "lastDrinkTime")
        }
    }
    
    init() {
        lastDrinkTime = UserDefaults.standard.object(forKey: "lastDrinkTime") as? Date
    }
    
    func registerNotification() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                self.scheduleReminder()
            }
        }
    }
    
    func scheduleReminder() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        guard let lastDrinkTime = lastDrinkTime else { return }
        
        let timeInterval: TimeInterval = 2 * 60 * 60 // 2 horas
        let nextReminder = lastDrinkTime.addingTimeInterval(timeInterval)
        
        if nextReminder > Date() {
            let content = UNMutableNotificationContent()
            content.title = "Hora de beber agua"
            content.body = "No has registrado agua en un tiempo, recuerda hidratarte!"
            content.sound = .default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: nextReminder.timeIntervalSinceNow, repeats: false)
            let request = UNNotificationRequest(identifier: "waterReminder", content: content, trigger: trigger)
            
            center.add(request)
        }
    }
    
    func logWaterIntake() {
        lastDrinkTime = Date()
        scheduleReminder()
    }
}
