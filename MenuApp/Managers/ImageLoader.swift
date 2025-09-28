//
//  ImageLoader.swift
//  MenuApp
//
//  Created by Raju Dhumne on 25/09/25.
//

import Foundation
import UIKit

// MARK: - Image Loader Protocol
protocol ImageLoaderProtocol {
    func loadImage(from url: String) async throws -> UIImage
    func cancelLoading(for url: String)
}

// MARK: - Image Loader Error
enum ImageLoaderError: LocalizedError {
    case invalidURL
    case invalidData
    case loadingCancelled
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid image URL"
        case .invalidData:
            return "Unable to load image data"
        case .loadingCancelled:
            return "Image loading was cancelled"
        }
    }
}

// MARK: - Image Loader Implementation
final class ImageLoader: ImageLoaderProtocol {
    
    private let cache = NSCache<NSString, UIImage>()
    private let session: URLSession
    private var loadingTasks: [String: Task<UIImage, Error>] = [:]
    
    init(session: URLSession = .shared) {
        self.session = session
        setupCache()
    }
    
    private func setupCache() {
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024 // 50MB
    }
    
    func loadImage(from url: String) async throws -> UIImage {
        let cacheKey = NSString(string: url)
        
        // Check cache first
        if let cachedImage = cache.object(forKey: cacheKey) {
            return cachedImage
        }
        
        // Check if already loading
        if let existingTask = loadingTasks[url] {
            return try await existingTask.value
        }
        
        // Create new loading task
        let task = Task<UIImage, Error> {
            defer { loadingTasks.removeValue(forKey: url) }
            
            guard let imageURL = URL(string: url) else {
                throw ImageLoaderError.invalidURL
            }
            
            let (data, _) = try await session.data(from: imageURL)
            
            guard let image = UIImage(data: data) else {
                throw ImageLoaderError.invalidData
            }
            
            // Cache the image
            cache.setObject(image, forKey: cacheKey)
            
            return image
        }
        
        loadingTasks[url] = task
        
        do {
            let image = try await task.value
            return image
        } catch {
            throw error
        }
    }
    
    func cancelLoading(for url: String) {
        loadingTasks[url]?.cancel()
        loadingTasks.removeValue(forKey: url)
    }
}

// MARK: - UIImageView Extension
extension UIImageView {
    private static var imageLoader = ImageLoader()
    private static var loadingTask: Task<Void, Never>?
    
    func loadImage(from urlString: String) {
        // Cancel previous loading task
        Self.loadingTask?.cancel()
        
        // Set placeholder or loading state
        self.image = UIImage(systemName: "photo")
        
        Self.loadingTask = Task { [weak self] in
            do {
                let image = try await Self.imageLoader.loadImage(from: urlString)
                
                // Check if task was cancelled
                guard !Task.isCancelled else { return }
                
                await MainActor.run {
                    self?.image = image
                }
            } catch {
                // Check if task was cancelled
                guard !Task.isCancelled else { return }
                
                await MainActor.run {
                    self?.image = UIImage(systemName: "photo.badge.exclamationmark")
                }
            }
        }
    }
    
    func cancelImageLoading() {
        Self.loadingTask?.cancel()
        Self.loadingTask = nil
    }
}

