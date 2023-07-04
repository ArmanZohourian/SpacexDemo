//
//  HourAndMinutePickerView.swift
//  
//
//  Created by Arman Zohourian on 11/16/22.
//

import SwiftUI

struct HourAndMinutePickerView: View {
    
    @Binding var date : Date
    @Binding var isPresented: Bool

    var body: some View {
        
        VStack {
            DatePicker(
                "",
                selection: $date,
                displayedComponents: [.hourAndMinute])
                .padding()
                .datePickerStyle(.wheel)
                .overlay(alignment: .topLeading) {
                    Button {
                        
                        isPresented.toggle()
                        
                       
                    } label: {
                        Text("Done")
                    }
                    .padding()
                }
                .background(Color.white)
            
            
        }
        .shadow(radius: 3)
        .frame(width: UIScreen.screenWidth)
        .padding(.bottom)
        .transition(.move(edge: .bottom))
        .environment(\.layoutDirection, .leftToRight)
        
    }
}

struct HourAndMinutePickerView_Previews: PreviewProvider {
        static var previews: some View {
            HourAndMinutePickerView(date: .constant(Date()), isPresented: .constant(true))
        }
}
