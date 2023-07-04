//
//  ContactView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/9/22.
//

import SwiftUI
import Contacts
import ExytePopupView

struct ContactView: View {
    
    var language = LocalizationService.shared.language
    
    @EnvironmentObject var timeTableViewModel: TimeTableViewModel
    
    @EnvironmentObject var contactObject: ContactsViewModel
    
    @EnvironmentObject var keyboardResponder: KeyboardResponder
    
    @State private var contacts = [ContactInfo.init(firstname: "", lastname: "", phoneNumber: nil, image: nil)]
    
    @State var searchText = ""
    
    @State var isShwoingAddContactPopup = false
    
    @Binding var isPresneted: Bool
    
    var contact = ContactInfo(firstname: "", lastname: "")
    
    var colors: ConstantColors
    
    var body: some View {
        VStack(alignment: .trailing) {
            HStack {
                Image("close-circle")
                    .onTapGesture {
                        isPresneted = false
                    }
                    
                
                Spacer()
            
                Text("search_contacts".localized(language))
                    .padding()
                
            }
            .padding([.leading, .trailing])
            
            SearchBarView(searchText: $searchText, addTapped: $isShwoingAddContactPopup, colors: colors)
                .onChange(of: searchText) { newValue in
                    Task {
                        await contactObject.fetchContactsFromServer(with: newValue)
                    }
                }
            
            ScrollView {
                
                
                // Contact List
                VStack(alignment: .trailing) {
                    
                    if let contacts = contactObject.serverContacts {
                        ForEach(contacts) { contact in
                            ContactCellServerView(colors: colors, name: contact.name, phone: contact.phone, image: contact.image ?? "")
                                .onTapGesture {
                                    timeTableViewModel.choosenContact = contact
                                    isPresneted = false
                                }
                            Divider()
                            
                        }
                    } else {
                        Text("No contacts")
                    }
                    
                    
                    
    
                    //MARK: Contacts from device
//                    ForEach (self.contacts.filter({ (cont) -> Bool in
//                        self.searchText.isEmpty ? true :
//                        "\(cont)".lowercased().contains(self.searchText.lowercased())
//                    })) { contact in
//
//                        ContactCellView(contact: contact, colors: colors)
//                            .onTapGesture {
//                                //MARK: Add the contact to the view
////                                self.contact = contact
//                                contactObject.contact = contact
//                                isPresneted = false
//
//                            }
//                        Divider()
//                    }
                    //Divider here , with the contact cell view forEach contact from the list

                }
                .padding()
                
            }
            .onAppear {
                contactObject.getContacts()
                Task {
                    await contactObject.fetchContactsFromServer(with: searchText)
                }
            }

        }
        
        .environment(\.layoutDirection, language == .persian ? .leftToRight : .rightToLeft)
        

        .popup(isPresented: $isShwoingAddContactPopup) {
            AddContactPopupView(colors: colors, isPresented: $isShwoingAddContactPopup)
                .environmentObject(keyboardResponder)
        } customize: {
            $0
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.4))
        }

        
        
    }
    
    
    
    func getContacts() {
        DispatchQueue.main.async {
            self.contacts = ContactsViewModel().fetchContacts()
        }
    }
    
    
    
    
    func requestAccess() {
            let store = CNContactStore()
            switch CNContactStore.authorizationStatus(for: .contacts) {
            case .authorized:
                self.getContacts()
            case .denied:
                store.requestAccess(for: .contacts) { granted, error in
                    if granted {
                        self.getContacts()
                    }
                }
            case .restricted, .notDetermined:
                store.requestAccess(for: .contacts) { granted, error in
                    if granted {
                        self.getContacts()
                    }
                }
            @unknown default:
                print("error")
            }
        }
}

struct ContactView_Previews: PreviewProvider {
    static var previews: some View {
        ContactView(isPresneted: .constant(true), colors: ConstantColors())
    }
}
