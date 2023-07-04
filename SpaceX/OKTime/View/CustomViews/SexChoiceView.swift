//
//  SexChoiceView.swift
//  OKTime
//
//  Created by ok-ex on 10/10/22.
//

import SwiftUI

struct SexChoiceView: View {
    
    var genderDic : [Int: String] = [1 : "Male" , 2: "Female"]
    @State var isMale = true
    @State var gender : String = ""
    var body: some View {
        VStack(alignment: .trailing, spacing: 15) {
            
            Text("جنسیت")
                .foregroundColor(Color(red: 14 / 255, green: 31 / 255, blue: 80 / 255))
                .font(.system(size: 15, weight: .semibold, design: .default))
            
            HStack(spacing: 40) {
                Button {
                    //Change the dic key to male
                    gender = genderDic[1]!
                    print(gender)
                    self.isMale.toggle()
                } label: {
                    //Male
                    HStack {
                        
                        Image("MaleLabel")
                        
                        ZStack {
                            Image("Square")
                            if isMale {
                                Image("Enable")
                            }
                           
                            
                        }
                        
                    }
                }
                	
                Button {
                    //Change the dic key to female
                    gender = genderDic[2]!
                    self.isMale.toggle()
                } label: {
                    //Female
                    HStack {
                        
                        Image("FemaleLabel")
                        
                        ZStack {
                            Image("Square")
                            if !isMale {
                                Image("Enable")
                            }
                           
                            
                        }
                        
                    }
                    
                }


            }
            
        }
    }
}


struct SexChoiceView_Previews: PreviewProvider {
    static var previews: some View {
        SexChoiceView()
    }
}
