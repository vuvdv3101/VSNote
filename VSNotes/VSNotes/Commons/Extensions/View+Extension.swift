//
//  View+Extension.swift
//  VSNotes
//
//  Created by Admin on 7/2/26.
//

import SwiftUI

extension View {
    
    func roundedCorner(_ radius: CGFloat) -> some View {
        clipShape(RoundedRectangle(cornerRadius: radius))
    }
}
