//
//  MealViewController.swift
//  vegana
//
//  Created by DongUk Kim on 2022/01/07.
//  Copyright © 2022 VEGANA. All rights reserved.
//

import UIKit

class MealViewController: UIViewController {
    weak var delegate: AddMealDelegate?
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let topLineView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkGray
        return view
    }()
    
    let topHandleView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    let challengeDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Day + 22"
        label.backgroundColor = .clear
        label.textColor = .black
        return label
    }()
    
    let mealView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .yellow
        return view
    }()
    
    let mealAddButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(mealAddButtonAction), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUIs()
        self.setupMealView()
    }
    
    func setupUIs() {
        self.view.backgroundColor = .white
    }
    
    func setupMealView() {
        self.view.addSubview(self.scrollView)
        self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0).isActive = true
        self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0.0).isActive = true
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let topPadding = window?.safeAreaInsets.top ?? 0
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0
        let totalPadding = statusBarHeight + topPadding + bottomPadding
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -totalPadding).isActive = true
        
        self.scrollView.addSubview(self.topLineView)
        self.topLineView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 0.0).isActive = true
        self.topLineView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor, constant: 0.0).isActive = true
        self.topLineView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 0.0).isActive = true
        self.topLineView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: 0.0).isActive = true
        self.topLineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        self.scrollView.addSubview(self.topHandleView)
        self.topHandleView.topAnchor.constraint(equalTo: self.topLineView.bottomAnchor, constant: 12.0).isActive = true
        self.topHandleView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        let handleViewWidth = self.view.frame.size.width * 0.17
        self.topHandleView.widthAnchor.constraint(equalToConstant: (handleViewWidth / 2)).isActive = true
        self.topHandleView.heightAnchor.constraint(equalToConstant: 3.0).isActive = true
        
        self.scrollView.addSubview(self.challengeDateLabel)
        self.challengeDateLabel.topAnchor.constraint(equalTo: self.topHandleView.bottomAnchor, constant: 12.0).isActive = true
        self.challengeDateLabel.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor, constant: 0.0).isActive = true
        self.challengeDateLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        self.scrollView.addSubview(self.mealView)
        self.mealView.topAnchor.constraint(equalTo: self.challengeDateLabel.bottomAnchor, constant: 12.0).isActive = true
        self.mealView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor, constant: 0.0).isActive = true
        self.mealView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 12.0).isActive = true
        self.mealView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -12.0).isActive = true
        let mealViewHeight = self.view.frame.size.width * 0.7
        self.mealView.heightAnchor.constraint(equalToConstant: mealViewHeight).isActive = true
        
        self.mealView.addSubview(self.mealAddButton)
        self.mealAddButton.centerXAnchor.constraint(equalTo: self.mealView.centerXAnchor, constant: 0.0).isActive = true
        self.mealAddButton.centerYAnchor.constraint(equalTo: self.mealView.centerYAnchor, constant: 0.0).isActive = true
        self.mealAddButton.widthAnchor.constraint(equalTo: self.mealView.widthAnchor, constant: 0.0).isActive = true
        self.mealAddButton.heightAnchor.constraint(equalTo: self.mealView.heightAnchor, constant: 0.0).isActive = true
        
        self.scrollView.resizeScrollViewContentSize()
    }
    
    @objc
    private func mealAddButtonAction() {
        self.delegate?.addMeal("")
    }
}
