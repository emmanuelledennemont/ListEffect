//
//  ContentView.swift
//  ListEffect
//
//  Created by Emmanuelle  Dennemont on 07/07/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var fruits = [
        "🍎 Pomme",
        "🍌 Banane",
        "🍒 Cerise",
        "🍇 Raisin",
        "🍓 Fraise",
        "🍉 Pastèque",
        "🍍 Ananas",
        "🥭 Mangue",
        "🍑 Pêche",
        "🍊 Orange"
    ]

    @State private var showingAddFruit = false

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(fruits, id: \.self) { fruit in
                            CardView(fruit: fruit, onDelete: {
                                if let index = fruits.firstIndex(of: fruit) {
                                    withAnimation {
                                        fruits.remove(at: index)
                                    }
                                }
                            })
                            .transition(.asymmetric(insertion: .scale(scale: 0.1, anchor: .center), removal: .opacity))
                            .padding(.vertical, 4)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Liste de fruits")
            .navigationBarItems(
                trailing: Button(action: {
                    showingAddFruit = true
                }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $showingAddFruit) {
                AddFruitView(fruits: $fruits)
            }
        }
    }
}

struct CardView: View {
    let fruit: String
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(fruit)
                    .font(.system(size: 24))
                    .padding()
                
                Spacer()
                
                Button(action: onDelete) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                        .padding(.trailing, 10)
                }
            }
            .padding(.vertical, 8)
   
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 2) // Ajout d'une ombre légère en bas
        )
        .padding(.horizontal)
    }
}

struct AddFruitView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var fruits: [String]
    @State private var newFruit = ""
    @State private var selectedEmoji = "🍎"
    
    let emojis = ["🍎", "🍌", "🍒", "🍇", "🍓", "🍉", "🍍", "🥭", "🍑", "🍊"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Emoji")) {
                    Picker("Emoji", selection: $selectedEmoji) {
                        ForEach(emojis, id: \.self) { emoji in
                            Text(emoji).tag(emoji)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Nom du fruit")) {
                    TextField("Nom du fruit", text: $newFruit)
                }
            }
            .navigationBarTitle("Ajouter un fruit", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Annuler") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Ajouter") {
                    if !newFruit.isEmpty {
                        withAnimation {
                            fruits.append("\(selectedEmoji) \(newFruit)")
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            )
        }
    }
}


#Preview {
    ContentView()
}
