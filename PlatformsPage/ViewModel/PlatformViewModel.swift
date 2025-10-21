//
//  PlatformViewModel.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/10/19.
//

import Foundation
import Combine

class PlatformViewModel: ObservableObject {
    
    @Published var platforms: [PlatformModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let platformsService: PlatformsServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var currentPage = 1
    private let pageSize = 10
    
    init(platformsService: PlatformsServiceProtocol = PlatformsService()) {
        self.platformsService = platformsService
    }
    
    func fetchPlatforms() {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        platformsService.fetchPlatforms(page: currentPage, pageSize: pageSize)
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
                    self?.platforms = response.results ?? []
                }
            )
            .store(in: &cancellables)
    }
    
    func getPlatformsCount() -> Int {
        return platforms.count
    }
    
    func getPlatform(at index: Int) -> PlatformModel? {
        guard index >= 0 && index < platforms.count else { return nil }
        return platforms[index]
    }
}