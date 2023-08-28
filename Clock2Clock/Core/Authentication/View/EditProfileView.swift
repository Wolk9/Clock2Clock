//
//  EditProfileView.swift
//  Clock2Clock
//
//  Created by Macbook  on 28/08/2023.
//

import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        if let user = viewModel.currentUser {
            Text("Edit profile of \(user.fullName)")
        }
       
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
            .environmentObject(AuthViewModel())
            .environmentObject(ErrorHandlingModel())
    }
}

