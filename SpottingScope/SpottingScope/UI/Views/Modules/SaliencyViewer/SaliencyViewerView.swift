//
//  SaliencyViewerView.swift
//  SpottingScope
//
//  Created by Vittcal Neestackich on 2.06.22.
//

import UIKit

final class SaliencyViewerView: UIViewController {

    // MARK: - Private properties

    @IBOutlet private weak var previewImageView: UIImageView!

    private var loadingIndicator: UIActivityIndicatorView!
    private var grayView: UIView!
    private var rectangleView: UIView!
    private var imageForPreview: UIImage!
    private var saliencyAnalyserService: SaliencyAnalyserServiceProtocol!
    private var saliencyCoordinates: SaliencyCoordinates!

    private struct Constants {
        static let animationKey = "strokeEnd"
        static let shapeAnimationKey = "shapeRectangleAnimation"
        static let rectangleLineWidth = 2.0
        static let animationStartValue = 0.0
        static let animationFinishValue = 1.0
        static let animationDuration = 0.8
        static let navBarRightButtonImageName = "arrow.up.left.and.down.right.magnifyingglass"
        static let activityIndicatorBackgroundColor = UIColor.black
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadImageWithSaliencyDetails()
    }

    override func viewDidAppear(_ animated: Bool) {
        setupNavBar()
    }

}

// MARK: - Public

extension SaliencyViewerView {

    func setImageForPreview(_ image: UIImage) {
        imageForPreview = image
    }

}

// MARK: - Private

private extension SaliencyViewerView {

    private func setup() {
        setupSaliencyService()
        setupView()
    }

    private func setupView() {
        setupImageView()
        setupActivityIndicator()
    }

    private func setupSaliencyService() {
        saliencyAnalyserService = SaliencyAnalyserService()
    }

    private func setupImageView() {
        previewImageView.image = imageForPreview
    }

    private func setupActivityIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .large)
        grayView = UIView()
        grayView.backgroundColor = Constants.activityIndicatorBackgroundColor
        grayView.frame = self.view.frame
        loadingIndicator.center = grayView.center
        grayView.addSubview(loadingIndicator)
    }

    private func setupNavBar() {
        let rightMenuButton = UIBarButtonItem(image: UIImage(systemName: Constants.navBarRightButtonImageName), style: .plain, target: self, action: #selector(aspectSwitchButtonTapped))
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.topItem?.setRightBarButtonItems([rightMenuButton], animated: false)
    }

    private func loadImageWithSaliencyDetails() {
        showActivityIndicator(true)

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let sself = self else { return }

            sself.saliencyCoordinates = sself.saliencyAnalyserService.getSaliencyCoordinates(for: sself.imageForPreview)

            DispatchQueue.main.async {
                sself.showActivityIndicator(false)
                sself.drawRectangle()
            }
        }
    }

    @objc private func aspectSwitchButtonTapped() {
        switch previewImageView.contentMode {
        case .scaleAspectFit:
            previewImageView.contentMode = .scaleAspectFill
            rectangleView.removeFromSuperview()
            drawRectangle()
        case .scaleAspectFill:
            previewImageView.contentMode = .scaleAspectFit
            rectangleView.removeFromSuperview()
            drawRectangle()
        default:
            previewImageView.contentMode = .scaleAspectFit
        }
     }

    private func drawRectangle() {
        let rectOfImageInImageView = previewImageView.calculateRectOfImageInImageView()
        let heightDifference = imageForPreview.size.height / rectOfImageInImageView.size.height
        let widthDifference = imageForPreview.size.width / rectOfImageInImageView.size.width

        rectangleView = UIView(frame: rectOfImageInImageView)

        let resizedTopLeft = CGPoint(
            x: saliencyCoordinates.topLeft.x / widthDifference,
            y: saliencyCoordinates.topLeft.y / heightDifference
        )
        let resizedTopRight = CGPoint(
            x: saliencyCoordinates.topRight.x / widthDifference,
            y: saliencyCoordinates.topRight.y / heightDifference
        )
        let resizedBottomRight = CGPoint(
            x: saliencyCoordinates.bottomRight.x / widthDifference,
            y: saliencyCoordinates.bottomRight.y / heightDifference
        )
        let resizedBottomLeft = CGPoint(
            x: saliencyCoordinates.bottomLeft.x / widthDifference,
            y: saliencyCoordinates.bottomLeft.y / heightDifference
        )

        let animation = CABasicAnimation(keyPath: Constants.animationKey)
        animation.fromValue = Constants.animationStartValue
        animation.toValue = Constants.animationFinishValue
        animation.duration = Constants.animationDuration

        let path = UIBezierPath()
        path.move(to: resizedTopLeft)
        path.addLine(to: resizedTopRight)
        path.addLine(to: resizedBottomRight)
        path.addLine(to: resizedBottomLeft)
        path.addLine(to: resizedTopLeft)

        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.lineWidth = Constants.rectangleLineWidth
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor.red.cgColor
        shape.add(animation, forKey: Constants.shapeAnimationKey)

        rectangleView.layer.addSublayer(shape)
        self.view.addSubview(rectangleView)

        CATransaction.commit()
    }

    private func showActivityIndicator(_ animated: Bool) {
        if animated {
            self.view.addSubview(grayView)
            loadingIndicator.startAnimating()
        } else {
            grayView.removeFromSuperview()
            loadingIndicator.stopAnimating()
        }
    }

}
