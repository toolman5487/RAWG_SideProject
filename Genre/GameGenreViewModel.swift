//
//  GameGenreViewModel.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/9/27.
//

import Foundation
import Combine

class GameGenreViewModel: ObservableObject {
    
    @Published var genres: [GameGenreModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let gameGenreService: GameGenreServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(gameGenreService: GameGenreServiceProtocol = GameGenreService()) {
        self.gameGenreService = gameGenreService
    }
    
    func fetchGenres() {
        isLoading = true
        errorMessage = nil
        
        gameGenreService.fetchAllGenres()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] genres in
                    self?.genres = genres
                }
            )
            .store(in: &cancellables)
    }
}
