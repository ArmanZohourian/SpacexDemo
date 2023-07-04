//
//  ServiceAddSubcategory.swift
//  OKTime
//
//  Created by Arman Zohourian on 1/5/23.
//

import SwiftUI

struct ServiceAddSubcategory: View {
    
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var colors : ConstantColors
    
    @Binding var category: Category
    
    @State var subCategory = SubCategory(name: "", price: "")
    
    var language = LocalizationService.shared.language
    
    @State var isShowingSubCategory = false
    
    @State var isEditingSubCategory = false
    
    @EnvironmentObject var businessSerivesViewModel: BusinessServiceAddCategoryViewModel
    
    @EnvironmentObject var keyboardResponder: KeyboardResponder
    
    
    var body: some View {
        content
    }
    
    
    var backButton: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Image("arrow-square-left")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
        }

    }
    
    var content: some View {
        
        
        GeometryReader { geometry in
            VStack {
                
                //Top stack
                CustomNavigationTitle(name: "services".localized(language), logo: "briefcase", colors: colors)
                    .foregroundColor(colors.whiteColor)
                    .edgesIgnoringSafeArea(.top)
                    .padding(.bottom, -70)
                
                
                Button {
                    //Show add Sub catergory add pop up
                    isShowingSubCategory.toggle()
                } label: {
                    AddButtonView(buttonText: "add_subcategory".localized(language), colors: colors)
                        
                }
                
                


                
                
                //Main Content
                VStack(alignment: .trailing) {
                    //Category name
                    Text(category.title)
                        .foregroundColor(colors.blueColor)
                        .font(.custom("YekanBakhNoEn-Bold", size: 20))
                    
                    Text("select_active_subcategories".localized(language))
                        .foregroundColor(colors.grayColor)
                        .font(.custom("YekanBakhNoEn-Regular", size: 12))
                    
                }
                .padding(.trailing)
                .frame(width: UIScreen.screenWidth,alignment: .trailing)
                
                if let subCategories = businessSerivesViewModel.selectedCategory?.subCategory {
                    List(subCategories) { targetSub in
                        SubCategoryHamburgerCell(subCategory: targetSub, colors: colors, image: targetSub.image)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false, content: {
                                
                                
                                //Delete
                                Button {
                                    Task {
                                        await businessSerivesViewModel.deleteSubCategory(with: targetSub)
                                        await businessSerivesViewModel.getServices()
                                    }
                                } label: {
                                    Text("Delete")
                                }
                                .tint(.red)
                                
                                
                                //Edit
                                Button {
                                    //Bring up edit view
                                    editSubcategory(subCategory: targetSub)
                                    
                                } label: {
                                    VStack {
                                        Text("Edit")
                                    }
                                    
                                }
                                .tint(.orange)
                                
                                
                                
                                
                            })
                            .listRowSeparator(.hidden)
                            
                    }
                    .listStyle(.plain)
                    
                    
                    
                }
                    
                    
                    
                
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    GreenFunctionButton(buttonText: "Go back to categories", isAnimated: .constant(false))
                        .frame(width: UIScreen.screenWidth - 20, height: 45)
                }

                
                
                
                
                
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            
            
            
            .popup(isPresented: $isShowingSubCategory, view: {
                AddSubcategoryView(colors: colors, category: $category, subCategoryName: "", priceName: "", showSheet: false, isPresented: $isShowingSubCategory)
                    .environmentObject(keyboardResponder)
                    .environmentObject(businessSerivesViewModel)
                    .environment(\.layoutDirection, language == .english ? .rightToLeft : .leftToRight)
            }, customize: {
                $0
                    .backgroundColor(.black.opacity(0.4))
                    .position(.bottom)
                    .closeOnTap(false)
                    .closeOnTapOutside(true)
                    .type(.toast)
                    
            })
            
            
            .popup(isPresented: $isEditingSubCategory, view: {
                EditSubCategoryView(colors: colors, category: $category, subCategory: $subCategory, subCategoryName: "", priceName: "", showSheet: false, isPresented: $isEditingSubCategory)
                                .environmentObject(keyboardResponder)
                                .environmentObject(businessSerivesViewModel)
                                .environment(\.layoutDirection, language == .english ? .rightToLeft : .leftToRight)
                                
            }, customize: {
                $0
                    .backgroundColor(.black.opacity(0.4))
                    .position(.bottom)
                    .closeOnTap(false)
                    .closeOnTapOutside(true)
                    .type(.toast)
            })
            
            

            
            
            
        }
        .navigationBarBackButtonHidden()
        .environment(\.layoutDirection, language == .persian ? .leftToRight : .rightToLeft)
        .navigationBarItems(leading: backButton)
        
        
    }
    
    
    private func editSubcategory(subCategory : SubCategory) {
        
        self.subCategory = subCategory
        self.isEditingSubCategory = true
        
    }
    
}

