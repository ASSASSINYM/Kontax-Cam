//
//  ColourLeaksImageFilter.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 18/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import GPUImage
import UIKit

class ColourLeaksImageFilter: ImageFilterProtocol {
    
    private let selectedColourLeaksFilter: UIColor = .red
    private let strength: CGFloat = FilterStrength.colourleaks
    
    func process(imageToEdit image: UIImage) -> UIImage? {
        print("Applying colourleaks with strength of: \(String(describing: strength))")
        
        var editedImage: UIImage?
        let output = PictureOutput()
        output.encodedImageFormat = .jpeg
        output.imageAvailableCallback = { outputImage in
            editedImage = outputImage.remakeOrientation(fromImage: image)
        }
        
        let blendMode = DarkenBlend()
        
        let imageInput = PictureInput(image: image)
        let colourLeaksInput = PictureInput(image: renderImage(fromColor: selectedColourLeaksFilter, withSize: image.size).alpha(strength))
        
        imageInput --> blendMode
        colourLeaksInput --> blendMode --> output
        
        imageInput.processImage(synchronously: true)
        colourLeaksInput.processImage(synchronously: true)
        
        
        return editedImage
    }
    
    private func renderImage(fromColor color: UIColor, withSize size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { (ctx) in
            color.set()
            ctx.fill(CGRect(origin: .zero, size: size))
        }
    }
}
