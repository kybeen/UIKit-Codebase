//
//  FirebaseViewController.swift
//  UIKitCodebase
//
//  Created by 김영빈 on 2023/10/05.
//

import UIKit
import FirebaseDatabase

class FirebaseViewController: UIViewController {
    
    var ref: DatabaseReference!
    
    let tf = UITextField()
    let addButton = UIButton()
    let deleteButton = UIButton()
    let dataLabel = UILabel()
    
    override func viewDidLoad() {
        self.view.backgroundColor = .systemBackground
        
        ref = Database.database().reference()
        
        readFirebaseData()
        setTextField()
        setAddButton()
        setDeleteButton()
        setDataLabel()
        
        NSLayoutConstraint.activate([
            tf.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tf.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addButton.topAnchor.constraint(equalTo: tf.bottomAnchor, constant: 20),
            
            deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            deleteButton.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 20),
            
            dataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dataLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }
    
    func readFirebaseData() {
        // MARK: - 데이터 읽기
        ref.child("addValues/newValue").getData { (error, snapshot) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            self.dataLabel.text = snapshot?.value as? String ?? "Unknown"
        }
    }
    func setTextField() {
        tf.placeholder = "값을 입력하세요."
        tf.enablesReturnKeyAutomatically = true
        tf.textColor = .black
        
        tf.borderStyle = UITextField.BorderStyle.line
        tf.backgroundColor = UIColor(white: 0.87, alpha: 1.0) // 배경 색상
        tf.contentVerticalAlignment = .center // 텍스트가 수직 방향으로 가운데 정렬
        tf.contentHorizontalAlignment = .center // 텍스트가 수평 방향으로 가운데 정렬
        tf.layer.borderColor = UIColor.darkGray.cgColor // 테두리 색상을 회색으로 (텍스트 필드 테두리 색상은 UIColor보다 저수준에서 구현된 CGColor 타입의 값을 사용하기 때문에 CGColor 타입으로 변환해준다.)
        tf.layer.borderWidth = 2.0 // 테두리 두께 설정 (단위 : pt)
        
        tf.delegate = self
        tf.clearButtonMode = .whileEditing
        tf.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tf)
    }
    func setAddButton() {
        addButton.setTitle("값 추가하기", for: .normal)
        addButton.setTitleColor(.tintColor, for: .normal)
        addButton.addTarget(self, action: #selector(addToFirebase), for: .touchUpInside)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(addButton)
    }
    @objc func addToFirebase() {
        // MARK: - 데이터 쓰기
        let newValue = tf.text ?? ""
        ref.child("addValues").setValue(["newValue": newValue])
        print("추가된 값: \(newValue)")
    }
    func setDeleteButton() {
        deleteButton.setTitle("값 삭제하기", for: .normal)
        deleteButton.setTitleColor(.systemRed, for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteFromFirebase), for: .touchUpInside)
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(deleteButton)
    }
    @objc func deleteFromFirebase() {
        // MARK: - 데이터 삭제
//        ref.child("addVelues").removeValue()
        ref.child("addValues").setValue(["newValue": nil])
    }
    func setDataLabel() {
        dataLabel.backgroundColor = .systemPink
        dataLabel.text = "데이터: "
        
        dataLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(dataLabel)
    }
}

extension FirebaseViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Preview canvas 세팅
import SwiftUI

struct FirebaseViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = FirebaseViewController
    
    func makeUIViewController(context: Context) -> FirebaseViewController {
        return FirebaseViewController()
    }
    
    func updateUIViewController(_ uiViewController: FirebaseViewController, context: Context) {
    }
}

@available(iOS 13.0.0, *)
struct FirebaseViewPreview: PreviewProvider {
    static var previews: some View {
        FirebaseViewControllerRepresentable()
    }
}
