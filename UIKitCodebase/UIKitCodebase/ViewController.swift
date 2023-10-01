//
//  ViewController.swift
//  UIKitCodebase
//
//  Created by 김영빈 on 2023/09/20.
//

import UIKit
import AuthenticationServices
import CryptoKit
import FirebaseAuth

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
//        performExistingAccountSetupFlows()
    }
    
    // MARK: - 네비게이션 아이템 버튼 클릭 시 동작
    @objc func pressButton() {
        let secondView = SecondViewController()
        self.navigationController?.pushViewController(secondView, animated: true)
    }
    
    // MARK: - 애플 로그인 버튼
    func setSignInWithAppleButton() {
        let signInButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        signInButton.addTarget(self, action: #selector(startSignInWithAppleFlow), for: .touchUpInside)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(signInButton)
        signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    // MARK: - 애플 로그인 버튼 클릭 시 액션
//    @objc func pressSignInWithApple() {
//        // Apple ID 승인 요청 생성
//        let request = ASAuthorizationAppleIDProvider().createRequest()
//        request.requestedScopes = [.fullName, .email] // 이름과 이메일 정보를 요청
//
//        let controller = ASAuthorizationController(authorizationRequests: [request])
//        controller.delegate = self
//        controller.presentationContextProvider = self
//        controller.performRequests()
//    }
    
    // MARK: - 계정이 이미 승인된 적 있는 경우에 대한 플로우
//    func performExistingAccountSetupFlows() {
//        // Apple ID와 비밀번호에 대한 요청을 모두 준비
//        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
//                        ASAuthorizationPasswordProvider().createRequest()]
//
//        let controller = ASAuthorizationController(authorizationRequests: requests)
//        controller.delegate = self
//        controller.presentationContextProvider = self
//        controller.performRequests()
//    }
}

// Unhashed nonce.
fileprivate var currentNonce: String?
// MARK: - 승인 결과 처리 관련 델리게이트 프로토콜 구현
@available(iOS 13.0, *)
extension ViewController: ASAuthorizationControllerDelegate {
    // 로그인에 성공했으면 해시되지 않은 nonce가 포함된 Apple의 응답에서 ID 토큰을 사용하여 Firebase에 인증한다.
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
              fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
              print("Unable to fetch identity token")
              return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
              print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
              return
            }
            // Initialize a Firebase credential, including the user's full name.
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                           rawNonce: nonce,
                                                           fullName: appleIDCredential.fullName)
            print("fullName: \(appleIDCredential.fullName?.description ?? "None")")
            print("email: \(appleIDCredential.email ?? "None")")
            // 최초 로그인 시 Firebase를 사용한 Apple 로그인을 했다면 Auth.auth().currentUser를 통해 fullName, email 등을 받아올 수 있다.
            print("fullName: \(Auth.auth().currentUser?.displayName ?? "None")")
            print("email: \(Auth.auth().currentUser?.email ?? "None")")
            print("UUID: \(Auth.auth().currentUser?.uid ?? "None")")
            // Sign in with Firebase
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print("로그인 실패: \(error.localizedDescription)")
                    return
                }
                // User is signed in to Firebase with Apple.
                // 로그인 이후 화면으로 이동
                let secondView = SecondViewController()
                self.navigationController?.pushViewController(secondView, animated: true)
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}
//extension ViewController: ASAuthorizationControllerDelegate {
//    // (델리게이트 메소드) 승인 시 authorization을 리턴하는 메소드
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        let ud = UserDefaults.standard
//
//        switch authorization.credential {
//        case let appleIdCredential as ASAuthorizationAppleIDCredential:
//            print("Case 1 \(appleIdCredential.description)")
//            let userIdentifier = appleIdCredential.user
//            ud.set(userIdentifier, forKey: "userIdentifier")
//
//            // MARK: - 이메일 받기 -> 처음 애플 로그인 시 이메일은 appleIdCredential.email에 들어 있다.
//            if let email = appleIdCredential.email {
//                ud.set(email, forKey: "email")
//                print("이메일 : \(ud.string(forKey: "email") ?? "없음")")
//            }
//            // 두번째부터는 credential.email은 nil이고, appleIdCredential.identityToken을 통해 이메일을 불러온다.
//            else {
//                // appleIdCredential.identityToken은 jwt로 되어 있고, 해당 토큰을 decode 후 email에 접근해야 한다.
//                if let tokenString = String(data: appleIdCredential.identityToken ?? Data(), encoding: .utf8) {
//                    let email2 = Utils.decode(jwtToken: tokenString)["email"] as? String ?? ""
//                    ud.set(email2, forKey: "email")
//                    print("이메일 : \(ud.string(forKey: "email") ?? "없음")")
//                }
//            }
//            // MARK: - 이름 받기 -> 처음 애플 로그인 시 이름은 appleIdCredential.fullName에 들어 있다.
//            if let fullName = appleIdCredential.fullName {
//                ud.set(fullName.familyName ?? "", forKey: "familyName")
//                ud.set(fullName.givenName ?? "", forKey: "givenName")
//                print("이름 : \(fullName.familyName ?? "")\(fullName.givenName ?? "")")
//            }
//            else {
//                if let tokenString = String(data: appleIdCredential.identityToken ?? Data(), encoding: .utf8) {
//                    let fullName2 = Utils.decode(jwtToken: tokenString)["fullName"] as? String ?? ""
//                    print("이름 : \(fullName2)")
//                }
//            }
//
//            // 로그인 이후 화면으로 이동
//            let secondView = SecondViewController()
//            self.navigationController?.pushViewController(secondView, animated: true)
//
//            break
//        case let passwordCredential as ASPasswordCredential:
//            print("Case 2 \(passwordCredential.description)")
//            let username = passwordCredential.user
//            let password = passwordCredential.password
//            ud.set(username, forKey: "username")
//            ud.set(password, forKey: "password")
//
//            DispatchQueue.main.async {
//                self.showPasswordCredentialAlert(username: username, password: password)
//            }
//        default:
//            break
//        }
//    }
//
//    // (델리게이트 메소드) 인증 플로우가 정상적으로 끝나지 않았거나, credential이 존재하지 않을 때 호출
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//    }
//
//    // (델리게이트 메소드 X) 기존 계정 존재하는 경우 처리
//    private func showPasswordCredentialAlert(username: String, password: String) {
//        let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
//        let alertController = UIAlertController(title: "Keychain Credential Received",
//                                                message: message,
//                                                preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
//        self.present(alertController, animated: true)
//    }
//}

