//
//  AddMealViewController.swift
//  vegana
//
//  Created by DongUk Kim on 2022/01/07.
//  Copyright © 2022 VEGANA. All rights reserved.
//

import UIKit

class AddMealViewController: UIViewController {
    let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        return v
    }()
    
    let challengeDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Day + 22"
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUIs()
        setupMealView()
    }
    
    func setupUIs() {
        view.backgroundColor = .white
        
        let topLineView: UIView = UIView(frame: .zero)
        topLineView.backgroundColor = .darkGray
        topLineView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topLineView)
        
        topLineView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive = true
        topLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
        topLineView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
        topLineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        let handleViewWidth = view.frame.size.width * 0.15
        let handleView: UIView = UIView(frame: .zero)
        handleView.backgroundColor = .lightGray
        handleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(handleView)
        
        handleView.topAnchor.constraint(equalTo: topLineView.bottomAnchor, constant: 12.0).isActive = true
        handleView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        handleView.widthAnchor.constraint(equalToConstant: (handleViewWidth / 2)).isActive = true
        handleView.heightAnchor.constraint(equalToConstant: 3.0).isActive = true
    }
    
    func setupMealView() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
        
        scrollView.addSubview(challengeDateLabel)
        challengeDateLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 12.0).isActive = true
        challengeDateLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0.0).isActive = true
        challengeDateLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0.0).isActive = true
        challengeDateLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        
//        let mealView: UIView = UIView(frame: .zero)
    }
}
