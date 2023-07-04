//
//  PhoneContactView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/28/22.
//

import SwiftUI
import ExytePopupView

struct PhoneContactView: View {
    
    var colors = ConstantColors()
    
    @EnvironmentObject var contactObject: ContactsViewModel
    @State var searchText = ""
    @Binding var isPresented: Bool
    @State var isShwoingAddContactPopup = false
    @EnvironmentObject var keyboardResponder : KeyboardResponder
    
    var language = LocalizationService.shared.language
    
    
    var body: some View {
        
        VStack {

            HStack {
                CustomTextField(colors: colors, labelName: "search_contacts".localized(language), placeholder: "search_contacts_placeholder".localized(language), text: $searchText)
                    .overlay(alignment: .bottomLeading) {
                        Button {
                            //isPresented , true
                            isPresented = true
                        } label: {
                            Text("+")
                                .font(.system(size: 30))
                                .foregroundColor(Color.white)
                                .frame(width: 40, height: 40)
                                .onTapGesture {
                                    isShwoingAddContactPopup.toggle()
                                }
                                
                        }
                        .background(colors.blueColor)
                        .cornerRadius(5)
                        .padding(.leading, 5)
                        .padding(.bottom, 5)

                    }
                    .overlay(alignment: .topLeading, content: {
                        Image("close-circle")
                            .padding()
                            .onTapGesture {
                                isPresented = false
                            }
                    })
                    .padding(.trailing)
            }
            .padding()
            
            ScrollView {
                VStack(alignment: .trailing) {
                    
                    ForEach (contactObject.contacts.filter({ (cont) -> Bool in
                        self.searchText.isEmpty ? true :
                        "\(cont)".lowercased().contains(self.searchText.lowercased())
                    })) { contact in
                        
                        
                        ZStack(alignment: .trailing) {
                            Color.clear
                            ContactSelectCellView(contact: contact, colors: colors, isSelected: isSelectedContact(contact: contact))
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    contactObject.addNewSelectedContact(withConact: contact)
                                }
                                .padding()
                            
                            
                        }
                        .frame(width: UIScreen.screenWidth - 20, height: 70)
                        .cornerRadius(5)


                    }
                }
                .padding()
                
                
            }
            


            Button {
                Task {
                    await contactObject.addContacts()
                    await contactObject.fetchContactsFromServer(with: "")
                    
                    if contactObject.isSuccessful {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            // Dismiss sheet
                            isPresented = false
                        }
                    }

                }
            } label: {
                GreenFunctionButton(buttonText: "add_contacts".localized(language), isAnimated: $contactObject.isRequesting)
                    .frame(width: UIScreen.screenWidth - 10 , height: 40)
            }
            
        }
        
        .popup(isPresented: $isShwoingAddContactPopup, view: {
            
            AddContactPopupView(colors: colors, isPresented: $isShwoingAddContactPopup)
                                   .environmentObject(keyboardResponder)
        }, customize: {
            $0
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.4))
        })
    
        
        
        .environment(\.layoutDirection, language == .persian ? .leftToRight : .rightToLeft)
        
        
    }
    
    
    private func isSelectedContact(contact: ContactInfo) -> Bool {
        
        if contactObject.selectedContacts.contains(where: { existingContact in
            existingContact.id == contact.id
        }) {
            
            return true
            
        } else {
            
            return false
            
        }

    }
    
    
}
