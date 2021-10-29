//
// Copyright © 2021 GetYourGuide. All rights reserved.
//

import UIKit
import Networking

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let networkClient = NetworkClient(urlSession: URLSession.shared)
        let reviewsNetworkClient = ReviewsNetworkClient(networkClient: networkClient)
        let reviewsRepository = ReviewsRepository(networkClient: reviewsNetworkClient)
        let viewModel = ReviewsViewModel(activityID: 23776, reviewsRepository: reviewsRepository)
        let rootViewController = ReviewsViewController(viewModel: viewModel)

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        self.window = window

        return true
    }
}
