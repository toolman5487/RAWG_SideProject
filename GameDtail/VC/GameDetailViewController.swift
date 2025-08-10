//
//  GameDetailViewController.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/8/10.
//

import Foundation
import UIKit
import SnapKit
import Combine

class GameDetailViewController: UIViewController {
    
    private let gameDetailService = GameDetailService()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchGameDetail()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
    }
    
    private func fetchGameDetail() {
        gameDetailService.fetchGameDetail(gameId: 46889)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("API 請求完成")
                    case .failure(let error):
                        print("API 錯誤: \(error)")
                        DispatchQueue.main.async {
                            self.title = "錯誤: \(error.localizedDescription)"
                        }
                    }
                },
                receiveValue: { gameDetail in
                    DispatchQueue.main.async {
                        self.title = gameDetail.name ?? "未知遊戲"
                        print("遊戲名稱: \(gameDetail.name ?? "未知")")
                        print("遊戲 ID: \(gameDetail.id)")
                    }
                }
            )
            .store(in: &cancellables)
    }
}
