//
//  ViewModels.swift
//  StudentManagement
//
//  Created by Enes Eken 2 on 9.12.2024.
//

import Combine
import Foundation

class ViewModels: ObservableObject {
    
    @Published var loginData: LoginModel?
    @Published var lessonsData: LessonsResponse?
    @Published var errorMessage: String?

    let prefixUrl = "http://localhost:3000"
    private var cancellables = Set<AnyCancellable>()

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

    func fetchLessonsTeacher(for userName: String) {
        guard let url = URL(string: "\(prefixUrl)/login/teachers?userName=\(userName)") else {
            errorMessage = "Invalid URL"
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    self.errorMessage = "Failed to fetch lessons: \(error.localizedDescription)"
                }
            }, receiveValue: { data in
                if let rawString = String(data: data, encoding: .utf8) {
                    print("Raw response: \(rawString)")
                }

                do {
                    let response = try JSONDecoder().decode(LessonsResponse.self, from: data)
                    print("Decoded response: \(response)")
                    self.lessonsData = response
                } catch {
                    print("Error decoding response: \(error.localizedDescription)")
                    self.errorMessage = "Failed to decode lessons"
                }
            })
            .store(in: &cancellables)
    }

    func fetchLessonsStudents(for userName: String) {
        guard let url = URL(string: "\(prefixUrl)/login/students?userName=\(userName)") else {
            errorMessage = "Invalid URL"
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    self.errorMessage = "Failed to fetch lessons: \(error.localizedDescription)"
                }
            }, receiveValue: { data in
                if let rawString = String(data: data, encoding: .utf8) {
                    print("Raw response: \(rawString)")
                }

                do {
                    let response = try JSONDecoder().decode(LessonsResponse.self, from: data)
                    print("Decoded response: \(response)")
                    self.lessonsData = response
                } catch {
                    print("Error decoding response: \(error.localizedDescription)")
                    self.errorMessage = "Failed to decode lessons"
                }
            })
            .store(in: &cancellables)
    }

    func updateLessonMandatory(userName: String, lesson: String, isMandatory: Bool, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "\(prefixUrl)/login/students/elective/lessons")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "userName": userName,
            "lesson": lesson,
            "isMandatory": isMandatory,
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Error encoding data: \(error)")
            completion(false)
            return
        }

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error updating lesson: \(error.localizedDescription)")
                completion(false)
                return
            }

            guard let data = data else {
                print("No data received")
                completion(false)
                return
            }

            do {
                let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                if let responseDict = responseJSON as? [String: Any], let success = responseDict["error"] as? Bool, !success {
                    print("Lesson updated successfully")
                    completion(true)
                } else {
                    print("Failed to update lesson")
                    completion(false)
                }
            } catch {
                print("Error decoding response: \(error.localizedDescription)")
                completion(false)
            }
        }.resume()
    }

    func reset() {
        loginData = nil
        errorMessage = nil
    }
}
