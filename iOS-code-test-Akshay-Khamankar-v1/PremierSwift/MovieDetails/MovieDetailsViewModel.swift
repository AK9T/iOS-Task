import Foundation

protocol MovieDetailProtocol: Codable {
    var title: String? { get }
}

enum MoviesDetailsViewModelState: Equatable {
    case loading(Movie)
    case loaded(MovieDetailProtocol, MovieDetailProtocol)
    case error

    var title: String? {
        switch self {
        case .loaded(let movieDetail, let similarMovies):
            return movieDetail.title
        case .loading(let movie):
            return movie.title
        case .error:
            return nil
        }
    }
    
    // "" Implement Equatable conformance
    static func == (lhs: MoviesDetailsViewModelState, rhs: MoviesDetailsViewModelState) -> Bool {
        switch (lhs, rhs) {
        case (.loading(let lhsMovie), .loading(let rhsMovie)):
            return lhsMovie.id == rhsMovie.id && lhsMovie.title == rhsMovie.title
        case (.loaded(let lhsDetails, let lhsSimilar), .loaded(let rhsDetails, let rhsSimilar)):
            return lhsDetails.title == rhsDetails.title && lhsSimilar.title == rhsSimilar.title
        case (.error, .error):
            return true
        default:
            return false
        }
    }
}

protocol MoviesDetailsViewModelProtocol {
    var updatedState: (() -> Void)? { get set }
    var state: MoviesDetailsViewModelState { get }
    func fetchData()
}

final class MockMoviesDetailsViewModel: MoviesDetailsViewModelProtocol {

    var state: MoviesDetailsViewModelState = .error
    var updatedState: (() -> Void)?
    var fetchDataCalled = false

    func fetchData() {
        fetchDataCalled = true
    }

    func simulateStateChange(_ newState: MoviesDetailsViewModelState) {
        state = newState
        updatedState?()
    }
}


final class MoviesDetailsViewModel: MoviesDetailsViewModelProtocol {

    private let apiManager: APIManaging
    private let initialMovie: Movie

    init(movie: Movie, apiManager: APIManaging = APIManager()) {
        self.initialMovie = movie
        self.apiManager = apiManager
        self.state = .loading(movie)
    }

    var updatedState: (() -> Void)?

    var state: MoviesDetailsViewModelState {
        didSet {
            updatedState?()
        }
    }

    func fetchData() {
        let group = DispatchGroup()

        var movieDetails: MovieDetails?
        var similarMovies: SimilarMovieDetails?
        var hasErrorOccurred = false

        group.enter()
        apiManager.execute(MovieDetails.details(for: initialMovie)) { [weak self] result in
            defer { group.leave() }  // Ensure group.leave() is called no matter what path is taken
            guard self != nil else { return }

            switch result {
            case .success(let details):
                movieDetails = details
            case .failure:
                hasErrorOccurred = true
            }
        }
        
        group.enter()
        apiManager.execute(MovieDetails.similarMovies(for: initialMovie)) { [weak self] result in
            defer { group.leave() }  // Ensure group.leave() is called no matter what path is taken
            guard self != nil else { return }

            switch result {
            case .success(let details):
                similarMovies = details
            case .failure:
                hasErrorOccurred = true
            }
        }

        group.notify(queue: .main) {
            guard !hasErrorOccurred else {
                self.state = .error
                return
            }

            if let movieDetails = movieDetails, let similarMovies = similarMovies {
                debugPrint("Both details fetched successfully")
                // Handle the successful fetching of both sets of details
                // You might want to combine these details into a single state update or navigate/update UI
                self.state = .loaded(movieDetails, similarMovies)
            } else {
                debugPrint("Partial data fetched or missing data")
                self.state = .error
            }
        }
    }

}

// "" Mock API Manager for controlled responses
class MockAPIManager: APIManaging {
    var shouldReturnError = false
    var mockMovieDetails: MovieDetails?
    var mockSimilarMovies: SimilarMovieDetails?
    
    func execute<Value: Decodable>(_ request: Request<Value>, completion: @escaping (Result<Value, APIError>) -> Void) {
        if shouldReturnError {
            completion(.failure(.networkError))
        } else {
            if let mockResponse = mockMovieDetails as? Value {
                completion(.success(mockResponse))
            } else if let mockResponse = mockSimilarMovies as? Value {
                completion(.success(mockResponse))
            } else {
                completion(.failure(.parsingError))
            }
        }
    }
}
