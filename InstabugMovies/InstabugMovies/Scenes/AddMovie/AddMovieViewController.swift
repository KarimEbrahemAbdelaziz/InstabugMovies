//
//  AddMovieViewController.swift
//  InstabugMovies
//
//  Created by Karim Ebrahem on 3/24/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

import UIKit

class AddMovieViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    // MARK: - IBOutlets
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var overviewTextField: UITextField!
    @IBOutlet weak var releaseDatePicker: UIDatePicker!
    @IBOutlet weak var moviePosterImageView: UIImageView!
    
    // MARK: - Properties
    
    var configurator: AddMovieConfigurator!
    var presenter: AddMoviePresenter!
    
    private var moviePosterImagePickedURL: URL?
    private var imagePicker = UIImagePickerController()
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configurator.configure(addMovieViewController: self)
        releaseDatePicker.minimumDate = presenter.manimumReleaseDate
        moviePosterImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectMoviePoster)))
    }
    
    // MARK: - IBActions
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        guard let movieTitle = titleTextField.text, !movieTitle.isEmpty else {
            presentAlert(withTitle: "Movie Title Required", message: "Please enter a title for your awesome movie 🔥.")
            return
        }
        guard let movieOverview = overviewTextField.text, !movieOverview.isEmpty else {
            presentAlert(withTitle: "Movie Overview Required", message: "Please enter an overview for your awesome movie 🔥.")
            return
        }
        let addMovieParameters = AddMovieParameters(id: -1, title: movieTitle, overview: movieOverview, date: releaseDatePicker.date.description == "" ? Date().description : releaseDatePicker.date.description, poster: (moviePosterImagePickedURL?.absoluteString) ?? "")
        presenter.addButtonPressed(parameters: addMovieParameters)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        presenter.cancelButtonPressed()
    }
    
    // MARK: - Private functions
    
    @objc private func selectMoviePoster() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.moviePosterImageView.image = pickedImage
            if #available(iOS 11.0, *) {
                self.moviePosterImagePickedURL = info[UIImagePickerController.InfoKey.imageURL] as? URL
            }
        }
        
        dismiss(animated: true, completion: nil)
    }

}

// MARK: - AddMovieView Protocol Functions

extension AddMovieViewController: AddMovieView {
    func updateAddButtonState(isEnabled enabled: Bool) {
        self.saveButton.isEnabled = enabled
    }
    
    func updateCancelButtonState(isEnabled enabled: Bool) {
        self.cancelButton.isEnabled = enabled
    }
    
    func displayAddMovieError(title: String, message: String) {
        presentAlert(withTitle: title, message: message)
    }
}
