//
//  GetSupportView.swift
//  Choreminder
//
//  Created by Tee Lashley on 1/2/25.
//


import SwiftUI

struct GetSupportView: View {
    
    var body: some View {
        
        VStack {
            
            Text("Need Help? Have a suggestion, or feedback")
            
            Text("Sometimes, apps don't work they way we'd like them too. Or maybe you have a suggestion or feedback.\nNo worries. Tap Get Support to send an email.")
            Spacer()
            Button("Get Support") {
                
                
                if let emailUrl = URL(string:"mailto:ty.lashley14@icloud.com?subject=Support%20With%20Chore.%20Version%201.0") {
                    
                    UIApplication.shared.open(emailUrl)
                    
                }
            }
        }
        .background(Color.indigo)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle("Get Support")
        
    }
}

    struct GetSupportView_Preview: PreviewProvider {
        
        static var previews: some View {
            
            GetSupportView()
            
        }
        
    }