// MARK: - 로그인 UI 표시 관련 델리게이트 프로토콜 구현
extension ViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

// MARK: - Firebase 인증 관련 익스텐션
/// https://firebase.google.com/docs/auth/ios/apple?hl=ko 참고
extension ViewController {
    // MARK: - 애플 로그인 버튼 클릭 시
    @available(iOS 13, *)
    @objc func startSignInWithAppleFlow() {
        /// startSignInWithAppleFlow()에서 애플ID 인증값을 요청할 때 request에 nonce가 포함되서 전달된다. 이 nonce를 통해 FIrebase에서 무결성 검사를 수행함
      let nonce = randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
    }
    
    // MARK: - 암호로 보호된 nonce를 생성
    /// 로그인 요청마다 임의의 문자열인 'nonce'가 생성되며, 이 nonce는 앱의 인증 요청에 대한 응답으로 ID 토큰이 명시적으로 부여되었는지 확인하는 데 사용된다.
    /// 재전송 공격을 방지하려면 이 단계가 필요
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }

    /// 로그인 요청과 함께 nonce의 SHA256 해시를 전송하면 Apple은 이에 대한 응답으로 원래의 값을 전달합니다. Firebase는 원래의 nonce를 해싱하고 Apple에서 전달한 값과 비교하여 응답을 검증합니다.
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
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
