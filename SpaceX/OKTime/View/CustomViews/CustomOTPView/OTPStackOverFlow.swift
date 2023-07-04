//
//  OTPStackOverFlow.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/12/22.
//

import SwiftUI

struct OTPSackOverFlow: View {
    
      @StateObject var viewModel = STViewModel()
      @State var isFocused = false
      
      let textBoxWidth = UIScreen.main.bounds.width / 8
      let textBoxHeight = UIScreen.main.bounds.width / 8
      let spaceBetweenBoxes: CGFloat = 10
      let paddingOfBox: CGFloat = 1
      var textFieldOriginalWidth: CGFloat {
          (textBoxWidth*6)+(spaceBetweenBoxes*3)+((paddingOfBox*2)*3)
      }
      
      var body: some View {
              
              VStack {
                  
                  ZStack {
                      
                      HStack (spacing: spaceBetweenBoxes){
                          
                          otpText(text: viewModel.otp1)
                          otpText(text: viewModel.otp2)
                          otpText(text: viewModel.otp3)
                          otpText(text: viewModel.otp4)
                      }
                      
                      
                      TextField("", text: $viewModel.otpField)
                      .frame(width: isFocused ? 0 : textFieldOriginalWidth, height: textBoxHeight)
                      .disabled(viewModel.isTextFieldDisabled)
                      .textContentType(.oneTimeCode)
                      .foregroundColor(.clear)
                      .accentColor(.clear)
                      .background(Color.clear)
                      .keyboardType(.numberPad)
                  }
          }
      }
      
      private func otpText(text: String) -> some View {
          
          return ZStack {
              Image("OTPRectangle")
              Text(text)
                  .font(.title)
                  .frame(width: textBoxWidth, height: textBoxHeight)
                  .background(VStack{
                   })
              .padding(paddingOfBox)
          }
      }
}

struct OTPStackOverFlow_Previews: PreviewProvider {
    static var previews: some View {
        OTPSackOverFlow()
    }
}
