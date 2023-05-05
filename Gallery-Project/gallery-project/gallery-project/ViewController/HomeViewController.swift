//
//  HomeVC.swift
//  gallery-project
//
//  Created by Ankush Sharma on 13/04/23.
//


import UIKit

enum controllerViewType: String{
    case profile = "Account Details"
    case setting = "Settings"
    case privacy = "Privacy"
    case feedback = "Feedback"
    case rate = "Rate"
    case signout = "SignOut"
}

class HomeViewController: BaseViewController , UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    // MARK: IBOutlets and variable declaration
    var imagePicker = UIImagePickerController()
    var itemHeight: Int = 0
    var currentIndex: Int = 0
    var isSlideHidden = false
    @IBOutlet weak var assertBgView: UIView!
    @IBOutlet weak var slideMenuView: SlideMenu!
    @IBOutlet private weak var firstCollectionView: UICollectionView!
    @IBOutlet private weak var viewHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var uploadBttn: UIButton!
    @IBOutlet private weak var secondCollectionView: UICollectionView!
    
    var uploadImage: UIImage?
    var imageData: [Datum] = []
    var imageDatas = [UIImage(named: "null-data")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLayout()
        self.getImageAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //    MARK: DashBoard Menu Action
    @IBAction func dashboardAction(_ sender: Any){
        self.slideMenuView.delegate = self
        self.showHideSlideMenu(isHidden: isSlideHidden)
    }
    
    //   MARK: Upload image Action
    @IBAction func uploadImageAction(_ sender: UIButton) {
        // setting picker delegates and source
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    // image picking
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.showActivityIndicator(titleMessage: Constant.isImageUploading)
            
            self.uploadImageAPI(image: image)
            viewHeight.constant  = CGFloat((Double(self.imageData.count) / 2.0).rounded())  * (UIScreen.main.bounds.width + 20) / 2.0
        }
        self.firstCollectionView.reloadData()
        self.secondCollectionView.reloadData()
        
    }
    
}


extension HomeViewController: PassDataDelegate{
    func sendData(indexPath: String) {

        switch indexPath {
        case controllerViewType.profile.rawValue:
            let push =  self.storyboard?.instantiateViewController(withIdentifier: "ProfileDetailVC") as! ProfileDetailVC
            self.navigationController?.pushViewController(push, animated: true)
        
        case controllerViewType.privacy.rawValue:
            if let url = URL(string: "https://www.q-tickets.com/Content/PrivacyPolicy") {
                UIApplication.shared.open(url)
            }
            
        case controllerViewType.feedback.rawValue:
            let push =  self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            self.navigationController?.pushViewController(push, animated: true)

            
        case controllerViewType.signout.rawValue:
            let push =  self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(push, animated: true)
            

        default:
            print("something went wrong")
        }
    }
    
    
}

extension HomeViewController{
    //   MARK: fetch images from API
    func getImageAPI(){
        let token =  UserDefaults.standard.object(forKey: "token")
        
        DispatchQueue.global().async {
            APIManager.getImageRequestAPI(token: token as! String, completion: { completeData in
                self.imageData = completeData.data
                DispatchQueue.main.async { [self] in
                    viewHeight.constant  = CGFloat((Double(self.imageData.count) / 2.0).rounded())  * (UIScreen.main.bounds.width + 20) / 2.0
                    self.firstCollectionView.reloadData()
                    self.secondCollectionView.reloadData()
                }
            })
        }
    }
    
    func uploadImageAPI(image: UIImage){
        let token =  UserDefaults.standard.object(forKey: "token")
        DispatchQueue.global().async {
        APIManager.uploadImageRequestAPI(token: token as! String , selectedProfile: image, completion: {statusCode, message in
            if statusCode == 200{
                DispatchQueue.main.async { [self] in
                    self.hideActivityIndicator()
                    AlertController.alertWithCompletionHandler(title: Constant.success, message: message, viewController: self, completionOnOkButton: {
                        self.getImageAPI()
                        self.firstCollectionView.reloadData()
                        self.secondCollectionView.reloadData()
                    })
                }
            }
        })
        }
    }
}


