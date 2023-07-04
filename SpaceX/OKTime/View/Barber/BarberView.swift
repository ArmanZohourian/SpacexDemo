//
//  BarberView.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/18/22.
//

import SwiftUI

struct BarberView: View {
    
    var colors: ConstantColors
    @State var isShowing = false
    var body: some View {
        
        VStack {
            
            RegisterRectangle(headtitle: "آرایشگر", subtitle: "خدمات قابل ارائه به کاربران را مشخص کنید", playgroundImage: "playground-3", colors: ConstantColors())
            Button {
                //bring pop barber pop up view
                isShowing.toggle()
            } label: {
                AddButtonView(buttonText: "افزودن آرایشگر", colors: ConstantColors())
            }
            ScrollView {
                
                
                ForEach(0..<5) { _ in
                    BarberCellView()
                }
                
            }
            .halfSheet(showSheet: $isShowing, sheetView: {
                RegisterBarberPopupView(colors: colors)
            })
            
//            .sheet(isPresented: $isShowing, content: {
//                if #available(iOS 16.0, *) {
//                    RegisterBarberPopupView()
//                        .presentationDetents([.large,.medium, .fraction(0.75)])
//                } else {
//                    // Fallback on earlier versions
//
//                }
//            })
            .padding()
            
            
            Button (action: {
                //Go to next form
                
                
                
            }, label: {
                GreenFunctionButton(buttonText: "بعدی", isAnimated: .constant(false))
            })
            .frame(width: 329, height: 60)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        
    }
}

//struct BarberView_Previews: PreviewProvider {
//    static var previews: some View {
//        BarberView()
//    }
//}
