//
//  LocalFileManager.swift
//  CryptoSwiftUI
//
//  Created by Bengi Anıl on 27.03.2024.
//

import Foundation
import SwiftUI

class LocalFileManager {
    static let instance = LocalFileManager()
    
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        createFolder(folderName: folderName)

        guard let data = image.pngData(),
              let url = getUrlForImage(imageName: imageName, folderName: folderName) else { return }
        
        do {
            try data.write(to: url)
        } catch let error {
            print("Error saving image \(error.localizedDescription)")
        }
    }
    
    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard let url = getUrlForImage(imageName: imageName, folderName: folderName),
              FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        return UIImage(contentsOfFile: url.path)
    }
    
    private func createFolder(folderName: String) {
        guard let folderUrl = getUrlForFolder(folderName: folderName) else { return }
        
        if !FileManager.default.fileExists(atPath: folderUrl.path) {
            do {
                try FileManager.default.createDirectory(at: folderUrl, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Error creating directory. FolderName: \(folderName). \(error)")
            }
        }
    }
    
    private func getUrlForFolder(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        return url.appending(component: folderName)
    }
    
    private func getUrlForImage(imageName: String, folderName: String) -> URL? {
        guard let folderUrl = getUrlForFolder(folderName: folderName) else { return nil }
        return folderUrl.appending(component: imageName + ".png")
    }
}
