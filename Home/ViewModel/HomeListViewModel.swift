//
//  HomeListViewModel.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/9/12.
//

import Foundation
import Combine

class HomeListViewModel: ObservableObject {
    
    @Published var games: [GameListItemModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service: HomeListServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(service: HomeListServiceProtocol = HomeListService()) {
        self.service = service
    }
    
    func loadNewestGames() {
        isLoading = true
        errorMessage = nil
        
        service.fetchNewestGames(daysBack: 30, pageSize: 20)
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
    
    func refreshGames() {
        loadNewestGames()
    }
}
