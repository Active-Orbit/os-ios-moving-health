//
//  ImageUtils.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import UIKit

/**
 * Utility class that provides some useful methods to manage images
 */
public class ImageUtils {
    
    public static func resizeImage(_ image: UIImage, _ maxSize: CGFloat) -> UIImage? {
        let oldWidth = image.size.width;
        let oldHeight = image.size.height;
        
        let scaleFactor = (oldWidth > oldHeight) ? maxSize / oldWidth : maxSize / oldHeight;
        
        let newHeight = oldHeight * scaleFactor;
        let newWidth = oldWidth * scaleFactor;
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
    
    public static func resizeImageIfGreater(_ image: UIImage, _ limit: CGFloat) -> UIImage? {
        let heightInPoints = image.size.height
        let widthInPoints = image.size.width
        let widthInPixels = widthInPoints * image.scale
        let heightInPixels = heightInPoints * image.scale
        if widthInPixels > limit || heightInPixels > limit {
            return resizeImage(image, limit)
        }
        return image
    }
    
    
    public static func saveImage(image: UIImage, imageName: String) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent(imageName)!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }

    public static func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
}
