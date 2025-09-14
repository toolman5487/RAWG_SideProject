//
//  DescriptionViewController.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/8/19.
//

import Foundation
import UIKit
import SnapKit

class DescriptionViewController: UIViewController {
    
    private let text: String
    private let gameTitle: String
    private let textView = UITextView()
    
    init(text: String, gameTitle: String) {
        self.text = text
        self.gameTitle = gameTitle
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .pageSheet
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = gameTitle
        
        textView.isEditable = false
        textView.text = text
        textView.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }
}
