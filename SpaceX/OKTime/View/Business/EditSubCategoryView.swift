//
//  EditSubCategoryView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/15/22.
//

import SwiftUI

struct EditSubCategoryView: View {
    
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
//    var subCategory : [SubCategory] = [ SubCategory(name: "اصلاح مو", price: "120,000")
//                                        ,SubCategory(name: "اصلاح مو", price: "120,000"),
//                                        SubCategory(name: "اصلاح مو", price: "120,000")
//    ]
    
    
    @EnvironmentObject var bussinessServiceAddCategoryViewModel : BusinessServiceAddCategoryViewModel
    
    @EnvironmentObject var keyboardResponder : KeyboardResponder
    
    
    var colors: ConstantColors
    
    @State var selectedSubCategory: SubCategory = SubCategory(name: "", price: "")
    
    
    @Binding var category: Category
    
    @Binding var subCategory: SubCategory
    @State var subCategoryName: String = ""
    @State var priceName: String = ""
    @State var showSheet: Bool = false
    @Binding var isPresented: Bool
    @State private var image = UIImage()
    @State var isShowingEditSubCategory: Bool = false
    
    
    var body: some View {
        
        ActionSheetView {
            ScrollView {
                VStack {
                    
                    VStack(alignment: .trailing, spacing: 0) {
                        
                        CustomTextField(colors: colors, labelName: "subcategory_name_label".localized(language), placeholder: "subcategory_name_placeholder".localized(language), text: $subCategoryName, isPassword: false)
                       
            
                        CustomTextField(colors: colors, labelName: "subcategory_price_label".localized(language), placeholder: "", text: $priceName, isPassword: false)
                            .keyboardType(.numberPad)
                        
                        VStack(alignment: .trailing) {
                            
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
                                        .font(.system(size: 14))
                                        .foregroundColor(colors.whiteColor)
                                        .frame(width: 100,height: 40)
                                        .background(colors.blueColor)
                                        .cornerRadius(5)
                                }
                                
                                Spacer()
                                
                                Text("")
                                    .foregroundColor(Color.blue)
                                
                                //Image
                                Image(uiImage: self.image)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(10)
                                    .background(Color.clear)
                                
                                

                
                                    
                                
                                
                                
                            }
                            .border(colors.lightGrayColor)
                            
                                
                        }

                        Button {
                            //1 - Send request to sever
                            //2 - add the Sub Category to the array
                            
                            bussinessServiceAddCategoryViewModel.editSubCategory(with: image,name: subCategoryName, price: priceName ,category: category, subCategory: subCategory, completionHanlder: { isDone in
                                if isDone {
                                    Task {
                                        await bussinessServiceAddCategoryViewModel.getServices()
                                    }
                                    isPresented.toggle()
                                }
                            })
                            
                            
//                            bussinessServiceAddCategoryViewModel.uploadSubCategory(with: image, params: ["name": subCategoryName,
//                                                                                                         "activate": "true",
//                                                                                                         "cost" : priceName,
//                                                                                                         "parent_id" : String(category.serverId)], category: category, subCategory: subCategory, completionHandler: { isDone in
//                                if isDone {
//
//                                    Task {
//                                        await bussinessServiceAddCategoryViewModel.getServices()
//                                    }
//                                    isPresented.toggle()
//
//                                }
//
//                            }
//
//                            )
                            hideKeyboard()
                            
                        } label: {
                            GreenFunctionButton(buttonText: "edit".localized(language), isAnimated: $bussinessServiceAddCategoryViewModel.isRequesting)
                                .frame(width: UIScreen.screenWidth - 30 , height: 45)
                                
                                
                        }
                        .disabled(bussinessServiceAddCategoryViewModel.isRequesting)
                        .padding(.top)
                    }
                    .padding()
//
//                    List  {
//                        //Getting the category clicked by the user
//                        //matching it with  view Model
//                        if let existingIndex = bussinessServiceAddCategoryViewModel.categories.firstIndex(where: {
//                            $0.serverId == category.serverId
//                        }) {
//                            if let subCategories = bussinessServiceAddCategoryViewModel.categories[existingIndex].subCategory {
//                                ForEach(subCategories) { subCategory in
//
//
//                                    CustomListView(colors: colors, description: subCategory.price, isSubCategory: true, categoryName: subCategory.name, image: subCategory.image, isShowingSubCategory: .constant(true))
//                                        .frame(height: 40)
//                                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
//
//                                            Button {
//                                                //Delete from list
//                                            } label: {
//                                                VStack {
//                                                    Image("trash")
//                                                        .resizable()
//                                                        .frame(width: 20, height: 20)
//
//                                                    Text("subcategory_delete_subcategory".localized(language))
//                                                }
//                                            }
//                                            .tint(.red)
//
//                                            Button {
//                                                //Edit from list , bring up sheet
//                                                editSubCategory(subCategory: subCategory)
//                                            } label: {
//                                                VStack {
//                                                    Image("edit-button")
//                                                        .resizable()
//                                                        .frame(width: 20, height: 20)
//
//                                                    Text("subcategory_edit_subcategory".localized(language))
//                                                }
//                                            }
//                                            .tint(.orange)
//
//
//
//                                        }
//                                        .listRowSeparator(.hidden)
//
//                                    Divider()
//                                        .frame(width: UIScreen.screenWidth - 10)
//
//                                }
//
//
//
//                        }
//
//
//                            }
//                        }
//
//                    .listStyle(.plain)
//                    .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight / 5)
//                    .listRowSeparator(.hidden)

                        // Get its subcategories
                        // add it to the view
                    
                    
                }
                .padding(.bottom)
            }
            
            
            
            .popup(isPresented: $bussinessServiceAddCategoryViewModel.hasError, view: {
                FloatBottomView(colors: colors.redColor, errorMessage: bussinessServiceAddCategoryViewModel.errorMessage)
            }, customize: {
                $0
                    .animation(.spring())
                    .autohideIn(3)
                    .position(.bottom)
                    .type(.floater())
            })
            
        }
        
        .onTapGesture {
            hideKeyboard()
        }
        

        .sheet(isPresented: $showSheet) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
        }
        
        .onAppear {
            self.subCategory = subCategory
            subCategoryName = subCategory.name
            priceName = subCategory.price
        }
    
    }
    
    
    private func editSubCategory(subCategory: SubCategory) {
        isShowingEditSubCategory = true
        self.selectedSubCategory = subCategory
    }
}

//struct EditSubCategoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditSubCategoryView()
//    }
//}
