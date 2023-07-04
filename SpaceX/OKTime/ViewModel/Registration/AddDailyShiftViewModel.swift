//
//  Add .swift
//  OKTime
//
//  Created by Arman Zohourian on 11/16/22.
//

import Foundation
/// Each view model has a bunch of parameters
/// the request manager and the language ( being used to throw the suitable error)
/// request manager can be used to make the request in do catch block
/// and fills the variables required by that view if successfull
/// otherwise throwing error using , ThrowError function( Should be set to BaseViewModel)
/// Using async and await
class AddDailyShiftViewModel: ObservableObject {
    
    var language = LocalizationService.shared.language
    
    private var requestManager = RequestManager.shared
    
    @Published var newShifts = [NewShift]() {
        didSet {
            if newShifts.count > 0 {
                isAllowedtoPass = true
            }
        }
    }
    
    @Published var shiftDetails = [ShiftDetail]()
    
    @Published var currentShift : NewShift?
    
    @Published var hasError = false {
        didSet {
            print("Changed to:\(hasError)")
        }
    }
    
    @Published var errorMessage = ""
    
    @Published var isRequesting = false
    
    @Published var isSuccessfull = false
    
    @Published var isAllowedtoPass = false
    
    let dateFormatter = DateFormatter()
    
    func addNewShift(startDate: String, endDate: String, shiftDuration: String, shiftTitle: String, days: [String], completionHandler: @escaping (Bool)->()) async {
        
        
        guard !days.isEmpty else {
            throwError(errorMessage: "select_days".localized(language))
            return
        }
        
        guard startDate < endDate else {
            throwError(errorMessage: "select_valid_range".localized(language))
            return
        }
        
        guard shiftTitle != "" else {
            throwError(errorMessage: "enter_shift_title".localized(language))
            return
        }
        

        let daysStr = configureDays(with: days)
        
        DispatchQueue.main.async { [weak self] in
            self?.isRequesting = true
        }
        
        do {
            
            let resultContainer : CategoryResponse = try await requestManager.perform(AddNewShift.addNewShift(startDate: startDate, endDate: endDate, shiftDuration: shiftDuration, days: daysStr, title: shiftTitle))
            
            
            if resultContainer.status {
                
                //Add New shift with the new data from the server
                DispatchQueue.main.async { [weak self] in
                    let newShift = NewShift(serverId: resultContainer.data, title: shiftTitle, startHour: startDate, endHour: endDate, duration: shiftDuration, days: days)
                    self?.appendNewShift(with: newShift)
                    self?.isRequesting = false
                    self?.isSuccessfull = true
                    completionHandler(true)
                }
            } else {
                //Handle Errors
                throwError(errorMessage: resultContainer.msg ?? "unknown_error".localized(language))
                isRequesting = false
            }
            
            
        }
        catch {
            
            throwError(errorMessage: "unknown_error".localized(language))
            isRequesting = false
            
        }
        
    }
    
    func deleteShift(with shift: ShiftDetail) async {
        
        
        do {
            let container : GlobalRespone = try await requestManager.perform(DeleteDailyShift.deleteShiftWith(id: String(shift.id)))
            if container.status {
                //Do nothing
            } else {
                throwError(errorMessage: container.msg ?? "")
            }
        }
        
        catch {
            throwError(errorMessage: "Unable to connect to server")
        }
       
        
        
    }
    
    func editShift(startDate: String, endDate: String, shiftDuration: String, shiftTitle: String, days: [String], currentShift: ShiftDetail, completionHandler: @escaping (Bool)-> ()) async {
        
        
        guard !days.isEmpty else {
            throwError(errorMessage: "select_days".localized(language))
            return
        }
        
        guard shiftTitle != "" else {
            throwError(errorMessage: "enter_shift_title".localized(language))
            return
        }
        
        guard startDate < endDate else {
            throwError(errorMessage: "select_valid_range".localized(language))
            return
        }
        
        let daysStr = configureDays(with: days)
        
        DispatchQueue.main.async { [weak self] in
            self?.isRequesting = true
        }
        
        do {
            let resultContainer: EditShiftResponse = try await requestManager.perform(EditShift.editCurrentShift(id: String(currentShift.id), startDate: startDate, endDate: endDate, shiftTitle: shiftTitle, dayOfWeek: daysStr, shiftDuration: shiftDuration))
            
            if resultContainer.status {
                //Change the current shift
                DispatchQueue.main.async { [weak self] in
                    let newShift = NewShift(serverId: currentShift.id, title: shiftTitle, startHour: startDate, endHour: endDate, duration: shiftDuration, days: days)
                    self?.isSuccessfull = true
                    self?.isRequesting = false
                    completionHandler(true)
                }
            } else {
             
                DispatchQueue.main.async { [weak self] in
                    self?.throwError(errorMessage: resultContainer.msg)
                    self?.isSuccessfull = false
                    self?.isRequesting = false
                }

                
            }
        }
        catch {
            DispatchQueue.main.async { [weak self] in
                self?.isRequesting = false
                self?.isSuccessfull = false
                
            }
        }
        
    }
    
    func getShiftDetails() async {
        
        
        
        do {
            
            let container : ShiftDetailsResponse = try await requestManager.perform(GetShiftsDetails.getAllShiftDetails)
            
            if container.status {
                DispatchQueue.main.async { [weak self] in
                    
                    self?.shiftDetails = [ShiftDetail]()
                    self?.shiftDetails.append(contentsOf: container.data.shifts)
                    
                }
            }

        }
        
        catch {
            
            
            print("ERROR")
        }
        
        
        
        
    }
    
    func checkIfAddedShift() {
        if newShifts.count == 0 {
            throwError(errorMessage: "Please add at least one shift")
        }
    }
    
    
    //MARK: Private Functionalities
    private func configureDays(with days: [String]) -> String {
        var configuredDays = [String]()
         var finalDaysFormat = ""
         for day in days {
             switch day {
             case "saturday".localized(language):
                 configuredDays.append("Saturday")
                 
             case "sunday".localized(language):
                 configuredDays.append("Sunday")
                 
             case "monday".localized(language):
                 configuredDays.append("Monday")
                 
             case "tuesday".localized(language):
                 configuredDays.append("Tuesday")
                 
             case "wednesday".localized(language):
                 configuredDays.append("Wednesday")
                 
             case "thursday".localized(language):
                 configuredDays.append("Thursday")
                 
             case "firday".localized(language):
                 configuredDays.append("Friday")
                 
             default:
                 break
             }
         }
         for configuredDay in configuredDays {
             
             finalDaysFormat += "\(configuredDay.uppercased()),"
         }
        
        return String(finalDaysFormat.dropLast()) 
    }
    
    private func dateToString(with date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        return dateFormatter.string(from: date)
        
    }
    
    private func appendNewShift(with newShift: NewShift) {
        
        if newShifts.contains(where: {
            $0.id == newShift.id
        }) {
            //Do not append
        } else {
            newShifts.append(newShift)
        }
        
    }
    
    private func throwError(errorMessage: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.hasError = true
            self?.errorMessage = errorMessage ?? "unable_to_conenct_to_server".localized(LocalizationService.shared.language)
        }

    }
    
    
    
    
}
