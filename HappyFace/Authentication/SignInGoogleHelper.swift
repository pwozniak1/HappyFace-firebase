//
//  SignInGoogleHelper.swift
//  HappyFace
//
//  Created by Piotr Woźniak on 26/08/2023.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift

struct GoogleSignInResultModel {
    let idToken: String
    let accessToken: String
    let name: String?
    let email: String?
}

final class SignInGoogleHelper {
    
    @MainActor
    func signIn() async throws -> GoogleSignInResultModel {
        guard let topVC = Utilities.shared.topViewController() else {
            throw URLError(.cannotFindHost)
        }
        
        let gidSigningResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        guard let idToken = gidSigningResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        let name = gidSigningResult.user.profile?.name
        let email = gidSigningResult.user.profile?.email
        let accessToken = gidSigningResult.user.accessToken.tokenString
        
        let tokens = GoogleSignInResultModel(idToken: idToken, accessToken: accessToken, name: name, email: email)
        
        return tokens
    }
}


