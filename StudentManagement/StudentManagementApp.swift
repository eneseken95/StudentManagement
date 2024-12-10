//
//  StudentManagementApp.swift
//  StudentManagement
//
//  Created by Enes Eken 2 on 8.12.2024.
//

import SwiftUI

@main
struct StudentManagementApp: App {
    var body: some Scene {
        WindowGroup {
            LoginView().environmentObject(LoginViewModel())
        }
    }
}
