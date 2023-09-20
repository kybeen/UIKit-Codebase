//
//  ViewController.swift
//  UIKitCodebase
//
//  Created by 김영빈 on 2023/09/20.
//

import UIKit
import AuthenticationServices

class ViewController: UIViewController {
    
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        /// view : 현재 뷰 컨트롤러가 관리하는 뷰
        self.view.backgroundColor = .white
        
        self.navigationItem.title = "FirstViewController"
        let rightButton = UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(pressButton))
        navigationItem.rightBarButtonItem = rightButton
        
        let firstLabel = UILabel()
        firstLabel.text = "류트 뷰 - 로그인"
        
        view.addSubview(firstLabel) // 뷰에 Label 추가
        firstLabel.translatesAutoresizingMaskIntoConstraints = false // 오토 레이아웃 제약 적용
        // 가운데 정렬
        firstLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        firstLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        setSignInWithAppleButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performExistingAccountSetupFlows()
    }
    
    // MARK: - 네비게이션 아이템 버튼 클릭 시 동작
    @objc func pressButton() {
        let secondView = SecondViewController()
        self.navigationController?.pushViewController(secondView, animated: true)
    }
    
    // MARK: - 애플 로그인 버튼
    func setSignInWithAppleButton() {
        let signInButton = ASAuthorizationAppleIDButton()
        signInButton.addTarget(self, action: #selector(pressSignInWithApple), for: .touchUpInside)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(signInButton)
        signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    // MARK: - 애플 로그인 버튼 클릭 시 액션
    @objc func pressSignInWithApple() {
        // Apple ID 승인 요청 생성
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email] // 이름과 이메일 정보를 요청
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    // MARK: - 계정이 이미 승인된 적 있는 경우에 대한 플로우
    func performExistingAccountSetupFlows() {
        // Apple ID와 비밀번호에 대한 요청을 모두 준비
        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                        ASAuthorizationPasswordProvider().createRequest()]
        
        let controller = ASAuthorizationController(authorizationRequests: requests)
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}

// MARK: - 승인 결과 처리 관련 델리게이트 프로토콜 구현
extension ViewController: ASAuthorizationControllerDelegate {
    // (델리게이트 메소드) 승인 시 authorization을 리턴하는 메소드
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        let ud = UserDefaults.standard
        
        switch authorization.credential {
        case let appleIdCredential as ASAuthorizationAppleIDCredential:
            print("Case 1 \(appleIdCredential.description)")
            let userIdentifier = appleIdCredential.user
            ud.set(userIdentifier, forKey: "userIdentifier")
            if let givenName = appleIdCredential.fullName?.givenName {
                ud.set(givenName, forKey: "givenName")
            }
            if let familyName = appleIdCredential.fullName?.familyName {
                ud.set(familyName, forKey: "familyName")
            }
            if let email = appleIdCredential.email {
                ud.set(email, forKey: "email")
            }
            
            // 앱 상에 UserIdentifier를 저장
            break
        case let passwordCredential as ASPasswordCredential:
            print("Case 2 \(passwordCredential.description)")
            let username = passwordCredential.user
            let password = passwordCredential.password
            ud.set(username, forKey: "username")
            ud.set(password, forKey: "password")
            
            DispatchQueue.main.async {
                self.showPasswordCredentialAlert(username: username, password: password)
            }
        default:
            break
        }
    }
    
    // (델리게이트 메소드) 인증 플로우가 정상적으로 끝나지 않았거나, credential이 존재하지 않을 때 호출
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    }
    
    // (델리게이트 메소드 X) 기존 계정 존재하는 경우 처리
    private func showPasswordCredentialAlert(username: String, password: String) {
        let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
        let alertController = UIAlertController(title: "Keychain Credential Received",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        self.present(alertController, animated: true)
    }
}

// MARK: - 승인 UI 표시 관련 델리게이트 프로토콜 구현
extension ViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}


// MARK: - Preview canvas 세팅
import SwiftUI

struct ViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = ViewController
    
    func makeUIViewController(context: Context) -> ViewController {
        return ViewController()
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
    }
}

@available(iOS 13.0.0, *)
struct ViewPreview: PreviewProvider {
    static var previews: some View {
        ViewControllerRepresentable()
    }
}
