//
//  ImageCompressor.swift
//  EasyParty
//
//  Created by Hugues Fils on 02/05/2024.
//

import UIKit

func compressImage(_ originalImage: UIImage, maxSize: Int) -> Data? {
  var compression: CGFloat = 1.0
  let maxCompression: CGFloat = 0.1
  let maxFileSize = maxSize * 1024 * 1024  // maxSize en Mo

  guard var imageData = originalImage.jpegData(compressionQuality: compression) else { return nil }

  while imageData.count > maxFileSize && compression > maxCompression {
    compression -= 0.1
    if let compressedData = originalImage.jpegData(compressionQuality: compression) {
      imageData = compressedData
    } else {
      return nil
    }
  }
  return imageData
}
