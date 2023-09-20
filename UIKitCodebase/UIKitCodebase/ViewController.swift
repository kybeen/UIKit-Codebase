//
//  ViewController.swift
//  UIKitCodebase
//
//  Created by 김영빈 on 2023/09/20.
//

import UIKit

class ViewController: UIViewController {
    var firstLabel = UILabel()
    
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        /// view : 현재 뷰 컨트롤러가 관리하는 뷰
        self.view.backgroundColor = .white
        
        self.navigationItem.title = "FirstViewController"
        let rightButton = UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(pressButton))
        navigationItem.rightBarButtonItem = rightButton
        setLabel()
    }
    
    // MARK: - 뷰 세팅
    func setLabel() {
        view.addSubview(firstLabel) // 뷰에 Label 추가
        
        firstLabel.text = "류트 뷰"
        firstLabel.translatesAutoresizingMaskIntoConstraints = false // 오토 레이아웃 제약 적용
        // 가운데 정렬
        firstLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        firstLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    // MARK: - 네비게이션 아이템 버튼 클릭 시 동작
    @objc func pressButton() {
        let secondView = SecondViewController()
        self.navigationController?.pushViewController(secondView, animated: true)
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
