//
//  PhotosService.swift
//  SpottingScope
//
//  Created by Vittcal Neestackich on 2.06.22.
//

import Photos
import UIKit

final class PhotosService: PhotosServiceProtocol {

    // MARK: - Private properties

    private let imageManager = PHCachingImageManager()

    private var assets: [PHAsset] = []

    private struct Constants {
        static let fetchLimit = 1000
        static let creationDateSortKey = "creationDate"
    }

    // MARK: - Public

    var reloadCollectionViewItem: ((IndexPath, UIImage) -> Void)?

}

// MARK: - Public

extension PhotosService {

    func loadUsersLibraryAssets() {
        let assets = fetchUsersLibraryAssets()
        processAssets(assets)
    }

    func askPermissionIfNeeded(completionHandler: @escaping (Result<Void, Error>) -> Void) {
        if isAuthorized() {
            completionHandler(.success(Void()))
        } else {
            requestAuthorization { result in
                switch result {
                case .success(_):
                    completionHandler(.success(Void()))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }
    }

    func performImageRequest(by indexPath: IndexPath) -> Int32 {
        guard assets.count > 0, indexPath.row < assets.count else { return 0 }
        let asset = assets[indexPath.row]
        let imageSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = false
        imageManager.allowsCachingHighQualityImages = true

        return imageManager.requestImage(
            for: asset,
            targetSize: imageSize,
            contentMode: .aspectFill,
            options: options,
            resultHandler: { [weak self] image, _ in
                if let sself = self, let image = image, let requestIndex = sself.assets.firstIndex(where: {$0 == asset}) {

                    DispatchQueue.main.async {
                        self?.reloadCollectionViewItem?(IndexPath(item: requestIndex, section: 0), image)
                    }
                }
            }
        )
    }

    func cancelImageRequest(by requestId: Int32) {
        imageManager.cancelImageRequest(requestId)
    }

    func getAssetsCount() -> Int {
        return assets.count
    }

}

// MARK: - Private

private extension PhotosService {

    private func isAuthorized() -> Bool {
        return PHPhotoLibrary.authorizationStatus() == .authorized
    }

    private func requestAuthorization(completionHandler: @escaping (Result<Bool, Error>) -> Void) {
        PHPhotoLibrary.requestAuthorization({ authorizationStatus in
            if authorizationStatus == .authorized {
                completionHandler(.success(true))
            } else {
                completionHandler(.failure(PhotosServiceError.unauthorized))
            }
        })
    }

    private func fetchUsersLibraryAssets() -> PHFetchResult<PHAsset> {
        let options = PHFetchOptions()
        options.fetchLimit = Constants.fetchLimit
        options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)

        let sortDescriptor = NSSortDescriptor(key: Constants.creationDateSortKey, ascending: false)
        options.sortDescriptors = [sortDescriptor]

        return PHAsset.fetchAssets(with: .image, options: options)
    }

    private func processAssets(_ assets: PHFetchResult<PHAsset>) {
        assets.enumerateObjects ({ [weak self] (object, _, _) in
            let asset = object as PHAsset
            self?.assets.append(asset)
        })
    }

}
