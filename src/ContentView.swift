import SwiftUI

struct ContentView: View {
    @StateObject var waterManager = WaterReminderManager()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Recordatorio de Agua")
                .font(.largeTitle)
                .padding()
            
            Button("Registrar que bebí agua") {
                waterManager.logWaterIntake()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            if let lastDrink = waterManager.lastDrinkTime {
                Text("Última vez que bebiste: \(lastDrink, formatter: dateFormatter)")
            }
        }
        .onAppear {
            waterManager.registerNotification()
        }
    }
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()
