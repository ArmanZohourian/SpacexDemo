//
//  OptionCellView.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/18/22.
//

import SwiftUI

struct OptionCellView: View {
    
    //MARK: Assign as @Binding
    @State var isSelected : Bool = true
    @State var subCategoryName = "اصلاح موی سر"
    var body: some View {
        
        
        VStack(alignment: .trailing) {
            HStack(spacing: 10) {
                Text(subCategoryName)
                ZStack {
                    Image("tickbox")
                    Image("tick")
                        .opacity(isSelected ? 1 : 0.0)
                }
            }
        }
        .frame(width: 150, height: 40, alignment: .trailing)
        
    }
}

struct OptionCellView_Previews: PreviewProvider {
    static var previews: some View {
        OptionCellView()
    }
}
