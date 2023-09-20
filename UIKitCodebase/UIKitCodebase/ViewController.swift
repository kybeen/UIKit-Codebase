//
//  ViewController.swift
//  UIKitCodebase
//
//  Created by 김영빈 on 2023/09/20.
//

import UIKit

class ViewController: UIViewController {
    
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setLabel()
    }
    
    func setLabel() {
        let rootLabel = UILabel()
        /// view : 현재 뷰 컨트롤러가 관리하는 뷰
        view.backgroundColor = .white
        view.addSubview(rootLabel) // 뷰에 Label 추가
        
        rootLabel.text = "류트 뷰"
        rootLabel.translatesAutoresizingMaskIntoConstraints = false
        // 가운데 정렬
        rootLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        rootLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

