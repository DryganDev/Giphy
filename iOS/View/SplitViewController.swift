//
//  SplitViewController.swift
//  SplitViewController
//
//  Created by Artsiom Sazonau on 11.08.21.
//

import SwiftUI
import UIKit

struct SplitViewController<Content: View, Content2: View>: UIViewControllerRepresentable {
    
    let master: Content
    let detail: Content2
    
    init(@ViewBuilder master: () -> Content,
         @ViewBuilder detail: () -> Content2) {
        self.master = master()
        self.detail = detail()
    }
    
    func makeUIViewController(context: Context) -> UISplitViewController {
        let vc = UISplitViewController(style: .doubleColumn)
        let primary = UIHostingController(rootView: master)
        let secondary = UIHostingController(rootView: detail)
        let easterEgg = UIHostingController(rootView: Text("Hey %)"))
        vc.setViewController(primary, for: .primary)
        vc.setViewController(secondary, for: .secondary)
        vc.setViewController(easterEgg, for: .compact)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UISplitViewController, context: Context) {
        
    }
    
}

