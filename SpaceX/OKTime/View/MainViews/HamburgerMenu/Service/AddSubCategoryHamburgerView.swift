//
//  AddSubCategoryHamburgerView.swift
//  OKTime
//
//  Created by Arman Zohourian on 12/1/22.
//

import SwiftUI

struct AddSubCategoryHamburgerView: View {
    
    
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    var subCategory : [SubCategory] = [ SubCategory(name: "اصلاح مو", price: "120,000")
                                        ,SubCategory(name: "اصلاح مو", price: "120,000"),
                                        SubCategory(name: "اصلاح مو", price: "120,000")
    ]
    
    @EnvironmentObject var bussinessServiceAddCategoryViewModel : BusinessServiceAddCategoryViewModel
    @EnvironmentObject var getServiceViewModel: ServicesViewModel
    @EnvironmentObject var keyboardResponder: KeyboardResponder
    
    
    
    var colors: ConstantColors
    
    @State var selectedSubCategory: SubCategory = SubCategory(name: "", price: "")
    @Binding var category: Category
    @State var subCategoryName: String = ""
    @State var priceName: String = ""
    @State var showSheet: Bool = false
    @Binding var isPresented: Bool
    @State private var image = UIImage()
    @State var isShowingEditSubCategory: Bool = false
    
    
    var body: some View {
        
        ActionSheetView {
            ScrollView {
                VStack(alignment: .trailing) {
                    
                    VStack {


                        CustomTextField(colors: colors, labelName: "subcategory_name_label".localized(language), placeholder: "subcategory_name_placeholder".localized(language), text: $subCategoryName, isPassword: false)
                            
                        CustomTextField(colors: colors, labelName: "subcategory_price_label".localized(language), placeholder: "", text: $priceName, isPassword: false)
                            .keyboardType(.numberPad)
                        
                        VStack(alignment: .trailing, spacing: 10) {
                            Text("subcategory_image_label".localized(language))
                                .foregroundColor(Color(red: 14 / 255, green: 31 / 255, blue: 80 / 255))
                                .font(.system(size: 15, weight: .semibold, design: .default))
                                .padding()
                                .offset(x: 10)
                            
                            
                            
                            HStack {
                                Button {
                                    showSheet.toggle()
                                } label: {
                                    Text("subcategory_image_button_text".localized(language))
                                        .font(.system(size: 12))
                                        .foregroundColor(colors.whiteColor)
                                        .frame(width: 80 ,height: 30)
                                        .background(colors.blueColor)
                                        .cornerRadius(5)
                                        .padding()
                                }
                                
                                
                                Spacer()
                                
                                //Image
                                Image(uiImage: self.image)
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .clipShape(Circle())
                                    .background(Color.clear)
                                    .padding()
                            
                            }
                            .frame(width: UIScreen.screenWidth - 10, height: 40)
                            .border(colors.lightGrayColor)
                            
                                
                        }

                        Button {
                            //1 - Send request to sever
                            //2 - add the Sub Category to the array
                            let subCategory = SubCategory(name: subCategoryName, price: priceName)
                            
                            hideKeyboard()
                            
                            
                            
                            getServiceViewModel.uploadSubCategory(with: image, params: ["name": subCategoryName,
                                                                                                         "activate": "true",
                                                                                                         "cost" : priceName,
                                                                                        "parent_id" : String(category.serverId)], category: category, subCategory: subCategory, completionHandler: { isSuccess in
                                
                                if isSuccess {
                                    Task {
                                        await getServiceViewModel.getServices()
                                    }
                                }
                                
                            })
            

                            
                        } label: {
                            GreenFunctionButton(buttonText: "subcategory_button_text".localized(language), isAnimated: $getServiceViewModel.isRequesting)
                                .frame(width: UIScreen.screenWidth - 30 , height: 45)
                                
                        }
                        .padding()
                    }
                    .padding(.top)
                    
//                    List  {
//
//                        if let existingIndex = getServiceViewModel.categories.firstIndex(where: {
//                            $0.serverId == category.serverId
//                        }) {
//                            if let subCategories = getServiceViewModel.categories[existingIndex].subCategory {
//                                ForEach(subCategories) { subCategory in
//                                    CustomListView(colors: colors, description: subCategory.price, isSubCategory: true, categoryName: subCategory.name, image: nil, isShowingSubCategory: .constant(true))
//                                        .frame(width: UIScreen.screenWidth - 10, height: 40)
//                                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
//
//                                            Button {
//                                                //Delete from list
//                                            } label: {
//                                                VStack {
//                                                    Image("trash")
//                                                    Text("delete".localized(language))
//                                                }
//                                            }
//                                            .tint(.red)
//
//                                            Button {
//                                                //Edit from list , bring up sheet
//                                                editSubCategory(subCategory: subCategory)
//                                            } label: {
//                                                VStack {
//                                                    Image("edit")
//                                                        .foregroundColor(colors.whiteColor)
//                                                    Text("edit".localized(language))
//                                                }
//                                            }
//                                            .tint(.orange)
//
//
//
//                                        }
//                                }
//
//                            }
//                        }
//
//
//                        //Getting the category clicked by the user
//                        //matching it with  view Model
//                        }
//                    .listStyle(.plain)
//                    .background(Color.white)
//                    .frame(width: UIScreen.screenWidth - 10, height: UIScreen.screenHeight / 2)
                    
                        // Get its subcategories
                        // add it to the view

                }
//                .padding(.bottom)
//                .padding(.bottom, keyboardResponder.currentHeight)
            }

        }
        
        
        .sheet(isPresented: $showSheet) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
        }
        .sheet(isPresented: $isShowingEditSubCategory) {
            EditSubCategoryHamburgerView(colors: colors, category: $category, subCategory: $selectedSubCategory, isPresented: $isShowingEditSubCategory)
                .environmentObject(getServiceViewModel)
        }
        
    }
    
    
    private func editSubCategory(subCategory: SubCategory) {
        isShowingEditSubCategory = true
        self.selectedSubCategory = subCategory
    }
    
    
    
}



//struct AddSubCategoryHamburgerView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddSubCategoryHamburgerView()
//    }
//}
//

//struct AddSubcategoryView_Previews: PreviewProvider {
//    static var colors = ConstantColors()
//    static var previews: some View {
//        AddSubcategoryView(colors: colors)
//    }
//}

