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
    @Published var isLoadingMore = false
    @Published var errorMessage: String?
    @Published var hasMoreData = true
    
    private let platformsService: PlatformsServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var currentPage = 1
    private var nextURL: String?
    
    init(platformsService: PlatformsServiceProtocol = PlatformsService()) {
        self.platformsService = platformsService
    }
    
    func fetchPlatforms() {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        currentPage = 1
        platforms.removeAll()
        hasMoreData = true
        
        platformsService.fetchPlatforms(page: currentPage, pageSize: 10)
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
                    self?.handlePlatformResponse(response)
                }
            )
            .store(in: &cancellables)
    }
    
    func loadMorePlatforms() {
        guard !isLoadingMore && hasMoreData else { return }
        
        isLoadingMore = true
        
        if let nextURL = nextURL {
            platformsService.fetchPlatformsFromURL(nextURL)
                .sink(
                    receiveCompletion: { [weak self] completion in
                        self?.isLoadingMore = false
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            self?.errorMessage = error.localizedDescription
                        }
                    },
                    receiveValue: { [weak self] response in
                        self?.handlePlatformResponse(response, isLoadMore: true)
                    }
                )
                .store(in: &cancellables)
        } else {
            currentPage += 1
            platformsService.fetchPlatforms(page: currentPage, pageSize: 10)
                .sink(
                    receiveCompletion: { [weak self] completion in
                        self?.isLoadingMore = false
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            self?.errorMessage = error.localizedDescription
                        }
                    },
                    receiveValue: { [weak self] response in
                        self?.handlePlatformResponse(response, isLoadMore: true)
                    }
                )
                .store(in: &cancellables)
        }
    }
    
    private func handlePlatformResponse(_ response: PlatformResponse, isLoadMore: Bool = false) {
        let newPlatforms = response.results ?? []
        
        if isLoadMore {
            platforms.append(contentsOf: newPlatforms)
        } else {
            platforms = newPlatforms
        }
        
        nextURL = response.next
        hasMoreData = response.next != nil
        
        if isLoadMore {
            isLoadingMore = false
        }
    }
    
    func getPlatformsCount() -> Int {
        return platforms.count
    }
    
    func getPlatform(at index: Int) -> PlatformModel? {
        guard index >= 0 && index < platforms.count else { return nil }
        return platforms[index]
    }
    
    func shouldLoadMore(for indexPath: IndexPath) -> Bool {
        return indexPath.item >= platforms.count - 3 && hasMoreData && !isLoadingMore
    }
}
