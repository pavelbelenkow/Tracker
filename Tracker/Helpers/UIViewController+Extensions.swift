//
//  UIViewController+Extensions.swift
//  Tracker
//
//  Created by Pavel Belenkow on 30.07.2023.
//

import UIKit

extension UIViewController {
    
    func configure(with image: UIImage?, and text: String) {
        let backgroundImage = UIImageView(image: image)
        
        let title = UILabel()
        title.text = text
        title.textAlignment = .center
        title.textColor = UIColor.TrackerColor.black
        title.font = UIFont.TrackerFont.bold32
        title.numberOfLines = 0
        
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backgroundImage)
        view.addSubview(title)
        
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            title.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            title.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            title.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            title.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}
