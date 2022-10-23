protocol UnsplashManagerDelegate {
    func didUpdateImage(_ unsplashManager: UnsplashManager, unsplashModel: UnsplashModel)
    func didFailWithError(error: Error)
}
