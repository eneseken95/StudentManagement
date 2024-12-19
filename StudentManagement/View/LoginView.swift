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
                LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.8), Color.blue.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    Spacer()
                    Text("Kullanıcı Girişi")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .padding()
                        .padding(.bottom, -12)

                    HStack(spacing: 25) {
                        VStack(spacing: 5) {
                            Image("StudentImage")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 88, height: 88)
                                .cornerRadius(10)
                                .padding(6)
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
                                .padding(6)
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

                    ZStack(alignment: .leading) {
                        TextField("", text: $userName)
                            .padding()
                            .frame(width: 350)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .foregroundColor(.black)
                            .disabled(retryMessage != nil)

                        if userName.isEmpty {
                            Text("Kullanıcı Adı")
                                .foregroundColor(.gray)
                                .padding(.leading, 15)
                        }
                    }

                    ZStack(alignment: .leading) {
                        SecureField("", text: $password)
                            .padding()
                            .frame(width: 350)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .foregroundColor(.black)
                            .disabled(retryMessage != nil)

                        if password.isEmpty {
                            Text("Şifre")
                                .foregroundColor(.gray)
                                .padding(.leading, 15)
                        }
                    }

                    if let errorMessage = retryMessage {
                        Text(errorMessage)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }

                    if retryMessage == nil {
                        Button(action: {
                            handleLogin()
                        }) {
                            Text("Giriş Yap")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 150, height: 55)
                                .background(Color.orange)
                                .cornerRadius(12)
                                .shadow(radius: 10)
                                .padding(.horizontal, 20)
                        }
                        .padding(.horizontal)
                        .padding(.top, 25)
                    } else {
                        Button(action: {
                            resetState()
                        }) {
                            Text("Tekrar Dene")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 150, height: 55)
                                .background(Color.red)
                                .cornerRadius(12)
                                .shadow(radius: 10)
                                .padding(.horizontal, 20)
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
