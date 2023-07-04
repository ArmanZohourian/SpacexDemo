//
//  SelectServiceView.swift
//  OKTime
//
//  Created by Arman Zohourian on 1/5/23.
//

import SwiftUI

struct SelectServiceView: View {
    
    
    
    var language = LocalizationService.shared.language
    var colors: ConstantColors
    @Binding var isPresented: Bool
    @State var searchText = ""
    
    
    @StateObject var selectServiceViewModel = SelectServiceViewModel()
    @EnvironmentObject var timeTableViewModel: TimeTableViewModel
    
    var body: some View {
        
        content
            .environment(\.layoutDirection, language == .persian ? .leftToRight : .rightToLeft)
    }
    
    
    var content: some View {
        
        
        VStack(alignment: .trailing) {
            HStack {
                Image("close-circle")
                    .padding()
                    .onTapGesture {
                        isPresented = false
                    }
                
                Spacer()
                Text("add_service".localized(language))
                    .padding()
                
            }
      
            
            SearchBarView(searchText: $searchText, addTapped: .constant(false), colors: colors)
                .onChange(of: searchText) { newValue in
                    selectServiceViewModel.searchServices(with: newValue)
                }
            
            
            if selectServiceViewModel.hasActiveService() {
                ScrollView {
                
                    ForEach(selectServiceViewModel.filteredsubCategoires) { subcategory in
                        ServiceCell(subCategory: subcategory, colors: colors, image: subcategory.image)
                            .onTapGesture {
                                timeTableViewModel.choosenService = subcategory
                                isPresented.toggle()
                            }
                            .frame(height: 70)
                        Divider()
                    }
                    
                }
            } else {
                Spacer()
                Text("No actviated services, Please activate one.")
                    .padding()
                Spacer()
            }

        }
        .onAppear {
            Task {
               await selectServiceViewModel.getServices()
            }
        }
        
    }
    
    
    
    
}
