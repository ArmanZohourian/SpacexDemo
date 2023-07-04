//
//  ContactsViewModel.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/9/22.
//

import Foundation
import Contacts
/// Each view model has a bunch of parameters
/// the request manager and the language ( being used to throw the suitable error)
/// request manager can be used to make the request in do catch block
/// and fills the variables required by that view if successfull
/// otherwise throwing error using , ThrowError function( Should be set to BaseViewModel)
/// Using async and await
class ContactsViewModel: ObservableObject {
    
    
    
    
    private var requestManager = RequestManager.shared
    
    let contactsApiManager = MultipartFromRequest(path: "/api/v1/business/business-user")
    
    @Published var contacts = [ContactInfo]()
    
    @Published var serverContacts : [ContactData]?
    
    @Published var selectedContacts = [ContactInfo]()
    
    @Published var isRequesting = false
    
    @Published var hasError = false
    
    @Published var errorMessage = ""
    
    @Published var isSuccessful = false
    
    @Published var isUploading = false
    
    var isFetchedNewContact = false {
        didSet {
            Task {
                await fetchContactsFromServer(with: "")
            }
        }
    }
    
    init() {
        getContacts()
    }
    
    
    
    
    func addContacts() async {
        
        guard selectedContacts.count > 0 else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.isRequesting = true
        }
        
        do {
            
            let stringContact = formatContacts(with: selectedContacts)
            let container : GlobalRespone = try await requestManager.perform(AddMultipleContacts.addContacts(contacts: stringContact))
            
            if container.status {
                //Do something
                
                
                DispatchQueue.main.async { [weak self] in
                    self?.isRequesting = false
                    self?.isFetchedNewContact.toggle()
                    self?.isSuccessful = true
                    self?.throwError(errorMessage: "operation_successful".localized(LocalizationService.shared.language))
                }
                
            } else {
                
                DispatchQueue.main.async { [weak self] in
                    self?.isRequesting = false
                        //Error messasge
                    self?.throwError(errorMessage: container.msg ?? "failed_to_upload_contacts".localized(LocalizationService.shared.language))
                }
                
            }
            
            
        }
        catch {
            
            //Throw error
            DispatchQueue.main.async { [weak self] in
                //Error message
                self?.isRequesting = false
                self?.throwError(errorMessage: "failed_to_upload_contacts".localized(LocalizationService.shared.language))
            }
            
        }
        
       
        
    }
    
    func addNewContact(imageData: Data?, params: [String:String], firstName: String, phoneNumber: String, completionHandler: @escaping (Bool) -> ())  {
        
        
        
        DispatchQueue.main.async { [weak self] in
            self?.isUploading = true
        }
        
        
        do {
            
            
            contactsApiManager.uploadImage(name: "logo", image: imageData, params: params,  methodType: "POST", container: ContactResponseModel.self, requeiresTokenAccess: true) { response, err, success in
                
                if success  {
                    if response!.status {
                        //Add contact with the given ID
                        let newContact = ContactInfo(serverId: response!.result ,firstname: firstName, lastname: "", phoneNumber: CNPhoneNumber(stringValue: phoneNumber), image: imageData)
                        self.appendContact(with: newContact)
                        self.isFetchedNewContact.toggle()
                        completionHandler(true)
                    }
                } else {
                    DispatchQueue.main.async { [weak self] in
                        self?.isUploading = false
                        self?.hasError = true
                        self?.errorMessage = "unable_to_conenct_to_server".localized(LocalizationService.shared.language)
                        completionHandler(false)
                    }
                }
                
                
                //MARK: Fix MultiPart Decoder
            }
            
            
        }
        
        catch {
            DispatchQueue.main.async { [weak self] in
                self?.isUploading = false
                completionHandler(false)
            }
        }
        
    }
    
    func fetchContacts() -> [ContactInfo] {
        
        
        var keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        
        
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try CNContactStore().enumerateContacts(with: request, usingBlock: { contact, stopPointer in
                    DispatchQueue.main.async {
                        self.contacts.append(ContactInfo(firstname: contact.givenName, lastname: contact.familyName, phoneNumber: contact.phoneNumbers.first?.value, image: contact.imageData))
                    }
                })
                
            } catch let error {
                print("Error fetching contacts: \(error)")
            }
        }
        
        contacts = contacts.sorted {
            $0.firstname < $1.firstname
        }
        
        return contacts
        
    }
    
    func fetchContactsFromServer(with searchText: String) async {
        
        
        do {
            
            
            
            let resultContainer: ServerContactContainer = try await requestManager.perform(GetContacts.getContactsWith(searchText: searchText))
            
            if resultContainer.status {
                
                
                DispatchQueue.main.async { [weak self] in
                    self?.serverContacts = [ContactData]()
                    self?.serverContacts!.append(contentsOf: resultContainer.data.businessUsers)
                    
                }
            }
            
            print(resultContainer)
            
            
        } catch {
            
        }
        
        
    }
    
    private func appendContact(with contact: ContactInfo) {
        
        if !contacts.contains(where: {
            $0.id == contact.id
        }) {
            contacts.append(contact)
        }
    }
    
    
    func getContacts() {
        DispatchQueue.main.async { [weak self] in
            self?.contacts = (self?.fetchContacts())!
        }
    }
    
    //MARK: Contacts request
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
    
    func addNewSelectedContact(withConact contact: ContactInfo) {
        
        DispatchQueue.main.async {
            if self.selectedContacts.contains(where: { existingContact in
                existingContact.id == contact.id
            }) {
                // If exsist remove
                self.selectedContacts.removeAll { existingContact in
                    existingContact.id == contact.id
                }
                
            } else {
                // Add the new contact
                self.selectedContacts.append(contact)
            }
        }
        
        
    }
    
    
    
    func formatContacts(with contacts: [ContactInfo]) -> [[String: String]] {
        
        var users = [Users]()
        var dic = [String: Any]()
        var dic2 = [[String: String]]()
        
        

        for contact in contacts {
                users.append(Users(name: contact.firstname + contact.lastname , phone: phoneNumberRegex(phoneNumber: contact.phoneNumber?.stringValue ?? "")))
        }
            
        
        for user in users {
            dic2.append(["name": user.name , "phone": user.phone])
        }
        
        dic["user"] = dic2
        
        
        return dic2
        
    }
    
    private func phoneNumberRegex(phoneNumber: String) -> String {
        
        //Replacing all the whitespaces
        let cleanedPhoneNumber = String(phoneNumber.filter { !" \n\t\r".contains($0) })
        
    
        if cleanedPhoneNumber.hasPrefix("+98") {
            
            let droppedPhoneNumber = cleanedPhoneNumber.dropFirst(3)
            return "98" + droppedPhoneNumber
            
//            return cleanedPhoneNumber.replacingOccurrences(of: "+98", with: "98")
            
        } else if cleanedPhoneNumber.hasPrefix("0098") {
            
            let droppedPhoneNumber = cleanedPhoneNumber.dropFirst(4)
            return "98" + droppedPhoneNumber
            
//            return cleanedPhoneNumber.replacingOccurrences(of: "0098", with: "98")
            
        } else if cleanedPhoneNumber.hasPrefix("0") {
            
            let droppedPhoneNumber = cleanedPhoneNumber.dropFirst()
            return "98" + droppedPhoneNumber
            
//            return cleanedPhoneNumber.replacingOccurrences(of: "0", with: "98")
        }
        
        return cleanedPhoneNumber

    }
    
    private func throwError(errorMessage: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.hasError = true
            self?.errorMessage = errorMessage ?? "unable_to_conenct_to_server".localized(LocalizationService.shared.language)
        }

    }
    
}


