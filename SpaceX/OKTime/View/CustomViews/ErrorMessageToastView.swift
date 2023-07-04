//
//  ErrorMessageToastView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/12/22.
//

import SwiftUI

struct ErrorMessageToastView: View {
    var colors: Color
    @Binding var errorText: String
    var body: some View {
        Text(errorText)
            .foregroundColor(.white)
            .padding(EdgeInsets(top: 100, leading: 32, bottom: 16, trailing: 32))
            .frame(maxWidth: .infinity)
            .background(colors)
    }
}

