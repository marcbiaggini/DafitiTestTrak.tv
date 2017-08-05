//
//  MoviesTVC.swift
//  Trakt.tv Swift MVC
//
//  Created by Juan Villa .
//


import UIKit
import Kingfisher
import SwiftSpinner

class MoviesTVC: UITableViewController {
    
    var arrayMovies, arraySearchMovies : NSMutableArray?
    var currentPageNumber, searchPageNumber : Int!
    var searchTerm : String?
    var searchController : UISearchController!
    var arrayMoviesToShow: NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        initVariables()
        
        setupView()
        
    }
    
    func initVariables() {
        
        currentPageNumber = 0
        
        arrayMovies = NSMutableArray()
        
        arrayMoviesToShow = arrayMovies!
        
        tableView.reloadData()
    }
    
    func setupView() {
        
        title = TITLE
        
        let pref = UserDefaults.standard
        pref.set(true, forKey: "isPageRefreshing")
        pref.synchronize()
        
        setupSearchBar()

        tableView.setContentOffset(CGPoint(x: 0, y: self.searchController.searchBar.frame.size.height), animated: false)
 
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 350;


        SwiftSpinner.show("Loading movies please wait...")
        
        
        registerObserver()
        loadMovies()
    }
    
    func registerObserver () {
        let notificationName = Notification.Name("needUpdateTable")
        NotificationCenter.default.addObserver(self, selector: #selector(MoviesTVC.updateRecords), name: notificationName, object: nil)
    }
    
    public func scrollToTop() {
        
        let indexPath = IndexPath(row: 0, section: 0) as IndexPath
        if tableView.numberOfRows(inSection: 0) > 0 {
            tableView.scrollToRow(at: indexPath , at: .top, animated: false)
        }
        
    }
    
    func loadMovies() {
        
        currentPageNumber = currentPageNumber + 1
        APIDataManager().downloadMovies(pageNumber: currentPageNumber, arrayResults: arrayMovies!)
        
    }
    

    
    @IBAction func pushedSearchButton(_ sender: UIBarButtonItem) {
        
        searchController.searchBar.becomeFirstResponder()
        scrollToTop()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        arrayMoviesToShow = arrayMovies!
        tableView.reloadData()
        scrollToTop()
        
    }
    
    
}

extension MoviesTVC {
    
    func loadMoviesWithString(searchTerm: String) {
        
        searchPageNumber = searchPageNumber + 1
        APIDataManager().searchMovies(pageNumber: searchPageNumber, arrayResults: arraySearchMovies!, searchTerms: searchTerm)
    }
    
    func loadNextPage() {
        
        if !UserDefaults.standard.bool(forKey: "isPageRefreshing") {
            let pref = UserDefaults.standard
            pref.set(true, forKey: "isPageRefreshing")
            pref.synchronize()
            
            if arrayMoviesToShow == arraySearchMovies {
                if let searchTerm = searchTerm {
                    loadMoviesWithString(searchTerm: searchTerm)
                }
            } else {
                loadMovies()
            }
        }
        
    }
    
    func updateRecords() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            SwiftSpinner.hide()
        }
    }
}

// MARK: - Table view data source
extension MoviesTVC{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMoviesToShow.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath)
        
        guard let movie = arrayMoviesToShow.object(at: indexPath.row) as? Movie else{
            return cell
        }
        
        if let titleLabel = cell.contentView.viewWithTag(10) as? UILabel, let title = movie.title, let year = movie.year{
            titleLabel.text = String(title) + " (" + String(year) + ")"
        }
        
        if let infoLabel = cell.contentView.viewWithTag(11) as? UILabel,  let rating = movie.rating, let duration = movie.runtime {
            infoLabel.text = String(duration) + " mins" + " | " + String(format: "%.2f",rating) + "/10"
        }
        
        if let overviewLabel = cell.contentView.viewWithTag(12) as? UILabel, let overview = movie.overview, let generes = movie.genres {
            var genere = ""
            
            for gen in generes {
                if genere.isEmpty{
                    genere = gen
                } else {
                    genere += " | " + gen

                }
            }
            
            overviewLabel.text = String(overview) + "\n\n" + String(genere.uppercased())
        }
        
        if let imgPoster = cell.contentView.viewWithTag(13) as? UIImageView{
            imgPoster.image = #imageLiteral(resourceName: "launchScreenLogo")
            if let imgURL = movie.imageURL {
                imgPoster.kf.setImage(with: URL(string:imgURL))
            }
            ImagesController().setClippingImageView(imgView: imgPoster)
        }
        
    
        return cell
        
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        
        searchController.searchBar.resignFirstResponder()
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        
        if(self.tableView.contentOffset.y >= ((self.tableView.contentSize.height/2) - self.tableView.bounds.size.height))
        {
            loadNextPage()
        }
        else if(self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height))
        {
            loadNextPage()
        }
        
    }

}


extension MoviesTVC: UISearchDisplayDelegate, UISearchBarDelegate, UISearchControllerDelegate {
    
    public func setupSearchBar() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.sizeToFit()
        self.searchController.searchBar.tintColor = ColorController().hexStringToUIColor(hex: COLOR_LAYER)
        self.searchController.searchBar.barTintColor = ColorController().hexStringToUIColor(hex: COLOR_TINT)
        searchController.searchBar.isTranslucent = true

    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(request), object: nil)
        
        searchTerm = searchText
        
        scrollToTop()
        
        perform(#selector(request), with: nil, afterDelay: 0.8)
        
    }
    
    // MARK: - Search logic
    func request() {
        
        searchPageNumber = 0
        
        arraySearchMovies = NSMutableArray()
        if let searchTerm = searchTerm { loadMoviesWithString(searchTerm: searchTerm) }
        
        arrayMoviesToShow = arraySearchMovies!
        tableView.reloadData()
        
    }
}

