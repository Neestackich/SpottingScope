//
//  UIImageView.swift
//  SpottingScope
//
//  Created by Vittcal Neestackich on 2.06.22.
//

import UIKit

extension UIImageView {

    func calculateRectOfImageInImageView() -> CGRect {
        let imageViewSize = frame.size

        guard let imageSize = image?.size else {
            return CGRect.zero
        }

        let scaleWidth = imageViewSize.width / imageSize.width
        let scaleHeight = imageViewSize.height / imageSize.height
        var aspect = CGFloat()

        if contentMode == .scaleAspectFit {
            aspect = fmin(scaleWidth, scaleHeight)
        } else {
            aspect = fmax(scaleWidth, scaleHeight)
        }

        var imageRect = CGRect(x: 0, y: 0, width: imageSize.width * aspect, height: imageSize.height * aspect)
        imageRect.origin.x = (imageViewSize.width - imageRect.size.width) / 2
        imageRect.origin.y = (imageViewSize.height - imageRect.size.height) / 2
        imageRect.origin.x += frame.origin.x
        imageRect.origin.y += frame.origin.y

        return imageRect
    }

}
