//
//  Search.swift
//  Search
//
//  Created by Artsiom Sazonau on 10.08.21.
//

import Foundation
import SwiftUI

struct Search: ViewModifier {
    
    @EnvironmentObject var searchViewModel: SearchViewModel
    
    func body(content: Content) -> some View {
        content
            .searchable(text: $searchViewModel.searchText,
                        placement: .automatic,
                        prompt: "Gifs") {
                ForEach(searchViewModel.searchResults, id: \.self) {
                    result in
                    Text("\(result)").searchCompletion(result)
                }
            }
    }
    
}
