//
//  SaveView.swift
//  SingSave
//
//  Created by Leung Yin on 13/9/24.
//

import SwiftUI

struct SaveView: View {
    
    @State private var showAddSheet = false
    
    @Binding var saveLogs_Value: [Double]
    @Binding var saveLogs_Date: [Date]
    @Binding var saveLogs_total: Double
    @Binding var saveGoals: Double
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .frame(width: 350, height: 150)
                        .foregroundStyle(.gray)
                        .opacity(0.7)
                        .shadow(radius: 40)
                    VStack {
                        HStack {
                            Text("Saved:\n$\(saveLogs_total, specifier: "%.2f")/$\(saveGoals, specifier: "%.2f")")
                                .bold()
                                .font(.title)
                            Spacer()
                        }
                        .padding(.horizontal, 45)
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .frame(width: 330, height: 40)
                                .foregroundStyle(.gray)
                                .opacity(0.85)
                                .shadow(radius: 40)
                            if saveLogs_total <= saveGoals {
                                RoundedRectangle(cornerRadius: 25)
                                    .frame(width: 330*(saveLogs_total/saveGoals), height: 40)
                                    .foregroundStyle(LinearGradient(
                                        colors: [.red, .purple],
                                        startPoint: .leading,
                                        endPoint: .trailing))
                                    .animation(.easeOut, value: 330*(saveLogs_total/saveGoals))
                            } else {
                                RoundedRectangle(cornerRadius: 25)
                                    .frame(width: 330, height: 40)
                                    .foregroundStyle(Gradient(colors: [.red, .purple]))
                            }
                        }
                    }
                }
                if saveLogs_Date == [] {
                    List {
                        Text("No save logs yet!")
                    }
                } else {
                    List(saveLogs_Date, id: \.self) { log in
                        VStack {
                            HStack {
                                Text("Amount: ")
                                    .bold()
                                Text("$\(saveLogs_Value[saveLogs_Date.firstIndex(of: log)!], specifier: "%.2f")")
                                Spacer()
                            }
                            HStack {
                                Text("Date: ")
                                    .bold()
                                Text("\(log.formatted(date: .complete, time: .omitted))")
                                Spacer()
                            }
                        }
                        .swipeActions {
                            Button {
                                saveLogs_total -= saveLogs_Value[saveLogs_Date.firstIndex(of: log)!]
                                saveLogs_Value.remove(at: saveLogs_Date.firstIndex(of: log)!)
                                saveLogs_Date.remove(at: saveLogs_Date.firstIndex(of: log)!)
                            } label: {
                                Image(systemName: "trash")
                                    .tint(.red)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Savings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                            .bold()
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                SaveView_Add(saveLogs_Value: $saveLogs_Value,
                             saveLogs_Date: $saveLogs_Date,
                             saveLogs_total: $saveLogs_total)
                .presentationDetents([.height(600), .large])
            }
        }
    }
}

#Preview {
    SaveView(saveLogs_Value: .constant([]),
             saveLogs_Date: .constant([]),
             saveLogs_total: .constant(100.0),
             saveGoals: .constant(200.0))
}
