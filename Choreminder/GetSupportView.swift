/*
 GetSupportView.swift
 Part of Chore
 Copyright 2024 Tyian R. Lashley.
 All rights reserved.
 */
 

import SwiftUI

struct GetSupportView: View {
    
    private var getSupportButtonView: some View {
        
        HStack {
            
            Button("Get Support") {
                
                
                if let emailUrl = URL(string:"mailto:ty.lashley14@icloud.com?subject=Support%20With%20Chore.%20Version%201.0") {
                    
                    UIApplication.shared.open(emailUrl)
                    
                }
            }
            .buttonStyle(PlainButtonStyle())
            .background(Color.white)
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, maxHeight: 44)
            .cornerRadius(10)
            .padding()
            
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: 44)
    }
    
    var body: some View {
        
        VStack {
            Spacer()
            Text("Need Help? Have a suggestion, or feedback?")
                .font(.title2)
                .padding()
                .accessibilityAddTraits(.isHeader)
            
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
        
    }
}

    struct GetSupportView_Preview: PreviewProvider {
        
        static var previews: some View {
            
            GetSupportView()
            
        }
        
    }

