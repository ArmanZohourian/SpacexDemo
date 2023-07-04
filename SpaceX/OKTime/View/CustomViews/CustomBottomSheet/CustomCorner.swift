//
//  CustomCorner.swift
//  TestProject
//
//  Created by Arman Zohourian on 1/1/23.
//

import SwiftUI

struct CustomCorner: Shape {

    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        return Path(path.cgPath)
        
        
    }
    
}


