//
//  CustomListView.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/17/22.
//

import SwiftUI
import UIKit

struct CustomListView: View {
    
    var colors: ConstantColors
    var description: String?
    var isSubCategory: Bool
    var categoryName: String
    var image: String?
    
    
    @State var isOnCategory : Bool = true 
    
    
    @State var isOnSubCategory : Bool = true
    
    
    @Binding var isShowingSubCategory: Bool
    
    @EnvironmentObject var businessServiceAddCategoryViewModel : BusinessServiceAddCategoryViewModel
    
     var category: Category
//    @State var category: Category = Category(title: "")
    @State var subCategory: SubCategory = SubCategory(name: "", price: "")
    
    
    var imagePlaceholder: some View {
        
        Rectangle()
            .frame(width: 35, height: 35)
            .foregroundColor(Color.purple)
            .cornerRadius(20)
    }
    
    var body: some View {
        
            HStack {
                
                

                Toggle("", isOn: $isOnCategory)
                    .frame(width: 20, height: 20)
                    .environment(\.layoutDirection, .leftToRight)
                    .padding(.leading , 60)
                        

                Spacer()

                Text(description ?? "" + "تعداد زیر دسته بندی ها")
                    .foregroundColor(colors.grayColor)
                    .font(.system(size: 12, weight: .light, design: .default))
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 20)
                    .padding([.leading, .trailing])
                    
                
                
                Spacer()
                
                HStack(spacing: 10) {
                    Text(categoryName ?? "Some test")
                        .font(.custom("YekanBakhNoEn-SemiBold", size: 16))
                        .foregroundColor(colors.blueColor)
                        .frame(maxWidth: 60, alignment: .trailing)
                    
    //                Image("selected-Image")
                    
                    if let cellImage = image {
                        
                        AsyncImage(url: URL(string: APIConstanst.imageBaseUrl + cellImage)) { image in
                            
                            
                            image
                                .resizable()
                                .frame(width: 35, height: 35)
                                .clipShape(Circle())
                            
                            
                        } placeholder: {
                            
                            imagePlaceholder
                        }
                    }
                    else {
                    
                    imagePlaceholder
                    
                }
                    
                    
                    //MARK: List Photo
//                    if let categoryImage = image {
//                        Image(uiImage: UIImage(data: categoryImage)!)
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 35, height: 35)
//                            .clipShape(Circle())
//
//                    } else {
//                        Rectangle()
//                            .frame(width: 35, height: 35)
//                            .foregroundColor(Color.purple)
//                            .cornerRadius(20)
//                    }

                }
                .padding([.trailing , .leading])

            }
            .frame(height: 40)
            .background(colors.cellColor)
            .onChange(of: isOnCategory) { newValue in
                Task {
                    await businessServiceAddCategoryViewModel.updateCategoryStatus(with: category ,status: newValue)
                }
            }
            .onAppear {
                assingStatus(with: category)
            }

        }
    
    private func assingStatus(with category: Category) {
        if category.isActive {
            isOnCategory = true
        } else {
            isOnCategory = false
        }
    }
    
    
    
//    private func changeCategoryState(with category: Category, newState: Bool) {
//
//        //Call view model for change
//        businessServiceAddCategoryViewModel.changeCategoryState(with: category, newState: newState)
//    }
    
//    private func changeSubCategoryState(with category: Category, subCategory: SubCategory, newState: Bool) {
//
//        //Call view model for change
//        businessServiceAddCategoryViewModel.changeSubCategoryState(with: category, subCategory: subCategory, newState: newState)
//
//    }
    
}
