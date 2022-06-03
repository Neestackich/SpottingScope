# SpottingScope
UICollectionView-based photos library and saliency analyser written in Swift

[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](http://mit-license.org)
[![Platform](http://img.shields.io/badge/platform-iOS-lightgrey.svg?style=flat)](https://developer.apple.com/resources/)
[![Language](http://img.shields.io/badge/language-Swift-orange.svg?style=flat)](https://developer.apple.com/swift)
[![Architechture](http://img.shields.io/badge/architechture-MVC-indigo.svg?style=flat)]([https://developer.apple.com/swift](https://developer.apple.com/library/archive/documentation/General/Conceptual/DevPedia-CocoaCore/MVC.html))            


<div align="center">
<sub>Built with ❤︎ by
Victor Agibaylov
</sub>
</div>
<br />
<br />


## Preview
Below you can see several gifs providing you a better view of application functionality.

![OveralAppPreview](https://github.com/Neestackich/SpottingScope/blob/main/RPReplay_Final1654291238.gif "OveralAppPreview preview")
![SaliencyAnalysePreview](https://github.com/Neestackich/SpottingScope/blob/main/RPReplay_Final1654291289.gif "SaliencyAnalysePreview preview")
![OveralAppPreview](https://github.com/Neestackich/SpottingScope/blob/main/RPReplay_Final1654291451.gif "OveralAppPreview preview")


## Features
- Horizontal-scrolling user’s most recent 1000 photos in a grid.
- Attention-based saliency analyse of selected photo with area selection with red rectangle around the salient portion of the image.
- Toggling the image between aspect fit and aspect fill with navbar button(additional red rectangle animation performed).


## Questions



### What architectural design pattern did I use and why?
I used Apple MVC default pattern in terms of its simplicity and it fits well current scope of modules and functions.

![](https://developer.apple.com/library/archive/documentation/General/Conceptual/DevPedia-CocoaCore/Art/model_view_controller_2x.png)

*******

### What would I improve if I had more time?

- **Build better architechture**. First of all Apple MVC brings alot of problems to developer. In case of increase of app's functionality scope viewcontroller will have too many different responsobilities that leads to **Massive view controller**. Also it will be pretty difficult to test it properly via unit tests with mocks. **MVVM** pattern comes to our aid.
- **Add reactivness** to handle images loading, authorization and reliably handle data chains.
- **Unit/UI testing** to provide great test code coverage to avoid unexpected bugs.
- **Add pinch zoom gesture** to allow the user to zoom image with gestures on image preview screen in addition to navbar button.
- **Handle landscape / portrait mode**. The app is only known to work well in portrait mode. Interface rotation / size classes changes are not properly supported:
![LandscapePreview](https://github.com/Neestackich/SpottingScope/blob/main/RPReplay_Final1654295587.gif "Landscape preview")

- **Add localization**. Who nows, maybe this app will be popular in different countries all over the world😊
- **Add Dependency Injection** via **Swinject**.
- **Add Swiftlint** to provide proper Swift code style and convention enforce
- **Animate image scaling** Switching between aspectFit and aspectFill performs abruptly at the moment. 
![LandscapePreview](https://github.com/Neestackich/SpottingScope/blob/main/RPReplay_Final1654296449.gif "Landscape preview")

- **Improve error handling** at SaliencyAnalyserService.
1. [getSaliencyCoordinates](https://github.com/Neestackich/SpottingScope/blob/1fd6b0d94d8217e1849ff877a567fc3ee32168cf/SpottingScope/SpottingScope/Services/SaliencyAnalyser/SaliencyAnalyserService.swift#L21)
  SaliensyService could return SaliencyServiceResult entity wich holds coordinates or service error. Pseudocode: 

      ```swift
        func getSaliencyCoordinates(for image: UIImage) -> SaliencyServiceResult {
            guard let cgImage = image.cgImage else {
                return SaliencyServiceResult(error: .cgImageError)
            }

            let salientObjects = getSalientObjects(for: cgImage)

            return SaliencyServiceResult(coordinates: computeSaliencyCoordinates(for: image, with: salientObjects))
        }
      ```

2. [getSalientObjects](https://github.com/Neestackich/SpottingScope/blob/1fd6b0d94d8217e1849ff877a567fc3ee32168cf/SpottingScope/SpottingScope/Services/SaliencyAnalyser/SaliencyAnalyserService.swift#L42)
  Method getSalientObjects can throw error to higher level instead of returning empty value. Pseudocode:
  
      ```swift
        private func getSalientObjects(for cgImage: CGImage) throws -> VNRectangleObservation {
            let saliencyRequest = VNGenerateAttentionBasedSaliencyImageRequest(completionHandler: nil)
            let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            try requestHandler.perform([saliencyRequest])

            guard let result = saliencyRequest.results?.last, let observation = result.salientObjects?.last else {
                throw SaliencyAnalyserServiceError.emptyResult
            }

            return observation
        }
      ```

- **Improve authorization handling**. Current app version doesn't support handling of case when user didn't select any images from library.
![LandscapePreview](https://github.com/Neestackich/SpottingScope/blob/main/RPReplay_Final1654298080.gif "Landscape preview")

*******

### What would I like to highlight in the code?
1. Fetching images asynchonously from PHCachingImageManager(improved loading of images for collection view) - [performImageRequest](https://github.com/Neestackich/SpottingScope/blob/01d0bb4c6a5d7ad157569b7e2db3f60b8bceed1b/SpottingScope/SpottingScope/Services/Photos/PhotosService.swift#L54)
2. Drawing the rectangle around the salient portion of the image on top of view with animation - [drawRectangle](https://github.com/Neestackich/SpottingScope/blob/01d0bb4c6a5d7ad157569b7e2db3f60b8bceed1b/SpottingScope/SpottingScope/UI/Views/Modules/SaliencyViewer/SaliencyViewerView.swift#L125)
