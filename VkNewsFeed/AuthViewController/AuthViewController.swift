//
//  ViewController.swift
//  VkNewsFeed
//
//  Created by Данил Дубов on 15.09.2021.
//

import UIKit

class AuthViewController: UIViewController {

    private var authService: AuthService!

    override func viewDidLoad() {
        super.viewDidLoad()

        authService = SceneDelegate.shared().authService
        view.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
    }

    @IBAction func signinTouch(_ sender: UIButton) {
        authService.wakeUpSession()
    }

}
