import Foundation

struct MovieDetails: MovieDetailProtocol {
        
    let title: String?
    let overview: String?
    let backdropPath: String?
    let tagline: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case overview
        case backdropPath = "backdrop_path"
        case tagline
    }
    
}

struct SimilarMovieDetails: MovieDetailProtocol {
    
    var title: String?
    let page: Int?
    let results: [SimilarMovieDetailsResult]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
public struct SimilarMovieDetailsResult: Codable {
    
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage, originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }

    // Init
    public init(
        adult: Bool? = nil,
        backdropPath: String? = nil,
        genreIDS: [Int]? = nil,
        id: Int? = nil,
        originalLanguage: String? = nil,
        originalTitle: String? = nil,
        overview: String? = nil,
        popularity: Double? = nil,
        posterPath: String? = nil,
        releaseDate: String? = nil,
        title: String? = nil,
        video: Bool? = nil,
        voteAverage: Double? = nil,
        voteCount: Int? = nil
    ) {
        self.adult = adult
        self.backdropPath = backdropPath
        self.genreIDS = genreIDS
        self.id = id
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
}


extension MovieDetails {
    static func details(for movie: Movie) -> Request<MovieDetails> {
        return Request(method: .get, path: "/movie/\(movie.id)")
    }
    //MovieDetails - movie/{movie_id}/similar
    static func similarMovies(for movie: Movie) -> Request<SimilarMovieDetails> {
        return Request(method: .get, path: "/movie/\(movie.id)/similar")
    }
}

