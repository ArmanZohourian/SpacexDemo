//
//  CityView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/5/22.
//

import SwiftUI

struct CityView: View {
    
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    @EnvironmentObject var businessInfromationViewModel: BusinessInformationViewModel
    
    
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
                    .font(.custom("YekanBakhNoEn-Bold", size: 16))
                    .foregroundColor(colors.blueColor)
            }
            //Cities
            VStack(spacing: 10) {
                
            
                HStack(spacing: -18) {
                    
                    
                    
                    TextField("city_search_description".localized(language), text: $searchText)
                        .multilineTextAlignment(.trailing)
                        .padding(.trailing)
                        .frame(height: 30)
                        .onChange(of: self.searchText) { newValue in
                            Task {
                                //Search for cities when changed
                                await cityViewModel.getCities(with: newValue)
                            }
                        }
                    
                    Image("search")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .aspectRatio(contentMode: .fit)
                        .padding()
                    
                        
                }
                .overlay {
                    RoundedRectangle(cornerSize: CGSize(width: 7, height: 7))
                        .stroke(colors.grayColor, lineWidth: 0.3)
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
                            businessInfromationViewModel.choosenCity = city
                            isPresented = false
                        }
                        Divider()
                    }
                }

            }
        }
        .environment(\.layoutDirection, language == .english ? .rightToLeft : .leftToRight)
        .padding(.top, 20)
        .padding()
        .task {
            await cityViewModel.getCities(with: "")
        }
    }
}

struct CityView_Previews: PreviewProvider {
    static var constantColor: ConstantColors = ConstantColors()
    static var previews: some View {
        CityView(colors: constantColor, isPresented: .constant(true))
    }
}
