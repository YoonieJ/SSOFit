//
//  PhotoStore.swift
//  SSOFit
//

import UIKit

// Profile photos live on the device only, one JPEG per uid.
enum PhotoStore {
    private static let maxSide: CGFloat = 1024

    private static func fileURL(uid: String) -> URL? {
        guard let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            return nil
        }
        return base.appendingPathComponent("ProfilePhotos", isDirectory: true).appendingPathComponent("\(uid).jpg")
    }

    static func load(uid: String) -> UIImage? {
        guard let url = fileURL(uid: uid), let data = try? Data(contentsOf: url) else {
            return nil
        }
        return UIImage(data: data)
    }

    static func save(_ image: UIImage, uid: String) throws {
        guard let url = fileURL(uid: uid) else {
            throw CocoaError(.fileWriteUnknown)
        }
        let longest = max(image.size.width, image.size.height)
        var resized = image
        if longest > maxSide {
            let scale = maxSide / longest
            let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
            let format = UIGraphicsImageRendererFormat.default()
            format.scale = 1
            resized = UIGraphicsImageRenderer(size: size, format: format).image { _ in
                image.draw(in: CGRect(origin: .zero, size: size))
            }
        }
        guard let data = resized.jpegData(compressionQuality: 0.8) else {
            throw CocoaError(.fileWriteUnknown)
        }
        try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
        try data.write(to: url, options: .atomic)
    }

    static func delete(uid: String) {
        guard let url = fileURL(uid: uid) else {
            return
        }
        try? FileManager.default.removeItem(at: url)
    }
}
