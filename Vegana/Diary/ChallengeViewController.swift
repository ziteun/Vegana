//
//  ChallengeViewController.swift
//  vegana
//
//  Created by DongUk Kim on 2022/01/07.
//  Copyright © 2022 VEGANA. All rights reserved.
//

import UIKit
import Firebase

class ChallengeViewController: UIViewController {
    var user: User?
    
    let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .cyan
        return v
    }()
    
    let challengeTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "채식을 도전 해보세요!"
        label.backgroundColor = .red
        return label
    }()
    
    let scrollEndLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "스크롤 끝"
        label.backgroundColor = .green
        return label
    }()
    
    let goDiaryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("다이어리 쓰러 가기(클릭)", for: UIControl.State.normal)
        button.setTitleColor(.black, for: UIControl.State.normal)
        button.addTarget(self, action: #selector(showDiaryController), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
        setupUIs()
        fetchUser()
    }
    
    func setupNavigationItems() {
        // 네비게이션 텍스트
        navigationItem.title = "도전"
    }
    
    func setupUIs() {
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(scrollView)
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0.0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0.0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
        
        scrollView.addSubview(challengeTitleLabel)
        challengeTitleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0.0).isActive = true
        challengeTitleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0.0).isActive = true
        
        scrollView.addSubview(goDiaryButton)
        goDiaryButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0.0).isActive = true
        goDiaryButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 100.0).isActive = true
        
        scrollView.addSubview(scrollEndLabel)
        scrollEndLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0.0).isActive = true
        scrollEndLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 1000).isActive = true
        scrollEndLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16.0).isActive = true
    }
    
    @objc
    private func showDiaryController() {
        let diaryController = DiaryViewController()
        diaryController.navigationItem.title = self.user?.username ?? "" + "의 채식일기"
        diaryController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(diaryController, animated: true)
    }
    
    private func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.user = user
        }
    }
}
