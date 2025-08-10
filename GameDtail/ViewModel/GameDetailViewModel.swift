//
//  GameDetailViewModel.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/8/10.
//

import Foundation
import Combine

class GameDetailViewModel: ObservableObject {
    
    @Published var gameDetail: GameDetailModel?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let gameDetailService: GameDetailServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(gameDetailService: GameDetailServiceProtocol = GameDetailService()) {
        self.gameDetailService = gameDetailService
    }
    
    func fetchGameDetail(gameId: Int) {
        isLoading = true
        errorMessage = nil
        
        gameDetailService.fetchGameDetail(gameId: gameId)
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
                receiveValue: { [weak self] gameDetail in
                    self?.gameDetail = gameDetail
                }
            )
            .store(in: &cancellables)
    }
}
