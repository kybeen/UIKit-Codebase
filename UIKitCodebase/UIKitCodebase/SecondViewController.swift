//
//  SecondViewController.swift
//  UIKitCodebase
//
//  Created by 김영빈 on 2023/09/20.
//

import UIKit
import FirebaseAuth

class SecondViewController: UIViewController {
    let secondLabel = UILabel()
    let userIdentifierLabel = UILabel()
    let fullnameLabel = UILabel()
    let emailLabel = UILabel()
    let userNameLabael = UILabel()
    let passwordLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .gray
        self.navigationItem.title = "SecondViewController"
        
        secondLabel.text = "로그인 결과 확인"
        secondLabel.font = .boldSystemFont(ofSize: 20)
        secondLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(secondLabel)
        secondLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 190).isActive = true
        secondLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.commitChanges { _ in
            let uuid = Auth.auth().currentUser?.uid ?? ""
            let displayName = Auth.auth().currentUser?.displayName ?? ""
            let email = Auth.auth().currentUser?.email ?? ""
            print(displayName)
            self.fullnameLabel.text = "환영합니다. \(displayName)님"
            self.emailLabel.text = "email: \(email)"
            self.userIdentifierLabel.text = "UserIdentifier: \(uuid)"
        }
        userIdentifierLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(userIdentifierLabel)
        userIdentifierLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 220).isActive = true
        userIdentifierLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        
        fullnameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(fullnameLabel)
        fullnameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 260).isActive = true
        fullnameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true

        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(emailLabel)
        emailLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 280).isActive = true
        emailLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        
//        userNameLabael.text = "Username"
//        userNameLabael.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addSubview(userNameLabael)
//        userNameLabael.topAnchor.constraint(equalTo: view.topAnchor, constant: 300).isActive = true
//        userNameLabael.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
//
//        passwordLabel.text = "Password"
//        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addSubview(passwordLabel)
//        passwordLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 320).isActive = true
//        passwordLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        
//        setBackButton()
        signOutButton()
        setLoginResult()
    }
    
    // MARK: - 뒤로가기 버튼
//    func setBackButton() {
//        let backButton = UIButton()
//
//        backButton.setTitle("뒤로가기", for: .normal)
//        backButton.addTarget(self, action: #selector(pressBackButton), for: .touchUpInside)
//        backButton.translatesAutoresizingMaskIntoConstraints = false
//
//        self.view.addSubview(backButton)
//        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
//        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
//    }
//    @objc func pressBackButton() {
//        print("뒤로가기 클릭!!!")
//        self.navigationController?.popViewController(animated: true)
//    }
    
    // MARK: - 로그아웃 버튼
    func signOutButton() {
        let signOutButton = UIButton()
        
        signOutButton.setTitle("로그아웃", for: .normal)
        signOutButton.setTitleColor(.red, for: .normal)
        signOutButton.addTarget(self, action: #selector(pressSignOutButton), for: .touchUpInside)
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(signOutButton)
        signOutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        signOutButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 200).isActive = true
    }
    @objc func pressSignOutButton() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        print("로그아웃 되었습니다!! - \(Auth.auth().currentUser)")
        print("로그인 화면으로 되돌아갑니다!!")
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - 로그인 결과 세팅
    func setLoginResult() {
        let ud = UserDefaults.standard
        
        if let userIdentifier = ud.string(forKey: "userIdentifier") {
            userIdentifierLabel.text = "UserIdentifier: " + userIdentifier
        }
        
        var givenNameLabelValue = ""
        var familyNameLabelValue = ""
        if let givenName = ud.string(forKey: "givenName") {
            givenNameLabelValue = givenName
        }
        if let familyName = ud.string(forKey: "familyName") {
            familyNameLabelValue = familyName
        }
        if let email = ud.string(forKey: "email") {
            emailLabel.text = "Email: " + email
        }
        if let username = ud.string(forKey: "username") {
            userNameLabael.text = "Username: " + username
        }
        if let password = ud.string(forKey: "password") {
            passwordLabel.text = "Password: " + password
        }
        
        fullnameLabel.text = "Fullname: " + givenNameLabelValue + familyNameLabelValue
    }
}






// MARK: - Preview canvas 세팅
import SwiftUI

struct SecondViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = SecondViewController
    
    func makeUIViewController(context: Context) -> SecondViewController {
        return SecondViewController()
    }
    
    func updateUIViewController(_ uiViewController: SecondViewController, context: Context) {
    }
}

@available(iOS 13.0.0, *)
struct SecondViewPreview: PreviewProvider {
    static var previews: some View {
        SecondViewControllerRepresentable()
    }
}
