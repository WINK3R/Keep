import SwiftUI

struct ReminderCell: View {
    var reminder: Reminder

    @State private var timeRemaining: String = ""

    var body: some View {
        HStack {
            HStack {
                Text(reminder.emoji)
                    .font(.system(size: 35)).padding(.horizontal, 5).scaleEffect(CGSize(width: 1.2, height: 1.2))
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(reminder.title.uppercased())
                        .font(.system(size: 25)).fontWeight(.heavy).lineSpacing(8).foregroundStyle(.white)
                    Text(reminder.date.formatted())
                        .font(.system(size: 12))
                        .foregroundColor(Color("DateTextColor"))
                }
            }.padding(10)
            Spacer()
            VStack(alignment: .leading, spacing: 0) {
                Text(timeRemaining)
                    .font(.system(size: 20)).fontWeight(.regular).lineSpacing(8).foregroundStyle(.white)
            }.frame(maxWidth: 120, maxHeight: .infinity).background(Color("BackgroundCellColor2"))
        }
        .frame(maxWidth: .infinity,maxHeight: 70, alignment: .leading)
        .background(Color("BackgroundCellColor"))
        .cornerRadius(15)
        .shadow(radius: 5)
        .onAppear {
            updateTimer()
        }
    }
    

    private func updateTimer() {
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            // Mise à jour de la propriété timeRemaining toutes les secondes
            updateTimeRemaining()
        }

        // Ajouter le timer au mode d'exécution pour que la vue puisse être actualisée
        RunLoop.current.add(timer, forMode: .common)
    }

    private func updateTimeRemaining() {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date(), to: reminder.date)

        if let year = components.year, year > 0 {
            timeRemaining = "\(year)y \(components.month ?? 0)m"
        } else if let month = components.month, month > 0 {
            timeRemaining = "\(month)m \(components.day ?? 0)d"
        } else if let day = components.day, day > 0 {
            timeRemaining = "\(day)d \(components.hour ?? 0)h"
        } else if let hour = components.hour, hour > 0 {
            timeRemaining = "\(hour)h \(components.minute ?? 0)m"
        } else if let minute = components.minute, minute > 0 {
            timeRemaining = "\(minute)m \(components.second ?? 0)s"
        } else {
            timeRemaining = "\(components.second ?? 0)s"
        }
    }
}



struct ReminderCell_Previews: PreviewProvider {
    static var previews: some View {
        ReminderCell(reminder: Reminder(title: "Meeting", date: Date().addingTimeInterval(322600), emoji: "⏰"))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

extension Date {
    func formatted() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter.string(from: self)
    }
}
