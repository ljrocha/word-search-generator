//
//  TextEntryViewController.swift
//  WordSearchGenerator
//
//  Created by Leandro Rocha on 3/6/20.
//  Copyright © 2020 Leandro Rocha. All rights reserved.
//

import UIKit

class TextEntryViewController: UIViewController {

    let textField = WSTextField()
    var doneButtonItem: UIBarButtonItem!
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        createDismissKeyboardTapGesture()
        configureTextField()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        textField.resignFirstResponder()
    }
    
    // MARK: - Configuration methods
    func configureViewController() {
        view.backgroundColor = .systemBackground
            
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.rightBarButtonItem = doneButtonItem
    }
    
    func createDismissKeyboardTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func configureTextField() {
        view.addSubview(textField)
        
        textField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        textField.addTarget(self, action: #selector(done), for: .primaryActionTriggered)
        
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    // MARK: - Action methods
    @objc func cancel() {}
    
    @objc func done() {}
    
    @objc func textChanged(_ textField: UITextField) {}
    
}
