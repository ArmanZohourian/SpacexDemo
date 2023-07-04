//
//  BarberCellView.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/18/22.
//

import SwiftUI

struct BarberCellView: View {
    var body: some View {
        
        VStack {
            HStack {
                
                Image("shield-tick")
                Spacer()
                VStack(alignment: .trailing) {
                    Text("علی حسین نژاد")
                        .foregroundColor(Color(red: 14 / 255, green: 31 / 255, blue: 80 / 255))
                    Text("اصلاح مو سر اصلاح ریش شستن موی سر")
                        .foregroundColor(Color(red: 129 / 255, green: 129 / 255, blue: 129 / 255))
                        .font(.system(size: 12))
                        .opacity(0.2)
                }
                RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color.yellow)
                
      
                
                
            }
            .padding()
        }
        
    }
}

struct BarberCellView_Previews: PreviewProvider {
    static var previews: some View {
        BarberCellView()
    }
}
