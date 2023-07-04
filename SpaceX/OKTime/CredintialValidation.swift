//
//  Authentication.swift
//  OKTime
//
//  Created by Arman Zohourian on 12/31/22.
//

import Foundation

///Validating the password with the given regex , if validated , return true
class CredintialValidation {
    
    
    func isPasswordValid(withPassword password: String) -> Bool {
        
        
        let valiadator = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[$@$#!%*?&]).{8,}$")

        return valiadator.evaluate(with: password) // True else False
        
    }
    
}
