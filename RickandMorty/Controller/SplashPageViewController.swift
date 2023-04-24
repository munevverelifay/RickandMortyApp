//
//  SplashPageViewController.swift
//  RickandMorty
//
//  Created by Münevver Elif Ay on 5.04.2023.
//
import UIKit
import Lottie
private var animationView: LottieAnimationView?
class SplashPageViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addRickAndMortyText()
        setupSplashLabel()
        addRickAndMortyImage()
        //MARK: - setTimer
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            if let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomePageViewController") as? HomePageViewController {
                self.navigationController?.pushViewController(homeVC, animated: true)
            }
        }
    }
    private func setupSplashLabel() {
        let firstLaunch = UserDefaults.standard.bool(forKey: "FirstLaunch")
        if firstLaunch {
            animationView = .init(name: "Hello!.json")
            animationView!.animationSpeed = 1.0
            setupSplashAnimation()
        } else {
            animationView = .init(name: "Welcome!.json")
            animationView!.animationSpeed = 0.7
            UserDefaults.standard.set(true, forKey: "FirstLaunch")
            setupSplashAnimation()
        }
    }
    func setupSplashAnimation() {
        animationView!.frame = view.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.center = CGPoint(x: view.center.x, y: view.center.y + 250)
        animationView!.loopMode = .loop
        view.addSubview(animationView!)
        animationView!.play()
    }
    func addRickAndMortyText() {
        let rickAndMortyText = UIImageView(image: UIImage(named: "RickAndMortyText"))
        rickAndMortyText.translatesAutoresizingMaskIntoConstraints = false
        rickAndMortyText.contentMode = .scaleAspectFit
        view.addSubview(rickAndMortyText)
        NSLayoutConstraint.activate([
            rickAndMortyText.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -280),
            rickAndMortyText.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            rickAndMortyText.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            rickAndMortyText.widthAnchor.constraint(equalToConstant: self.view.frame.width-40)
        ])
    }
    func addRickAndMortyImage() {
        let rickAndMortyImage = UIImageView(image: UIImage(named: "RMISplashImage"))
        rickAndMortyImage.translatesAutoresizingMaskIntoConstraints = false
        rickAndMortyImage.contentMode = .scaleAspectFit
        view.addSubview(rickAndMortyImage)
        NSLayoutConstraint.activate([
            rickAndMortyImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0),
            rickAndMortyImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            rickAndMortyImage.widthAnchor.constraint(equalToConstant: 350),
            rickAndMortyImage.heightAnchor.constraint(equalToConstant: 350)
        ])
    }
}