// MARK: CollectionView delegate methods
extension HomeViewController : UICollectionViewDelegate , UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imageData.isEmpty{
            return 1
        }
        else{
            return imageData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.firstCollectionView{
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
            if self.imageData.isEmpty{
                cell1.firstImageVw.image = UIImage(named: "emptyImage")
                return cell1
            }
            cell1.setData(obj: self.imageData[indexPath.row])
            return cell1
        }else{
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "SecondViewCell", for: indexPath) as! SecondViewCell
            if self.imageData.isEmpty{
                cell2.secondImageVw.image = UIImage(named: "emptyImage")
                return cell2
            }
            cell2.setData(obj: self.imageData[indexPath.row])
            return cell2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageVc = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
        if self.imageData.isEmpty{
            imageVc.newImage = ""
        }
        else{
            imageVc.newImage = self.imageData[indexPath.row].userImage
            imageVc.imageId = self.imageData[indexPath.row].id
        }
        self.navigationController?.pushViewController(imageVc, animated: true)
    }
} // extension body end

//MARK: Collection view delegate for FlowLayout and cell sizing
extension HomeViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.firstCollectionView{
            if self.imageData.isEmpty{
                let width = (collectionView.frame.size.width)
                let height = (collectionView.frame.size.width)
                return CGSize(width: width, height: height)
            }else{
                let width = (collectionView.frame.size.width)
                let height = (collectionView.frame.size.width)
                return CGSize(width: width, height: height)
            }
        }else{
            if self.imageData.isEmpty{
                let width = (collectionView.frame.size.width)
                let height = (collectionView.frame.size.width)
                return CGSize(width: width, height: height)
            }else{
                let height = (collectionView.frame.size.width + 20) / 2
                let width = (collectionView.frame.size.width - 10) / 2
                return CGSize(width: width, height: height)
            }
        }
    } // function body end
    
} // extension body end

// MARK: Initial layout setup
extension HomeViewController{
    // layout setup
    func setLayout(){
        self.firstCollectionView.delegate = self
        self.firstCollectionView.dataSource = self
        
        self.secondCollectionView.delegate = self
        self.secondCollectionView.dataSource = self
        
        self.uploadBttn.layer.cornerRadius = min(self.uploadBttn.frame.size.height,self.uploadBttn.frame.size.width) / 2.0
        self.uploadBttn.layer.borderWidth = 1
        //        let timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(imageSlideToNext), userInfo: nil, repeats: true)
        //        self.view.setNeedsLayout()
    }
    
    // method for image sliding
    @objc func imageSlideToNext(){
        if currentIndex < self.imageData.count - 1 {
            currentIndex += 1
        }else{
            currentIndex = 0
        }
        self.firstCollectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .right, animated: true)
    }
//    SlideMenu show hide action
    func showHideSlideMenu(isHidden: Bool){
        if isSlideHidden{
            SlideMenu.animate(withDuration: 0.5, animations: { [self] in
                    slideMenuView.frame.origin.x = -slideMenuView.frame.width
                })
            self.slideMenuView.isHidden = true
            self.isSlideHidden = false
        }else{
            SlideMenu.animate(withDuration: 0.2, animations: { [self] in
                    slideMenuView.frame.origin.x = +slideMenuView.frame.width
                })
            self.slideMenuView.isHidden = false
            self.isSlideHidden = true
        }
    }
}


// MARK: Top Collection view cell class

class CollectionViewCell : UICollectionViewCell {
    
    @IBOutlet weak var firstImageVw: UIImageView!
    func setData(obj: Datum) {
        if obj.userImage.contains("https://localhost:7184/") {
            let newImageUrl = obj.userImage.replacingOccurrences(of: "https://localhost:7184/", with: Constant.BASE_URL)
            self.firstImageVw.setImageData(urlStr: newImageUrl)
        }else{
            self.firstImageVw.setImageData(urlStr: obj.userImage)
        }
    }
}


// MARK: Main Collection View inside tableView
class SecondViewCell : UICollectionViewCell{
    
    @IBOutlet weak var secondImageVw: UIImageView!
    
    func setData(obj: Datum) {
        if obj.userImage.contains("https://localhost:7184/") {
            let newImageUrl = obj.userImage.replacingOccurrences(of: "https://localhost:7184/", with: Constant.BASE_URL)
            self.secondImageVw.setImageData(urlStr: newImageUrl)
        }else{
            self.secondImageVw.setImageData(urlStr: obj.userImage)
        }
    }
}


