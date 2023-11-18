//
//  ContentView.swift
//  Keep
//
//  Created by Lucas Delanier on 16/11/2023.
//

import SwiftUI

struct ContentView: View {
    
    private let remindersKey = "remindersKey"
    
    @State private var isModalPresented = false
    @State private var reminders = [
            Reminder(title: "Meeting", date: Date().addingTimeInterval(322600), emoji: "⏰"),
            // Ajoutez d'autres rappels au besoin
        ]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                VStack(alignment: .leading) {
                    Text("Keep.").font(.system(size: 38)).foregroundStyle(.white).fontWeight(.bold)
                    Text("Because your 🧠 is f*cked up").font(.system(size: 15)).foregroundStyle(Color("GrayTextColor")).fontWeight(.light)
                }
                Spacer()
                Button(action: {
                    isModalPresented.toggle()
                    print("Button tapped!")
                            }) {
                                Image(systemName: "plus")
                                    .font(.subheadline)
                                    .padding(10)
                                    .fontWeight(.regular)
                                    .background(Color("BackgroundCellColor2"))
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                            }
                            .sheet(isPresented: $isModalPresented) {
                                                // Contenu de la modal
                                                AddModal(isModalPresented: $isModalPresented, addReminder: addReminder)
                                            }
            }.padding(.all,15)
            ZStack{
                ScrollView{
                    VStack(alignment: .leading, spacing: 10) {
                                    ForEach(reminders) { reminder in
                                        ReminderCell(reminder: reminder, removeReminder: removeReminder)
                                            .padding(.bottom, 3).padding(.horizontal,15)
                                    }
                                }
                }

                
            }
            
        }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity).background(Color("BackgroundColor")).onAppear {
            // Charger les rappels au lancement de l'application
            loadReminders()
        }.background(.black)

    }
    
    private func saveReminders() {
            do {
                let data = try JSONEncoder().encode(reminders)
                UserDefaults.standard.set(data, forKey: remindersKey)
            } catch {
                print("Erreur lors de la sauvegarde des rappels : \(error)")
            }
        }

        private func loadReminders() {
            if let data = UserDefaults.standard.data(forKey: remindersKey) {
                do {
                    reminders = try JSONDecoder().decode([Reminder].self, from: data)
                } catch {
                    print("Erreur lors du chargement des rappels : \(error)")
                }
            }
        }
    
    func addReminder(_ reminder: Reminder) {
        
        reminders.append(reminder)
        reminders.sort(by: { $0.date < $1.date }) // Trie la liste après l'ajout
        saveReminders()
        }
    
    func removeReminder(_ id: UUID) {
        reminders = reminders.filter { $0.id != id }
        saveReminders() // Update the saved data after removing the reminder
    }
    
}

#Preview {
    ContentView()
}
