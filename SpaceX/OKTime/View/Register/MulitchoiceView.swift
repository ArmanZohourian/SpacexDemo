//
//  MulitchoiceView.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/12/22.
//

import SwiftUI

struct MulitchoiceView: View {
    
    
    var language = LocalizationService.shared.language
    
    @Binding var isUserState : Bool
    var body: some View {
        
        VStack {
            ZStack {
                Rectangle()
                    .frame(width: 221, height: 50)
                    .cornerRadius(20)
                    .foregroundColor( Color(red: 245 / 255, green: 245 / 255, blue: 245 / 255))
                HStack() {
                    Button {
                        self.isUserState = false
                    } label: {
                        ZStack {
                            if !isUserState {
                                Rectangle()
                                    .foregroundColor(Color.white)
                                    .cornerRadius(20)
                                Text("business".localized(language))
                                    .foregroundColor(Color.black)
                            } else {
                                Text("business".localized(language))
                                    .foregroundColor(Color.gray)
                            }
                        }
                        .frame(width: 101.14,height: 40)
                        
                        
                        Button (action: {
                            self.isUserState = true
                        }, label: {
                            ZStack {
                                if isUserState {
                                    Rectangle()
                                        .foregroundColor(Color.white)
                                        .cornerRadius(20)
                                    Text("user".localized(language))
                                        .foregroundColor(Color.black)
                                } else {
                                    Text("user".localized(language))
                                        .foregroundColor(Color.gray)
                                }
                            }
                            
                        })
                        .disabled(true)
                        
                        .frame(width: 101.14,height: 40)
                        
                    }
                    
                }
                
            }
            
        }
    }
    

}
