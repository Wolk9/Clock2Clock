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
            VStack(alignment: .leading, spacing: 4) {
                Button {
                    viewModel.isEditProfileViewOpen = false
                } label: {
                    HStack(spacing: 3) {
                        Image(systemName: "arrow.left")
                        Text("Back")
                    }
                    
                }
            }
            
            List {
                Section {
                    HStack {
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray))
                            .clipShape(Circle())
                        
                        
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.fullName)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                            
                            Text(user.email)
                                .font(.footnote)
                                .foregroundColor(Color(.gray))
                        }
                    }
                    
                }
                
                
                Section("General") {
                    HStack {
                        SettingsRowView(imageName: "gear",
                                        title: "Version",
                                        tintColor: Color(.systemGray))
                        Spacer()
                        Text("1.0.0")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                Section("Details") {
                    if let user = viewModel.currentUser {
                        Text("Edit profile of \(user.fullName)")
                    }
                    Button {
                        print("Edit FirstName")
                        
                    } label: {
                        SettingsRowView(imageName: "", title: "FirstName", tintColor: .green)
                    }
                    Button {
                        print("Edit LastName")
                    } label: {
                        SettingsRowView(imageName: "",
                                        title: "LastName",
                                        tintColor: .red)
                        
                    }
                }
                .padding(5)
            }
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

