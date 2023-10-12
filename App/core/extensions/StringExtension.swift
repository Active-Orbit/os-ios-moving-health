//
//  StringExtension.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//

import UIKit

extension String {
    
    public func limitTo(length: Int) -> String {
        if count <= length {
            return self
        }
        return String(Array(self).prefix(upTo: length))
    }
    
    public func capitalizeFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    public func indexOf(_ character: Character) -> Int {
        return firstIndex(of: character)?.utf16Offset(in: self) ?? -1
    }
    
    public func charAt(_ at: Int) -> Character {
        let charIndex = index(startIndex, offsetBy: at)
        return self[charIndex]
    }
    
    public func padLeft(_ toLength: Int, _ withPad: String) -> String {
        if count >= toLength { return self }
        let string = padding(toLength: toLength, withPad: withPad, startingAt: 0)
        return String(string.reversed())
    }
    
    func estimatedHeight(_ forWidth: CGFloat, _ font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: forWidth, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    
    func estimatedWidth(_ forHeight: CGFloat, _ font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: forHeight)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font: font], context: nil)
        return ceil(boundingBox.width)
    }
    
    func htmlToString(size: CGFloat, color: UIColor, font: String, allignment: String) -> String {
        return htmlToAttributedString(size: size, color: color, font: font, allignment: allignment)?.string ?? ""
    }
    
    func htmlToAttributedString(size: CGFloat, color: UIColor, font: String, allignment: String) -> NSAttributedString? {
        let htmlTemplate = """
          <!doctype html>
          <html>
            <head>
              <style>
                body {
                  color: \(color.hexString!);
                  font-family: \(font);
                  text-align: \(allignment);
                  font-size: \(size)px;
                }
              </style>
            </head>
            <body>
              \(self)
            </body>
          </html>
          """
        guard let data = htmlTemplate.data(using: .utf8) else {
            return nil
        }
        
        guard let attributedString = try? NSAttributedString(
            data: data,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        ) else {
            return nil
        }
        
        return attributedString
    }
}

extension StringProtocol {
    
    var html2AttributedString: NSMutableAttributedString? {
        Data(utf8).html2AttributedString
    }
    
    var html2String: String {
        html2AttributedString?.string ?? ""
    }
}

extension Data {
    
    var html2AttributedString: NSMutableAttributedString? {
        do {
            return try NSMutableAttributedString(data: self, options: [.documentType: NSMutableAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    
    var html2String: String { html2AttributedString?.string ?? "" }
}
