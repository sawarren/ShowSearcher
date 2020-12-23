//
//  TVMazeShowSearchService.swift
//  ShowSearcher
//
//  Created by Steven A. Warren
//

import Foundation

enum TVMazeShowSearchServiceError: Error {
    case invalidUrl
    case noData
    case decodingFailed
    
    var description: String {
        switch self {
        case .invalidUrl: return "We couldn't find a show for that search term!"
        case .noData: return "We couldn't find a show for that search term!"
        case .decodingFailed: return "We found something, but it didn't make sense."
        }
    }
}

class TVMazeShowSearchService: ShowSearchService {
    
    private let baseUrl = "https://api.tvmaze.com/singlesearch/shows?q="

    func requestSingleShow(named name: String, completion: @escaping (Result<Show, TVMazeShowSearchServiceError>) -> Void) {
        let searchUrlString = baseUrl + name.replacingOccurrences(of: " ", with: "+").lowercased()
        guard let searchUrl = URL(string: searchUrlString) else {
            return completion(.failure(TVMazeShowSearchServiceError.invalidUrl))
        }
        CachedRequest.request(url: searchUrl) { data, cached in
            guard let data = data else {
                return completion(.failure(TVMazeShowSearchServiceError.noData))
            }
            guard let show = self.decodeShow(from: data) else {
                return completion(.failure(TVMazeShowSearchServiceError.decodingFailed))
            }
            completion(.success(show))
        }
    }
    
    func requestImageData(for show: Show, completion: @escaping (Result<Data, TVMazeShowSearchServiceError>) -> Void) {
        guard let imageUrl = URL(string: show.originalImageUrl) else {
            return completion(.failure(TVMazeShowSearchServiceError.invalidUrl))
        }
        CachedRequest.request(url: imageUrl) { data, cached in
            guard let data = data else {
                return completion(.failure(TVMazeShowSearchServiceError.noData))
            }
            completion(.success(data))
        }
    }
    
    private func decodeShow(from data: Data) -> Show? {
        var show: Show? = nil
        do {
            show = try JSONDecoder().decode(Show.self, from: data)
        } catch let error {
            print(error.localizedDescription)
        }
        return show
    }
}

