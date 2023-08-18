//
//  StatisticsCell.swift
//  Tracker
//
//  Created by Pavel Belenkow on 15.08.2023.
//

import UIKit

// MARK: - StatisticsCell class

final class StatisticsCell: UICollectionViewCell {

    // MARK: - Properties

    static let reuseIdentifier = "statistics"

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.TrackerColor.white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var verticalStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = 7
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.TrackerColor.black
        label.font = UIFont.TrackerFont.bold34
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.TrackerColor.black
        label.font = UIFont.TrackerFont.medium12
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var gradientBorderLayer: CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = contentView.bounds
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.colors = [
            UIColor.TrackerColor.colorSelection1.cgColor,
            UIColor.TrackerColor.colorSelection9.cgColor,
            UIColor.TrackerColor.colorSelection3.cgColor
        ]
        return layer
    }

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 16
        layer.insertSublayer(gradientBorderLayer, at: 0)
        clipsToBounds = true
        
        addContainerView()
        addVerticalStackView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func configure(with title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
}

// MARK: - Add Subviews

private extension StatisticsCell {

    func addContainerView() {
        contentView.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 1),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -1)
        ])
    }

    func addVerticalStackView() {
        containerView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            verticalStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            verticalStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            verticalStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12)
        ])
    }
}
