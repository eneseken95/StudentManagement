//
//  LoginViewModel.swift
//  StudentManagement
//
//  Created by Enes Eken 2 on 9.12.2024.
//

import Foundation

class LoginViewModel: ObservableObject {
    
    @Published var loginData: LoginModel?
    @Published var errorMessage: String?

    let prefixUrl = "http://localhost:3000"

    func login(userName: String, password: String) {
        guard let url = URL(string: "\(prefixUrl)/login") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "userName": userName,
            "password": password,
        ]

        do {
            let data = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = data
        } catch {
            print("Error serializing JSON: \(error.localizedDescription)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received"
                }
                return
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("JSON: \(jsonString)")
            }

            do {
                let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                if loginResponse.error {
                    DispatchQueue.main.async {
                        self.errorMessage = loginResponse.message
                    }
                } else {
                    DispatchQueue.main.async {
                        self.loginData = loginResponse.data
                        self.errorMessage = nil
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Kullanıcı adı veya şifre yanlış"
                }
            }
        }.resume()
    }

    func reset() {
        loginData = nil
        errorMessage = nil
    }
}
