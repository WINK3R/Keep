//
//  AddModal.swift
//  Keep
//
//  Created by Lucas Delanier on 18/11/2023.
//

import SwiftUI

struct AddModal: View {
    @Binding var isModalPresented: Bool
    @State private var selectedDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var isToggled = false
    @State private var isToggledAlert = false
    @State private var text = ""
    @State private var title = "Nouveau Reminder"
    
    var addReminder: (Reminder) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: {
                    // Fermer la modal
                    isModalPresented.toggle()
                }) {
                    Text("Annuler")
                        .foregroundColor(Color("BlueAccentColor"))
                }
                Spacer()
            }
            ScrollView(showsIndicators: false){
                VStack(alignment: .leading){
                    Rectangle().frame(height: 40).foregroundColor(.clear)
                    if(text.isEmpty){
                        EmojiTextField(text: $text, placeholder: "☻ Ajouter un émoji").preferredColorScheme(.light)

                    }
                    else{
                        Text(text).font(.system(size: 60)).fontWeight(.bold).padding(.bottom,-5).padding(.top,-45).onTapGesture {
                            text = ""
                        }


                    }

                    TextField("",text: $title)
                        .font(.system(size: 33))
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        .padding(.top, -10)
                }
                VStack(alignment: .leading) {
                    HStack {
                        Text("🗓️")
                            .font(.system(size: 35)).padding([.leading,.bottom,.top], 8)
                        VStack(alignment: .leading) {
                            Text("Date")
                                .font(.headline).fontWeight(.regular)
                            Text("\(selectedDate, formatter: dateFormatter)").font(.system(size: 10)).foregroundStyle(Color("BlueAccentColor"))
                        }
                        .padding(0)
                    }
                    .padding(0)
                    
                    // Ajouter un espace négatif ici pour réduire l'espacement
                    VStack(alignment: .leading) {
                        DatePicker("Sélectionnez une date", selection: $selectedDate, in: Date()..., displayedComponents: .date).colorScheme(.light)
                            .accentColor(.red)
                            .scaleEffect(0.9)
                            .datePickerStyle(GraphicalDatePickerStyle())
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color.gray.opacity(0.3)).padding(.leading, 20)
                        HStack {
                            Text("⏰")
                                .font(.system(size: 35)).padding([.leading,.bottom,.top], 8)
                            VStack(alignment: .leading) {
                                Text("Heure").foregroundColor(.black)
                                    .font(.headline).fontWeight(.regular)
                                Text("\(selectedDate, formatter: timeFormatter)").font(.system(size: 10)).foregroundStyle(Color("BlueAccentColor"))
                            }
                            .padding(0)
                            Spacer()
                            Toggle("", isOn: $isToggled)
                                .toggleStyle(SwitchToggleStyle(tint: Color.blue)) // Set tint color as needed
                                .padding().onTapGesture{
                                    withAnimation(.easeInOut(duration: 0.2)){
                                        isToggled.toggle()
                                        selectedDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: selectedDate) ?? selectedDate
                                    }
                                }
                            
                        }
                        .padding(0)
                        if isToggled {
                            
                            DatePicker(
                                "Sélectionnez l'heure",
                                selection: $selectedDate,
                                displayedComponents: [ .hourAndMinute]
                            ).padding().padding(.top,-20).preferredColorScheme(.light)
                        }
                    }
                    .padding(.top, -35) // Ajouter un espace négatif
                    
                }
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(15)
                VStack{
                    HStack {
                        Text("🛎️")
                            .font(.system(size: 35)).padding([.leading,.bottom,.top], 8)
                        VStack(alignment: .leading) {
                            Text("Notifications")
                                .font(.headline).fontWeight(.regular).foregroundStyle(.black)
                        }
                        .padding(0)
                        Spacer()
                        Toggle("", isOn: $isToggledAlert)
                            .toggleStyle(SwitchToggleStyle(tint: Color.blue)) // Set tint color as needed
                            .padding()
                        
                    }
                    .padding(0)
                }.frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(15)
                Button(action: {
                    if(validValue(titre: title, emoji: text, date: selectedDate)){
                        //#TODO
                        addReminder(Reminder(title: title, date: selectedDate, emoji: text))
                                            isModalPresented.toggle()
                    }
                }) {
                    Text("Ajouter")
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical,20)
                            .background(Color.black)
                            
                            .cornerRadius(15)
                }
                }
        }
        .frame(maxWidth: .infinity)
        .padding([.leading,.top,.trailing])
        .background(Color("ModalBackground"))
    }
    
    func validValue(titre : String, emoji: String, date: Date) -> Bool {
        return titre != "" && emoji != "" && titre != "Nouveau Reminder"
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    private var timeFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter
        }
}

class UIEmojiTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setEmoji() {
        _ = self.textInputMode
    }
    
    override var textInputContextIdentifier: String? {
           return ""
    }
    
    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                self.keyboardType = .default // do not remove this
                return mode
            }
        }
        return nil
    }
}

struct EmojiTextField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String = ""
    
    func makeUIView(context: Context) -> UIEmojiTextField {
        let emojiTextField = UIEmojiTextField()
        emojiTextField.placeholder = placeholder
        emojiTextField.text = text
        emojiTextField.delegate = context.coordinator
        return emojiTextField
    }
    
    func updateUIView(_ uiView: UIEmojiTextField, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: EmojiTextField
        
        init(parent: EmojiTextField) {
            self.parent = parent
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            DispatchQueue.main.async { [weak self] in
                self?.parent.text = textField.text ?? ""
            }
        }
    }
}

struct EmojiContentView: View {
    
    @State private var text: String = ""
    
    var body: some View {
        EmojiTextField(text: $text, placeholder: "Enter emoji")
    }
}

