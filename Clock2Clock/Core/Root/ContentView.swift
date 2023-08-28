//
//  ContentView.swift
//  Clock2Clock
//
//  Created by Macbook  on 27/08/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var errorModel: ErrorHandlingModel
    
    var body: some View {
        VStack {
            Group {
                if viewModel.userSession != nil {
                    if viewModel.isEditProfileViewOpen {
                        EditProfileView()
                    } else {
                        ProfileView()
                    }
                } else {
                    LoginView()
                }
            }
        }
        .alert(isPresented: $errorModel.showError, content: {
            Alert(title: Text("Error"),
                  message: Text(errorModel.errorMessage),
                  dismissButton: .default(Text("OK")) {
                errorModel.resetError()
            })
        })
    
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthViewModel())
            .environmentObject(ErrorHandlingModel())
    }
}

