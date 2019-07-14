//
//  RestaurantDetailViewController.swift
//  Foodie
//
//  Created by parul vats on 14/07/2019.
//  Copyright © 2019 SmartSum. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var ratingComparisonLabel: UILabel! {
        didSet {
            ratingComparisonLabel.font = Fonts.regular(.small)
            ratingComparisonLabel.text = "/10"
            ratingComparisonLabel.isHidden = true
        }
    }
    
    @IBOutlet weak var webUrlTextView: UITextView! {
        didSet {
            webUrlTextView.font = Fonts.condensed(.small)
            webUrlTextView.translatesAutoresizingMaskIntoConstraints = false
            webUrlTextView.isScrollEnabled = false
        }
    }
    
    @IBOutlet weak var ratingLabel: UILabel! {
        didSet {
            ratingLabel.font = Fonts.condensed(.medium)
        }
    }
    
    @IBOutlet weak var openCloseLabel: UILabel! {
        didSet {
            openCloseLabel.font = Fonts.condensed(.medium)
        }
    }
    
    @IBOutlet weak var statusLabel: UILabel! {
        didSet {
            statusLabel.font = Fonts.condensed(.small)
        }
    }
    
    @IBOutlet weak var restaurantAddressLabel: UILabel! {
        didSet {
            restaurantAddressLabel.font = Fonts.condensed(.small)
        }
    }
    
    @IBOutlet weak var restaurantDescription: UILabel! {
        didSet {
            restaurantDescription.font = Fonts.condensed(.small)
        }
    }
    
    @IBOutlet weak var detailView: UIView! {
        didSet {
            detailView.layer.cornerRadius = 15
        }
    }
    
    @IBOutlet weak var restaurantName: UILabel! {
        didSet {
            restaurantName.font = Fonts.condensed(.xLarge)
            restaurantName.textColor = .white
            restaurantName.text = restaurantBasicInfo.name
        }
    }
    
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    // MARK: - variables
    private var restaurantBasicInfo: Restaurant!
    private var apiService: APIServiceProtocol!
    
    lazy var restaurantDetailViewModel: RestaurantDetailViewModel = {
        return RestaurantDetailViewModel(restaurant: self.restaurantBasicInfo, apiService: apiService)
    }()
    
    // MARK: - init
    init(restaurant: Restaurant, apiService: APIServiceProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.restaurantBasicInfo = restaurant
        self.apiService = apiService
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.foodiePink
        // Do any additional setup after loading the view.
        bindViewModel()
    }
    
    func bindViewModel() {
        restaurantDetailViewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.restaurantDetailViewModel.alertMessage {
                    self?.showAlert(title: "Alert", message: message)
                }
            }
        }
        
        restaurantDetailViewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.restaurantDetailViewModel.isLoading ?? false
                if isLoading {
                    self?.loadingActivityIndicator.startAnimating()
                }else {
                    self?.loadingActivityIndicator.stopAnimating()
                }
            }
        }
        
        restaurantDetailViewModel.loadRestaurantDetails = { [weak self] () in
            DispatchQueue.main.async {
                // update UI
                self?.updateDetails()
            }
        }
        restaurantDetailViewModel.fetchRestaurantDetail(restaurantBasicInfo.id)
    }
    
    // MARK: - methods
    func updateDetails() {
        let closeOpenLabelData = restaurantDetailViewModel.getOpenCloseLabelData()
        self.openCloseLabel.text = closeOpenLabelData.0
        self.openCloseLabel.textColor = closeOpenLabelData.1
        self.restaurantAddressLabel.text = restaurantDetailViewModel.getRestaurantAddress()
        self.statusLabel.text = restaurantDetailViewModel.getStatusLabelText()
        self.webUrlTextView.text = restaurantDetailViewModel.getWebUrl()
        self.restaurantDescription.text = restaurantDetailViewModel.getDescriptionText()
        self.ratingLabel.text = restaurantDetailViewModel.getRatingText()
        self.ratingComparisonLabel.isHidden = restaurantDetailViewModel.shouldHideRatingComparison()
    }

    // MARK: - IBOutlet actions
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
