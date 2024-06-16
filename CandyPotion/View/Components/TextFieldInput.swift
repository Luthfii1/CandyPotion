//
//  TextFieldInput.swift
//  CandyPotion
//
//  Created by Luthfi Misbachul Munir on 17/06/24.
//

import SwiftUI

struct TextFieldInput: View {
    var placeholder: String
    var isSearching: Bool
    @State private var input: String = ""
    
    var body: some View {
        HStack {
            if isSearching {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.gray)
            }
            
            TextField(placeholder, text: $input, axis: .vertical)
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
                .padding(.vertical, 2)
            
            Spacer()
            
            if !input.isEmpty {
                Image(systemName: "xmark.circle")
                    .imageScale(.large)
                    .font(.subheadline)
                    .foregroundStyle(.black)
                    .padding(.horizontal, 5)
                    .onTapGesture {
//                        cleansearch
                    }
            }
        }
        .padding(10)
        .overlay {
            RoundedRectangle(cornerRadius: 10.0)
                .stroke(lineWidth: 2)
                .foregroundStyle(Color(.systemGray))
        }
        .padding(.horizontal, 2)
        .padding(.bottom, 10)
    }
}

#Preview {
    TextFieldInput(placeholder: "Search your product", isSearching: false)
}
