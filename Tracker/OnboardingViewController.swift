//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Pavel Belenkow on 30.07.2023.
//

import UIKit

// MARK: - Constants enum

private enum Constants {
    static let firstPageTitle = "Отслеживайте только то, что хотите"
    static let secondPageTitle = "Даже если это не литры воды и йога"
    static let trackersScreenButtonTitle = "Вот это технологии!"
}

//MARK: - OnboardingViewController Class

final class OnboardingViewController: UIPageViewController {
    
    //MARK: - Properties
    
    private lazy var pages: [UIViewController] = {
        let firstPage = UIViewController()
        firstPage.configure(with: UIImage.TrackerImage.onboardingFirstPage,
                            and: Constants.firstPageTitle)
        
        let secondPage = UIViewController()
        secondPage.configure(with: UIImage.TrackerImage.onboardingSecondPage,
                             and: Constants.secondPageTitle)
        return [firstPage, secondPage]
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 24
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.numberOfPages = pages.count
        control.currentPage = 0
        
        control.currentPageIndicatorTintColor = UIColor.TrackerColor.black
        control.pageIndicatorTintColor = UIColor.TrackerColor.black.withAlphaComponent(0.3)
        
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private lazy var trackersScreenButton: UIButton = {
        let button = UIButton(type: .system)
        button.configure(with: .standardButton, for: Constants.trackersScreenButtonTitle)
        button.addTarget(self, action: #selector(goToTrackersScreen), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initializers
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        setFirstPage()
        addPageControlAndButtonToStackView()
    }
}

//MARK: - Private methods

private extension OnboardingViewController {
    
    func setFirstPage() {
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true)
        }
    }
    
    func addPageControlAndButtonToStackView() {
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(pageControl)
        stackView.addArrangedSubview(trackersScreenButton)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
    }
    
    @objc func goToTrackersScreen() {
        let tabBarController = TabBarController()
        
        let window = UIApplication.shared.windows.first
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}

//MARK: - UIPageViewControllerDataSource

extension OnboardingViewController: UIPageViewControllerDataSource {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return pages.last
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else {
            return pages.first
        }
        
        return pages[nextIndex]
    }
}

//MARK: - UIPageViewControllerDelegate

extension OnboardingViewController: UIPageViewControllerDelegate {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
