//
//  PhotosServiceErrors.swift
//  SpottingScope
//
//  Created by Vittcal Neestackich on 2.06.22.
//

import Foundation

enum PhotosServiceError: Error {
    case unauthorized
}

extension PhotosServiceError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .unauthorized:
            return NSLocalizedString("Allow the app to get access to your photos library", comment: "")
        }
    }

}
