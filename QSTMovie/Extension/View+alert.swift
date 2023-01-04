//
//  View+alert.swift
//  QSTMovie
//
//  Created by Thy Nguyen on 1/4/23.
//

import SwiftUI

extension View {
    func errorAlert(isPresented: Binding<Bool>, error: AppError?) -> some View {
        alert(isPresented: isPresented) {
            Alert(title: Text(error?.message ?? ""),
                  message: nil,
                  dismissButton: .default(Text("OK")))
        }
    }
}
