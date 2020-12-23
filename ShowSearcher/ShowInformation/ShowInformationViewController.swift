//
//  ShowInformationViewController.swift
//  ShowSearcher
//
//  Created by Steven A. Warren.
//

import UIKit

class ShowInformationViewController: UIViewController {
    
    @IBOutlet private var errorMessageLabel: UILabel!
    @IBOutlet private var showImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var daysSincePremierLabel: UILabel!
    
    lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.searchBar.delegate = self
        controller.searchBar.placeholder = dataSource?.searchControllerPlaceholder
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.tintColor = view.tintColor
        return controller
    }()
    
    var dataSource: ShowInformationDataSource? {
        didSet {
            dataSource?.updateShowImage = updateShowImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        definesPresentationContext = true
        errorMessageLabel.text = ""
        nameLabel.text = ""
        daysSincePremierLabel.text = ""
    }
    
    private func updateShowImage(_ image: UIImage?) {
        showImageView.image = image
    }
}

// MARK: UISearchResultsUpdating

extension ShowInformationViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        dataSource?.update(searchText: searchText)
    }
}

// MARK: - UISearchBarDelegate

extension ShowInformationViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dataSource?.searchForShow { [weak self] succeeded in
            guard let self = self else { return }
            succeeded ? self.updatesOnSuccessfulSearch() : self.updatesOnFailedSearch()
        }
    }
}

// MARK: - Searching

extension ShowInformationViewController {
    
    private func updatesOnSuccessfulSearch() {
        errorMessageLabel.text = ""
        nameLabel.text = dataSource?.showName
        daysSincePremierLabel.text = dataSource?.daysSincePremier
    }
    
    private func updatesOnFailedSearch() {
        errorMessageLabel.text = dataSource?.searchErrorMessage
        nameLabel.text = ""
        daysSincePremierLabel.text = ""
    }
}
