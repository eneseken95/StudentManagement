//
//  LoginView.swift
//  StudentManagement
//
//  Created by Enes Eken 2 on 10.12.2024.
//

import SwiftUI

struct LoginView: View {
    
    @State private var userName = ""
    @State private var password = ""
    @State private var shouldNavigate = false
    @State private var retryMessage: String?
    @State private var selectedRole: Role = .student
    @ObservedObject var viewModel = ViewModels()

    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemBackground)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    Spacer()
                    Text("Kullanıcı Girişi")
                        .font(.largeTitle.bold())
                        .foregroundColor(.primary)
                        .padding()
                        .padding(.bottom, -12)

                    HStack(spacing: 25) {
                        VStack(spacing: 5) {
                            Image("StudentImage")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 88, height: 88)
                                .cornerRadius(10)
                                .border(selectedRole == .student ? Color.white : Color.clear, width: 2)
                                .onTapGesture {
                                    if retryMessage == nil {
                                        selectedRole = .student
                                    }
                                }
                                .disabled(retryMessage != nil)

                            Text("Öğrenci")
                                .font(.headline)
                                .foregroundColor(.white)
                        }

                        VStack(spacing: 5) {
                            Image("TeacherImage")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 90, height: 90)
                                .cornerRadius(10)
                                .border(selectedRole == .teacher ? Color.white : Color.clear, width: 2)
                                .onTapGesture {
                                    if retryMessage == nil {
                                        selectedRole = .teacher
                                    }
                                }
                                .disabled(retryMessage != nil)

                            Text("Personel")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    .padding(.bottom, 5)

                    TextField("Kullanıcı Adı", text: $userName)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10)
                            .fill(Color(UIColor.secondarySystemBackground)))
                        .textFieldStyle(PlainTextFieldStyle())
                        .autocapitalization(.none)
                        .disabled(retryMessage != nil)

                    SecureField("Şifre", text: $password)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10)
                            .fill(Color(UIColor.secondarySystemBackground)))
                        .textFieldStyle(PlainTextFieldStyle())
                        .disabled(retryMessage != nil)

                    if let errorMessage = retryMessage {
                        Text(errorMessage)
                            .font(.headline)
                            .foregroundColor(.red)
                            .padding()
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }

                    if retryMessage == nil {
                        Button(action: {
                            handleLogin()
                        }) {
                            Text("Giriş Yap")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: 150)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .padding(.top, 15)
                        }
                        .padding(.horizontal)
                    } else {
                        Button(action: {
                            resetState()
                        }) {
                            Text("Tekrar Dene")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: 150)
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }

                    Spacer()
                }
                .padding()
                .navigationDestination(isPresented: $shouldNavigate) {
                    destinationView()
                }
                .onChange(of: viewModel.loginData) { _ in
                    if let loginData = viewModel.loginData {
                        switch loginData.role {
                        case .student:
                            if selectedRole == .student {
                                shouldNavigate = true
                                retryMessage = nil
                            } else {
                                retryMessage = "Öğrenci rolüyle giriş yapmalısınız"
                            }
                        case .teacher:
                            if selectedRole == .teacher {
                                shouldNavigate = true
                                retryMessage = nil
                            } else {
                                retryMessage = "Personel rolüyle giriş yapmalısınız."
                            }
                        case .admin:
                            if selectedRole == .teacher {
                                shouldNavigate = true
                                retryMessage = nil
                            } else {
                                retryMessage = "Personel rolüyle giriş yapmalısınız."
                            }
                        }
                    }
                }

                .onChange(of: viewModel.errorMessage) { errorMessage in
                    if let errorMessage = errorMessage {
                        retryMessage = errorMessage
                    }
                }
            }
        }
        .statusBarHidden()
        .onAppear {
            resetState()
        }
        .preferredColorScheme(.dark)
    }

    private func handleLogin() {
        if userName.isEmpty || password.isEmpty {
            retryMessage = "Lütfen tüm alanları doldurun."
            return
        }

        viewModel.login(userName: userName, password: password)
    }

    private func destinationView() -> some View {
        guard let role = viewModel.loginData?.role else {
            return AnyView(Text("Hata"))
        }

        switch role {
        case .student:
            return AnyView(StudentView(userName: userName, onDismiss: {
                resetState()
            }, viewModel: viewModel))
        case .teacher:
            return AnyView(TeacherView(userName: userName, onDismiss: {
                resetState()
            }, viewModel: viewModel))
        case .admin:
            return AnyView(AdminView(userName: userName, onDismiss: {
                resetState()
            }))
        }
    }

    private func resetState() {
        userName = ""
        password = ""
        retryMessage = nil
        shouldNavigate = false
        selectedRole = .student
        viewModel.reset()
    }
}

#Preview {
    LoginView()
}
