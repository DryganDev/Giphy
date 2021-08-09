//
//  Navigation.swift
//  Navigation
//
//  Created by Artsiom Sazonau on 9.08.21.
//

import Foundation
import SwiftUI

struct Navigation<Content: View>: View {
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationView {
            content
        }
    }
}
