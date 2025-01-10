/*
 GetSupportView.swift
 Part of Chore
 Copyright 2024 Tyian R. Lashley.
 All rights reserved.
 */
 

import SwiftUI

struct GetSupportView: View {

    @AccessibilityFocusState private var focus: Bool
    
    private var getSupportButtonView: some View {
        
        HStack {
            
            Button("Get Support") {
                
                
                if let emailUrl = URL(string:"mailto:ty.lashley14@icloud.com?subject=Support%20With%20Chore.%20Version%201.0") {
                    
                    UIApplication.shared.open(emailUrl)
                    
                }
            }
            .frame(maxWidth: .infinity, minHeight: 44)
            .background(Color.white)
            .foregroundColor(.black)
            .cornerRadius(10)
            .padding()
            .accessibilityHint("Double tap to open mail composer")
            
        }
        .padding(.horizontal)
    }
    
    var body: some View {
        
        VStack {
            Spacer()
            Text("Need Help? Have a suggestion, or feedback?")
                .font(.title2)
                .padding()
                .accessibilityAddTraits(.isHeader)
                .accessibilityFocused($focus)
            
            Text("Sometimes, apps don't work the way we'd like them too. Or maybe you have a suggestion or feedback.\nNo worries. Tap Get Support to send an email.")
                .font(.body)
                .multilineTextAlignment(.center)
            
            Spacer()
            getSupportButtonView
        }
        .background(Color.indigo)
        .foregroundColor(.white)
         
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle("Get Support")
        
        .onAppear {
            
            focus = true
            
        }
        
    }
}

    struct GetSupportView_Preview: PreviewProvider {
        
        static var previews: some View {
            
            GetSupportView()
            
        }
        
    }

