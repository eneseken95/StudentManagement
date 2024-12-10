//
//  Models.swift
//  StudentManagement
//
//  Created by Enes Eken 2 on 9.12.2024.
//

import Foundation

enum Role: String, Decodable {
    case student
    case teacher
    case admin
}

struct LoginModel: Decodable, Equatable {
    let id: Int
    let userName: String
    let password: String
    let role: Role
}

struct LoginResponse: Decodable {
    let error: Bool
    let message: String
    let data: LoginModel
}
