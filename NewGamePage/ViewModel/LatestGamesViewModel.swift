//
//  LatestGamesViewModel.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/10/2.
//

import Foundation
import Combine

final class LatestGamesViewModel: ObservableObject {
    @Published var games: [GameListItemModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let service: HomeListServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(service: HomeListServiceProtocol = HomeListService()) {
        self.service = service
    }
    
    func fetchInitial(daysBack: Int = 30, pageSize: Int = 20) {
        isLoading = true
        errorMessage = nil
        
        service.fetchNewestGames(daysBack: daysBack, pageSize: pageSize)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] games in
                    self?.games = games
                }
            )
            .store(in: &cancellables)
    }
    
    func refresh(daysBack: Int = 30, pageSize: Int = 20) {
        fetchInitial(daysBack: daysBack, pageSize: pageSize)
    }
}
