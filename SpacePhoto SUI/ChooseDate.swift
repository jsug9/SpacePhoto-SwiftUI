//
//  ChooseDate.swift
//  SpacePhoto SUI
//
//  Created by Augusto Galindo Alí on 23/02/21.
//

import SwiftUI

struct ChooseDate: View {
    @State var date = Date()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("Pick a Date").font(.title)
                    Spacer().frame(height: 40)
                    DatePicker("Date", selection: $date, in: ...Date(), displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                    Spacer().frame(height: 10)
                    NavigationLink(
                        destination: PhotoInfoDetail(date: date),
                        label: {
                            Text("See Details")
                        })
                }
                .padding()
            }
            .navigationBarTitle("Space Photo")
        }
    }
}

struct ChooseDate_Previews: PreviewProvider {
    static var previews: some View {
        ChooseDate()
    }
}
