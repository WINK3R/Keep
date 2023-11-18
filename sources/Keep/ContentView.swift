//
//  ContentView.swift
//  Keep
//
//  Created by Lucas Delanier on 16/11/2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var reminders = [
            Reminder(title: "Meeting", date: Date().addingTimeInterval(322600), emoji: "⏰"),
            Reminder(title: "Call", date: Date().addingTimeInterval(3600), emoji: "📞"),
            Reminder(title: "Gym", date: Date().addingTimeInterval(7200), emoji: "💪"),
            Reminder(title: "Shopping", date: Date().addingTimeInterval(10800), emoji: "🛒"),
            Reminder(title: "Study", date: Date().addingTimeInterval(14400), emoji: "📚"),
            Reminder(title: "Dinner", date: Date().addingTimeInterval(18000), emoji: "🍽️"),
            Reminder(title: "Movie", date: Date().addingTimeInterval(21600), emoji: "🎬"),
            Reminder(title: "Exercise", date: Date().addingTimeInterval(25200), emoji: "🏋️‍♂️"),
            Reminder(title: "Read", date: Date().addingTimeInterval(28800), emoji: "📖"),
            Reminder(title: "Sleep", date: Date().addingTimeInterval(32400), emoji: "😴"),
            // Ajoutez d'autres rappels au besoin
        ]
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Keep.").font(.system(size: 38)).foregroundStyle(.white).fontWeight(.bold)
                Text("Because your 🧠 is f*cked up").font(.system(size: 15)).foregroundStyle(Color("GrayTextColor")).fontWeight(.light)
            }.padding(.all,15)
            ZStack{
                ScrollView{
                    VStack(alignment: .leading, spacing: 10) {
                                    ForEach(reminders) { reminder in
                                        ReminderCell(reminder: reminder)
                                            .padding(.bottom, 10).padding(.horizontal,15)
                                    }
                                }
                }

                
            }
            
        }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity).background(Color("BackgroundColor"))

    }
}

#Preview {
    ContentView()
}
