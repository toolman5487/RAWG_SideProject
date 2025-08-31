//
//  SearchViewModel.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/8/31.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    
    @Published var searchResults: [GameSearchResult] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let searchService = SearchService()
    private var cancellables = Set<AnyCancellable>()
    private var searchSubject = PassthroughSubject<String, Never>()
    
    init() {
        setupSearchDebounce()
    }
    
    private func setupSearchDebounce() {
        searchSubject
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.performSearch(query: query)
            }
            .store(in: &cancellables)
    }
    
    func searchGames(query: String) {
        searchSubject.send(query)
    }
    
    private func performSearch(query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        isLoading = true
        errorMessage = nil
        searchService.searchGames(query: query)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] response in
                    let sortedResults = self?.sortSearchResults(response.results, query: query) ?? response.results
                    self?.searchResults = sortedResults
                }
            )
            .store(in: &cancellables)
    }

    private func sortSearchResults(_ results: [GameSearchResult], query: String) -> [GameSearchResult] {
        return results.sorted { first, second in
            let queryLower = query.lowercased()
            let firstExactMatch = first.name.lowercased() == queryLower
            let secondExactMatch = second.name.lowercased() == queryLower
            
            if firstExactMatch != secondExactMatch {
                return firstExactMatch
            }
            
            let firstStartsWith = first.name.lowercased().hasPrefix(queryLower)
            let secondStartsWith = second.name.lowercased().hasPrefix(queryLower)
            
            if firstStartsWith != secondStartsWith {
                return firstStartsWith
            }
            
            if let firstDate = first.released, let secondDate = second.released {
                return firstDate > secondDate
            }
            
            return first.rating > second.rating
        }
    }
}
