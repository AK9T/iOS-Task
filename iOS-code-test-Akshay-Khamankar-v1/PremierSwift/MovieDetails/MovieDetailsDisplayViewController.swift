import UIKit
import SnapKit

// MARK: - Data Model
/// Enum representing a movie detail item for the table view.
enum MovieDetailItem {
    case image(String?)
    case title(String)
    case overview(String)
    case cards  // New: a row that shows a collection view with red cards.
}

// MARK: - MovieDetailsDisplayViewController
final class MovieDetailsDisplayViewController: UIViewController {
    
    let movieDetails: MovieDetails
    private var items: [MovieDetailItem] = [] // Data source for the table view.
    private var similarMovies: [SimilarMovieDetailsResult] = []
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    init(movieDetails: MovieDetails, similarMovies: [SimilarMovieDetailsResult]) {
        self.movieDetails = movieDetails
        self.similarMovies = similarMovies
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Instead of using a custom view, we add a table view to the controller’s view.
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        setupTableView()
        populateItems()
    }
    
    /// Sets up the table view and registers the custom cell classes.
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Fill the view controller's view.
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Remove cell separators if you prefer the spacing from the original design.
        tableView.separatorStyle = .none
        
        // Allow cells with dynamic height.
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        // Register our custom cells.
        tableView.register(MovieImageTableViewCell.self, forCellReuseIdentifier: MovieImageTableViewCell.reuseIdentifier)
        tableView.register(MovieTitleTableViewCell.self, forCellReuseIdentifier: MovieTitleTableViewCell.reuseIdentifier)
        tableView.register(MovieOverviewTableViewCell.self, forCellReuseIdentifier: MovieOverviewTableViewCell.reuseIdentifier)
        tableView.register(MovieCardsTableViewCell.self, forCellReuseIdentifier: MovieCardsTableViewCell.reuseIdentifier)
    }
    
    /// Builds the data source from the `movieDetails`. After adding the movie details,
    /// we append an extra item for the collection view row.
    private func populateItems() {
        var newItems = [MovieDetailItem]()
        
        if movieDetails.backdropPath?.isEmpty == false {
            newItems.append(.image(movieDetails.backdropPath))
        }
        if movieDetails.title?.isEmpty == false {
            newItems.append(.title(movieDetails.title ?? ""))
        }
        if movieDetails.overview?.isEmpty == false {
            newItems.append(.overview(movieDetails.overview ?? ""))
        }
        // Append the new collection view row.
        newItems.append(.cards)
        
        items = newItems
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension MovieDetailsDisplayViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // One section.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count // Dynamic: depends on the items array.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let item = items[indexPath.row]
        switch item {
        case .image(let backdropPath):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieImageTableViewCell.reuseIdentifier, for: indexPath) as? MovieImageTableViewCell else { return UITableViewCell() }
            cell.configure(with: backdropPath)
            cell.selectionStyle = .none
            return cell
            
        case .title(let title):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTitleTableViewCell.reuseIdentifier, for: indexPath) as? MovieTitleTableViewCell else { return UITableViewCell() }
            cell.configure(with: title)
            cell.selectionStyle = .none
            return cell
            
        case .overview(let overview):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieOverviewTableViewCell.reuseIdentifier, for: indexPath) as? MovieOverviewTableViewCell else { return UITableViewCell() }
            cell.configure(with: overview)
            cell.selectionStyle = .none
            return cell
            
        case .cards:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCardsTableViewCell.reuseIdentifier, for: indexPath) as? MovieCardsTableViewCell else { return UITableViewCell() }
            cell.configure(similarMovies: similarMovies)
            cell.selectionStyle = .none
            
            return cell
        }
    }
}

#if DEBUG || TESTING
extension MovieDetailsDisplayViewController {
    var exposedTableView: UITableView {
        return tableView
    }
}
#endif
