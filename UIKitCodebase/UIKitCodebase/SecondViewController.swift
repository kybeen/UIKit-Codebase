//
//  SecondViewController.swift
//  UIKitCodebase
//
//  Created by 김영빈 on 2023/09/20.
//

import UIKit

class SecondViewController: UIViewController {
    let secondLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .orange
        self.navigationItem.title = "SecondViewController"
        
        secondLabel.text = "두번째 뷰 컨트롤러"
        secondLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(secondLabel)
        secondLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        secondLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        
        setBackButton()
        setLabelChangeButton()
    }
    
    // MARK: - 뒤로가기 버튼
    func setBackButton() {
        let backButton = UIButton()
        
        backButton.setTitle("뒤로가기", for: .normal)
        backButton.addTarget(self, action: #selector(pressBackButton), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(backButton)
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
    }
    @objc func pressBackButton() {
        print("뒤로가기 클릭!!!")
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - 텍스트 변경 버튼
    func setLabelChangeButton() {
        let labelChangeButton = UIButton()
        
        labelChangeButton.setTitle("클릭해보세요", for: .normal)
        labelChangeButton.addTarget(self, action: #selector(pressLabelChangeButton), for: .touchUpInside)
        labelChangeButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(labelChangeButton)
        labelChangeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelChangeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    @objc func pressLabelChangeButton() {
        print("[클릭해보세요] 클릭!!")
        if self.secondLabel.text == "잘하셨어요🌞" {
            self.secondLabel.text = "Good🌝"
        } else {
            self.secondLabel.text = "잘하셨어요🌞"
        }
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
