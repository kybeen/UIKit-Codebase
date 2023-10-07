//
//  StackViewController.swift
//  UIKitCodebase
//
//  Created by 김영빈 on 2023/10/01.
//

import UIKit

class StackViewController: UIViewController {
    let gradientView = UIView()
    let gradient = CAGradientLayer()
    lazy var homeImage: UIImageView = {
        let homeImage = UIImageView()
        homeImage.translatesAutoresizingMaskIntoConstraints = false
        homeImage.image = UIImage(named: "test")
        return homeImage
    }()
    lazy var cardButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setTitle("카드버튼", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(pressBtn), for: .touchUpInside)
        return button
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "제목 라벨입니다람쥐"
        label.textColor = .white
        return label
    }()
    lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        return stack
    }()
    @objc func pressBtn() {
        print("버튼누름")
    }
    func setupLayout() {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(homeImage)
        
        gradientView.backgroundColor = .red
        gradientView.layer.cornerRadius = 16
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gradientView)
        
        gradient.colors = [UIColor.purple.cgColor, UIColor.green.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.7)
        gradientView.layer.addSublayer(gradient)
        
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(cardButton)
        
        contentView.addSubview(contentStack)
        
        view.backgroundColor = .systemMint
        view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150.0),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -400.0),
            
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            
            homeImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            homeImage.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            homeImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            homeImage.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            
            contentStack.leadingAnchor.constraint(equalTo: homeImage.leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: homeImage.trailingAnchor, constant: -20),
            contentView.bottomAnchor.constraint(equalTo: homeImage.bottomAnchor, constant: -20),
            
            cardButton.heightAnchor.constraint(equalToConstant: 60),
            
            gradientView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gradientView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            gradientView.widthAnchor.constraint(equalToConstant: 100),
            gradientView.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
    }
    override func viewDidLayoutSubviews() {
        gradient.frame = gradientView.bounds
    }
}

// MARK: - Preview canvas 세팅
import SwiftUI

struct StackViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = StackViewController
    
    func makeUIViewController(context: Context) -> StackViewController {
        return StackViewController()
    }
    
    func updateUIViewController(_ uiViewController: StackViewController, context: Context) {
    }
}

@available(iOS 13.0.0, *)
struct StackViewPreview: PreviewProvider {
    static var previews: some View {
        StackViewControllerRepresentable()
    }
}

