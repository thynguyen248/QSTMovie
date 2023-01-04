//
//  NavigationLazyView.swift
//  QSTMovie
//
//  Created by Thy Nguyen on 1/3/23.
//

import SwiftUI

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
