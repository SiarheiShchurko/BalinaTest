

import UIKit

class RootVC: UIViewController {
    // MARK: - Properties
    private let viewModel: RootProtocol
    private let imagePicker: UIImagePickerController
    private var developerName: String = ""
    private var developerId: Int32 = -1
    
    // MARK: - Labels
    private let headerLabel = UniversalLabel(text: "Developers",
                                             textColor: .black,
                                             font: .boldSystemFont(ofSize: 28),
                                             textAlign: .left,
                                             autoresizingMask: false)
    
    private let successLabel = UniversalLabel(text: "Success",
                                              textColor: .green,
                                              font: .boldSystemFont(ofSize: 28),
                                              textAlign: .center,
                                              autoresizingMask: false)
    
    // MARK: - ImageView
    private let successImage = SimpleImageView(image: UIImage(systemName: "checkmark.circle")?.withTintColor(.green, renderingMode: .alwaysOriginal) ?? UIImage(),
                                               contentMode: .scaleAspectFit,
                                               autoresizingMask: false)
    
    private lazy var successStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [successImage, successLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .lightGray.withAlphaComponent(0.8)
        stack.layer.cornerRadius = 12
        stack.axis = .vertical
        stack.spacing = 4
        stack.isHidden = true
        return stack
    }()
    
    
    // MARK: - TableView
    private let developersTableView = MainTableView(color: .white,
                                                    registerClass: DeveloperCell.self,
                                                    cell: "\(DeveloperCell.self)",
                                                    rowHeigh: 110)
    
    // MARK: - Init
    init(viewModel: RootProtocol,
         imagePicker: UIImagePickerController) {
        self.viewModel = viewModel
        self.imagePicker = imagePicker
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - VC cycles methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // # 1
        view.backgroundColor = .white
        // # 2
        bind()
        developersTableView.dataSource = self
        developersTableView.delegate = self
        imagePicker.delegate = self
        // # 3
        addSubviews()
        constraints()
    }
}

// MARK: Bind
private extension RootVC {
    func bind() {
        viewModel.update = { [ weak self ] in
            DispatchQueue.main.async {
                self?.developersTableView.reloadData()
            }
        }
        viewModel.receiveError = { [ weak self ] message in
            DispatchQueue.main.async {
                self?.showAlert(message: message)
            }
        }
        viewModel.successfulSubmission = { [ weak self ] in
            self?.animate()
        }
    }
}

// MARK: - Action
private extension RootVC {
    func openCamera() {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        DispatchQueue.main.async { [ weak self ] in
            guard let self else {
                return
            }
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
}

// MARK: - Animate
private extension RootVC {
    func animate() {
        DispatchQueue.main.async { [ weak self ] in
            self?.successStack.isHidden = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3 ) {
            UIView.animate(withDuration: 2) { [ weak self ] in
                self?.successStack.isHidden = true
            }
        }
    }
}
// MARK: - AddSubviews
private extension RootVC {
    func addSubviews() {
        view.addSubview(headerLabel)
        view.addSubview(developersTableView)
        view.addSubview(successStack)
    }
}

// MARK: - Constraints
private extension RootVC {
    func constraints() {
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            developersTableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 32),
            developersTableView.leadingAnchor.constraint(equalTo: headerLabel.leadingAnchor),
            developersTableView.trailingAnchor.constraint(equalTo: headerLabel.trailingAnchor),
            developersTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            successStack.topAnchor.constraint(equalTo: view.centerYAnchor),
            successStack.leadingAnchor.constraint(equalTo: developersTableView.leadingAnchor, constant: 32),
            successStack.trailingAnchor.constraint(equalTo: developersTableView.trailingAnchor, constant: -32),
            successStack.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}

// MARK: - TableView
extension RootVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.developersArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(DeveloperCell.self)", for: indexPath) as? DeveloperCell else {
            return UITableViewCell()
        }
        let currentDeveloper = viewModel.developersArray[indexPath.row]
        cell.setDeveloper(cell: currentDeveloper)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        developerName = viewModel.developersArray[indexPath.row].name
        developerId = viewModel.developersArray[indexPath.row].id
        openCamera()
    }
}

// MARK: - ImagePickerDelegate
extension RootVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // # 1
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let fileName = UUID().uuidString + ".jpg"
            // # 2
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                
                let fileURL = documentsDirectory.appendingPathComponent(fileName)
                if let data = image.jpegData(compressionQuality: 3) {
                    do {
                        try data.write(to: fileURL)
                        viewModel.sendDeveleper(name: developerName, id: developerId, filePathKey: fileURL.path)
                        
                    } catch {
                        print("Miss saving image: \(error)")
                    }
                }
                dismiss(animated: true, completion: nil)
            }
        }
    }
}
