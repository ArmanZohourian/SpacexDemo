//
//  AddShiftViewModel.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/15/22.
//

import Foundation
/// Each view model has a bunch of parameters
/// the request manager and the language ( being used to throw the suitable error)
/// request manager can be used to make the request in do catch block
/// and fills the variables required by that view if successfull
/// otherwise throwing error using , ThrowError function( Should be set to BaseViewModel)
/// Using async and await
class AddShiftViewModel: ObservableObject {
    
    
    var shifts = [Shift]()
    
    var language = LocalizationService.shared.language
    
    @Published var hasError = false
    
    @Published var errorMessage = ""
    
    @Published var isSuccessfull = false
    
    @Published var isRequeting = false
    
    private var requestManager = RequestManager.shared
    
    func addShift(startDate: Date, endDate: Date, activeDays: String, isHolidaysOn: Bool) async {
        
        
        let isHolidaysOnStr = String(isHolidaysOn)
        
        
        
        guard startDate.timeIntervalSince1970 < endDate.timeIntervalSince1970 else {
            throwError(errorMessage: "select_valid_range".localized(language))
            return
        }
        
        guard activeDays != "" else {
            throwError(errorMessage: "set_free_days".localized(language))
            return
        }
        
        
        DispatchQueue.main.async { [weak self] in
            self?.isRequeting = true
        }

        
        
        do {
            
            let resultContainer: SignShiftResponse =
            try await requestManager.perform(AddShift.addShift(startDate: generatedDate(date: startDate), endDate: generatedDate(date: endDate), activeDays: activeDays, isHolidaysOn: isHolidaysOnStr))
            
            
            if resultContainer.status {
                DispatchQueue.main.async { [weak self] in
                    self?.isRequeting = false
                    self?.isSuccessfull = true
                }
                
                
                addNewShift(startDate: generatedDate(date: startDate), endDate: generatedDate(date: endDate), activeDays: activeDays, isHolidaysOn: isHolidaysOn)
                
                
            } else {
                
                DispatchQueue.main.async { [weak self] in
                    self?.isRequeting = false
                    self?.hasError = true
                    self?.errorMessage = resultContainer.msg ?? ""
                }
                throwError(errorMessage: nil)
            }
            
        }
        catch {
            print("throw error")
            throwError(errorMessage: nil)
        }
        
    }
    
    private func throwError(errorMessage: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.hasError = true
            self?.errorMessage = errorMessage ?? "unable_to_conenct_to_server".localized(LocalizationService.shared.language)
        }

    }
    
    
    private func addNewShift(startDate: String, endDate: String, activeDays: String, isHolidaysOn: Bool) {
        
        let newShift = Shift(startDate: startDate, endDate: endDate, activeDays: activeDays, isHolidaysOn: isHolidaysOn)
        shifts.append(newShift)
    }
    
    
    
    private func generatedDate(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "En")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
        
        
    }
    
    
}
