//
//  CityHamburgerView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/22/22.
//

import SwiftUI

struct CityHamburgerView: View {
    
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    @EnvironmentObject var updateBusinessInfoViewModel: UpdateBusinessInfoViewModel
    @StateObject var cityViewModel = CityViewModel()
    var colors: ConstantColors
    @Binding var isPresented: Bool
    
     var cities : [City] = [
        City(id: 1, cityName: "Mashhad", cityNameFa: "مشهد", provinceName: "Khorasan Razavi", provinceNameFa: "خراسان رضوی") ,
        City(id: 1, cityName: "Mashhad", cityNameFa: "مشهد", provinceName: "Khorasan Razavi", provinceNameFa: "خراسان رضوی"),
        City(id: 1, cityName: "Mashhad", cityNameFa: "مشهد", provinceName: "Khorasan Razavi", provinceNameFa: "خراسان رضوی"),
        City(id: 1, cityName: "Mashhad", cityNameFa: "مشهد", provinceName: "Khorasan Razavi", provinceNameFa: "خراسان رضوی")
    ]
    @State var searchText = "" {
        didSet {
            Task {
                await cityViewModel.getCities(with: searchText)
            }
        }
    }
    var body: some View {
        VStack {
            //Search and title Bar
            HStack {
                Image("close-circle")
                    .offset(y: -30)
                    .onTapGesture {
                        isPresented = false
                    }
                Spacer()
                Text("city_search_label".localized(language))
            }
            //Cities
            VStack(spacing: 10) {
                
            
                    
                TextField("city_search_label".localized(language), text: $searchText)
                    .multilineTextAlignment(.trailing)
                    .frame(height: 40)
                    .onChange(of: self.searchText) { newValue in
                        Task {
                            //Search for cities when changed
                            await cityViewModel.getCities(with: newValue)
                        }
                    }
                
                ScrollView {
                    ForEach(cityViewModel.cities ?? [City]()) { city in
                        //City Cell
                        HStack {
                            Image("arrow-up")
                            Spacer()
                            VStack(alignment: .trailing, spacing: 10) {
                                Text(city.cityNameFa)
                                    .foregroundColor(colors.blueColor)
                                    .font(.system(size: 15, weight: .bold, design: .default))
                                Text(city.provinceNameFa)
                                    .font(.system(size: 10, weight: .medium, design: .default))
                            }
                            Image("location")
                        }
                        .onTapGesture {
                            updateBusinessInfoViewModel.choosenCity = city
                            isPresented = false
                        }
                        Divider()
                    }
                }

            }
        }
        .task {
            await cityViewModel.getCities(with: "")
        }
        .padding(.top, 20)
        .padding()

    }
}
//
//struct CityHamburgerView_Previews: PreviewProvider {
//    static var previews: some View {
//        CityHamburgerView()
//    }
//}
