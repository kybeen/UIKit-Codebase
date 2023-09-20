//
//  SecondViewController.swift
//  UIKitCodebase
//
//  Created by 김영빈 on 2023/09/20.
//

import UIKit

class SecondViewController: UIViewController {
    let secondLabel = UILabel()
    let userIdentifierLabel = UILabel()
    let fullnameLabel = UILabel()
    let emailLabel = UILabel()
    let userNameLabael = UILabel()
    let passwordLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .orange
        self.navigationItem.title = "SecondViewController"
        
        secondLabel.text = "로그인 결과 확인"
        secondLabel.font = .boldSystemFont(ofSize: 20)
        secondLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(secondLabel)
        secondLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 190).isActive = true
        secondLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        
        userIdentifierLabel.text = "UserIdentifier"
        userIdentifierLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(userIdentifierLabel)
        userIdentifierLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 220).isActive = true
        userIdentifierLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        
        fullnameLabel.text = "FullName"
        fullnameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(fullnameLabel)
        fullnameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 240).isActive = true
        fullnameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        
        emailLabel.text = "Email"
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(emailLabel)
        emailLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 260).isActive = true
        emailLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        
        userNameLabael.text = "Username"
        userNameLabael.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(userNameLabael)
        userNameLabael.topAnchor.constraint(equalTo: view.topAnchor, constant: 300).isActive = true
        userNameLabael.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        
        passwordLabel.text = "Password"
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(passwordLabel)
        passwordLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 320).isActive = true
        passwordLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        
        setBackButton()
        setLoginResult()
    }
    
    // MARK: - 뒤로가기 버튼
    func setBackButton() {
        let backButton = UIButton()
        
        backButton.setTitle("뒤로가기", for: .normal)
        backButton.addTarget(self, action: #selector(pressBackButton), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(backButton)
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
    }
    @objc func pressBackButton() {
        print("뒤로가기 클릭!!!")
        self.navigationController?.popViewController(animated: true)
    }
    
//    // MARK: - 텍스트 변경 버튼
//    func setLabelChangeButton() {
//        let labelChangeButton = UIButton()
//
//        labelChangeButton.setTitle("[클릭해보세요]", for: .normal)
//        labelChangeButton.addTarget(self, action: #selector(pressLabelChangeButton), for: .touchUpInside)
//        labelChangeButton.translatesAutoresizingMaskIntoConstraints = false
//
//        self.view.addSubview(labelChangeButton)
//        labelChangeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
//        labelChangeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 200).isActive = true
//    }
//    @objc func pressLabelChangeButton() {
//        print("[클릭해보세요] 클릭!!")
//        if self.secondLabel.text == "잘하셨어요🌝" {
//            self.secondLabel.text = "Good🌚"
//        } else {
//            self.secondLabel.text = "잘하셨어요🌝"
//        }
//    }
    
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
