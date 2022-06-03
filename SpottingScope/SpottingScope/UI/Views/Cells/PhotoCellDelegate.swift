//
//  PhotoCellDelegate.swift
//  SpottingScope
//
//  Created by Vittcal Neestackich on 2.06.22.
//

import Foundation

protocol PhotoCellDelegate: AnyObject {

    // MARK: - Actions
    func cancelImageRequest(by requestId: Int32)

}
