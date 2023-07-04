//
//  UserRegisterView.swift
//  OKTime
//
//  Created by ok-ex on 10/10/22.
//

import SwiftUI

struct UserRegisterView: View {
    var colors: ConstantColors
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var sex: String
    var body: some View {
        
        VStack(alignment: .trailing,spacing: 20) {
            
            CustomTextField(colors: colors, labelName: "نام", placeholder: "به عنوان مثال علی", text: $firstName)
            CustomTextField(colors: colors, labelName: "نام خانوادگی", placeholder: "به عنوان مثال حسین زاده", text: $lastName)
            SexChoiceView()
        }
    }
}


