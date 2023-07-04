//
//  AddContactView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/12/22.
//

import SwiftUI
import Contacts
import ExytePopupView

struct AddContactView: View {
    
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    @EnvironmentObject var contactObject: ContactsViewModel
    
    @State private var contacts = [ContactInfo.init(firstname: "", lastname: "", phoneNumber: nil, image: nil)]
    
    @State var isPresented = false
    @State var searchText = "" {
        didSet {
            print("Object is being changed")

        }
    }
    
    @State var isSearched = false
    
    @State var isShwoingAddContactPopup : Bool = false
    
    @State var isHamburgerPresnted = false
    
    @EnvironmentObject var keyboardResponder : KeyboardResponder
    
    @EnvironmentObject var baseViewModel: BaseViewModel
    
    @EnvironmentObject var profileCellViewModel: ProfileCellViewModel
    
    var colors: ConstantColors
    
    var body: some View {
        VStack(spacing: 10)  {
            
            ZStack {
                VStack {
                    ProfileCellView(isPresented: $isHamburgerPresnted)
                        .environmentObject(profileCellViewModel)
                        .padding([.leading, .trailing], 1)
                        .padding(.top, 25)
                        .environment(\.layoutDirection, .leftToRight)
                        
                    
                    AddContactSearchBarView(colors: colors , searchText: $searchText, isSearched: $isSearched)
                        .onChange(of: self.searchText) { newValue in
                            Task {
                                //Search for contacts when changed
                                await contactObject.fetchContactsFromServer(with: searchText)
                            }
                        }
                        .padding(.bottom)
                }
            
            }
            .background(colors.blueColor.cornerRadius(25, corners: [.bottomLeft, .bottomRight]))
            .edgesIgnoringSafeArea(.top)
            .frame(width: UIScreen.screenWidth)
            .frame(height: UIScreen.screenHeight / 4.5)
            .padding(.bottom)


            Button {
                isShwoingAddContactPopup.toggle()
            } label: {
                AddButtonView(buttonText: "add_contact".localized(language), colors: colors)
            }
            
            
            ScrollView {
                VStack(alignment: .trailing) {
                    
                    if let contacts = contactObject.serverContacts {
                        ForEach(contacts) { contact in
                            
                            ZStack(alignment: .trailing) {
                                Color.clear
                                ContactCellServerView(colors: colors, name: contact.name, phone: contact.phone, image: contact.image)
                                    .padding()
            
                            }
                            .frame(width: UIScreen.screenWidth - 20, height: 70)
                            .background(colors.cellColor)
                            .cornerRadius(5)
                            
                        }
                    } else {
                        Text("No contacts")
                    }
                    
                    
                    //MARK: Contacts from the contact
//                    ForEach (contactObject.contacts.filter({ (cont) -> Bool in
//                        self.searchText.isEmpty ? true :
//                        "\(cont)".lowercased().contains(self.searchText.lowercased())
//                    })) { contact in
//
//
//                        ZStack(alignment: .trailing) {
//                            Color.clear
//                            ContactCellView(contact: contact, colors: colors)
//                                .padding()
//
//                        }
//                        .frame(width: UIScreen.screenWidth - 20, height: 70)
//                        .background(colors.cellColor)
//                        .cornerRadius(5)
//
//                    }
                    //Divider here , with the contact cell view forEach contact from the list

                }
                .padding()
                
            }
        }
        
        
        .onAppear() {
            Task {
                await contactObject.fetchContactsFromServer(with: "")
            }
        }

        .fullScreenCover(isPresented: $isHamburgerPresnted, content: {
            MenuHumbergerView(isPresneted: $isHamburgerPresnted, colors: colors)
                .environmentObject(profileCellViewModel)
                .environmentObject(keyboardResponder)
                .environmentObject(baseViewModel)
        })
        
        
        .sheet(isPresented: $isShwoingAddContactPopup, content: {
            PhoneContactView(isPresented: $isShwoingAddContactPopup)
                .environmentObject(keyboardResponder)
                .environmentObject(contactObject)
        })
        
        .background(Color.white)
        
    }

}

struct AddContactView_Previews: PreviewProvider {
    static var colors: ConstantColors = ConstantColors()
    static var previews: some View {
        AddContactView(colors: colors)
    }
}
