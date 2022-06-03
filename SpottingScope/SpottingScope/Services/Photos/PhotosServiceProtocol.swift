//
//  PhotosServiceProtocol.swift
//  SpottingScope
//
//  Created by Vittcal Neestackich on 2.06.22.
//

import UIKit

protocol PhotosServiceProtocol {

    // MARK: - Callbacks
    var reloadCollectionViewItem: ((IndexPath, UIImage) -> Void)? { get set }

    // MARK: - Actions
    func loadUsersLibraryAssets()
    func askPermissionIfNeeded(completionHandler: @escaping (Result<Void, Error>) -> Void)
    func performImageRequest(by indexPath: IndexPath) -> Int32
    func getAssetsCount() -> Int
    func cancelImageRequest(by requestId: Int32)

}
