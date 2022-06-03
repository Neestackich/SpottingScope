//
//  PhotoCell.swift
//  SpottingScope
//
//  Created by Vittcal Neestackich on 2.06.22.
//

import UIKit

final class PhotoCell: UICollectionViewCell {

    @IBOutlet private weak var photoImageView: UIImageView!

    weak var delegate: PhotoCellDelegate?

    private var requestId: Int32 = 0

    func setRequestId(_ id: Int32) {
        if requestId != id {
            delegate?.cancelImageRequest(by: requestId)
        }
        requestId = id
    }

    func setupImage(photoImage: UIImage) {
        photoImageView.image = photoImage
    }

    func getImage() -> UIImage? {
        return photoImageView.image
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        photoImageView.image = nil
    }

}
