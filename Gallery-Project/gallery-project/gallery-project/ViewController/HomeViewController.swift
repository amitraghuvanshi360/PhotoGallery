//
//  HomeVC.swift
//  gallery-project
//
//  Created by Ankush Sharma on 13/04/23.
//


import UIKit

enum controllerViewType: String{
    case profile = "Account Details"
    case setting = "Change Password"
    case privacy = "Privacy"
    case feedback = "Feedback"
    case rate = "Rate"
    case callUs = "Call Us"
    case signout = "SignOut"
}

class HomeViewController: BaseViewController , UIImagePickerControllerDelegate & UINavigationControllerDelegate , passSenderDelegate{
    
    
    // MARK: IBOutlets and variable declaration
    var imagePicker = UIImagePickerController()
    var itemHeight: Int = 0
    var currentIndex: Int = 0
    var imageId: Int = 0
    var deleteImgIndex:Int = 0
    var indexPathRow =  IndexPath()
    var isSlideHidden = false
    @IBOutlet weak var menuBttn: UIButton!
    @IBOutlet private weak var assertBgView: UIView!
    @IBOutlet private weak var slideMenuView: SlideMenu!
    @IBOutlet private weak var firstCollectionView: UICollectionView!
    @IBOutlet private weak var viewHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var uploadBttn: UIButton!
    @IBOutlet private weak var secondCollectionView: UICollectionView!
    
    var uploadImage: UIImage?
    var imageData: [ImageCollection] = []
    var isImageEmpty:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden  = true
        self.setLayout()
        self.getImageAPI()
    }
    
    
    //    MARK: DashBoard Menu hide show Action
    @IBAction func dashboardAction(_ sender: Any){
        self.slideMenuView.delegate = self
        // show hide slide menu action
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
    
    func imageDeletion(cell: SecondViewCell) {
        if let indexPath = self.secondCollectionView.indexPath(for: cell){
            let token = UserDefaults.standard.object(forKey: "token")
            if !self.imageData.isEmpty{
                self.deleteImageAPI(authToken: token as! String, imageId: self.imageData[indexPath.row].id)
                self.imageData.remove(at: indexPath.row)
                self.secondCollectionView.deleteItems(at: [indexPath])
                self.firstCollectionView.deleteItems(at: [indexPath])
            }
        }
    }
    
}
// MARK: image picker delegates
extension HomeViewController{
    // image picking
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.showActivityIndicator(titleMessage: Constant.isImageUploading)
            self.uploadImageAPI(image: image)
            viewHeight.constant  = CGFloat((Double(self.imageData.count) / 2.0).rounded())  * (UIScreen.main.bounds.width + 20) / 2.0
        }
    }
}

// MARK: Dashboard selection action
extension HomeViewController: PassDataDelegate{
    func sendData(indexPath: String) {
        
        switch indexPath {
            // display profile details
        case controllerViewType.profile.rawValue:
            let pushVC =  self.storyboard?.instantiateViewController(withIdentifier: "ProfileDetailVC") as! ProfileDetailVC
            self.navigationController?.pushViewController(pushVC, animated: true)
            
            // display setting menu
        case controllerViewType.setting.rawValue:
            let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
            self.navigationController?.pushViewController(pushVC, animated: true)
            
            // privacy policy
        case controllerViewType.privacy.rawValue:
            if let url = URL(string: "https://www.q-tickets.com/Content/PrivacyPolicy") {
                UIApplication.shared.open(url)
            }
            
            //  display feedback
        case controllerViewType.feedback.rawValue:
            let pushVC =  self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            self.navigationController?.pushViewController(pushVC, animated: true)
            
            // display rating page
        case controllerViewType.rate.rawValue:
            if let url = URL(string: "https://apps.apple.com/in/app/qtickets/") {
                UIApplication.shared.open(url)
            }
            
            // call & support
        case controllerViewType.callUs.rawValue:
            if let url = NSURL(string: "tel://\(9131347960)"), UIApplication.shared.canOpenURL(url as URL) {
                UIApplication.shared.open(url as URL)
            }
            
            // logout from application
        case controllerViewType.signout.rawValue:
            let pushVC =  self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(pushVC, animated: true)
            
        default:
            print("something went wrong")
        }
    }
    
}

extension HomeViewController{
    //   MARK: fetch images from API
    func getImageAPI(){
        let token =  UserDefaults.standard.object(forKey: "token")
        
        guard let authToken = token else {
            return
        }
        
        DispatchQueue.global().async {
            APIManager.getImageRequestAPI(token: token as! String, completion: { completeData in
                self.imageData = completeData.data ?? []
                DispatchQueue.main.async { [self] in
                    viewHeight.constant  = CGFloat((Double(self.imageData.count) / 2.0).rounded())  * (UIScreen.main.bounds.width + 20) / 2.0
                    self.firstCollectionView.reloadData()
                    self.secondCollectionView.reloadData()
                }
            })
        }
    }
    
    //    MARK: Upload image API
    func uploadImageAPI(image: UIImage){
        let token =  UserDefaults.standard.object(forKey: "token")
        DispatchQueue.global().async {
            APIManager.uploadImageRequestAPI(token: token as! String , selectedProfile: image, completion: {statusCode, message in
                if statusCode == 200{
                    DispatchQueue.main.async { [self] in
                        self.hideActivityIndicator()
                        AlertController.alertWithCompletionHandler(title: Constant.success, message: message, viewController: self, completionOnOkButton: {
                            self.getImageAPI()
                        })
                    }
                }
            })
        }
    }
    //    MARK: Delete image API request
    func deleteImageAPI(authToken: String , imageId: Int){
        DispatchQueue.global().async { [self] in
            APIManager.deleteImageRequestAPI(token: authToken as! String, id: imageId , completion: { [self] statusCode , message in
                print(statusCode , message , self.imageId)
                DispatchQueue.main.async {
                    if statusCode == 200{
                        AlertController.alertWithCompletionHandler(title: Constant.success, message: message, viewController: self, completionOnOkButton: {
                        })
                    }else if statusCode == 400{
                        AlertController.alertWithCompletionHandler(title: Constant.error, message: message, viewController: self, completionOnOkButton: {
                            print("print error while deleting image")
                        })
                    }else {
                        AlertController.CreateAlertMessage(title: Constant.error, message: Constant.isInvalid, viewController: self)
                    }
                }
            })
        }
    }
}


// MARK: CollectionView delegate methods
extension HomeViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    
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
            if self.imageData.count == 0{
                cell1.firstImageVw.image = UIImage(named: "null-data")
                cell1.firstImageVw.contentMode = .scaleAspectFit
                return cell1
            }else{
                cell1.setData(obj: self.imageData[indexPath.row])
                return cell1
            }
        }else{
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "SecondViewCell", for: indexPath) as! SecondViewCell
            if self.imageData.count == 0{
                cell2.secondImageVw.image = UIImage(named: "null-data")
                cell2.secondImageVw.contentMode = .scaleAspectFit
                return cell2
            }else{
                self.deleteImgIndex = indexPath.row
                self.indexPathRow = indexPath
                cell2.delegate = self
                self.imageId = self.imageData[indexPath.row].id
                cell2.setData(obj: self.imageData[indexPath.row])
                
                return cell2
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageVc = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
        //        if !self.imageData.isEmpty{
        //            self.imageData.remove(at: indexPath.row)
        //            print(indexPath.row)
        //            self.secondCollectionView.deleteItems(at: [indexPath])
        //            self.firstCollectionView.deleteItems(at: [indexPath])
        //        }
        //        self.navigationController?.pushViewController(imageVc, animated: true)
    }
    
} // extension body end

//MARK: Collection view delegate for FlowLayout and cell sizing
extension HomeViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.firstCollectionView{
            if self.imageData.isEmpty{
                let width = (collectionView.frame.size.width)
                let height = (collectionView.frame.size.height)
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
    // layout and delegate setup
    func setLayout(){
        self.firstCollectionView.delegate = self
        self.firstCollectionView.dataSource = self
        
        self.secondCollectionView.delegate = self
        self.secondCollectionView.dataSource = self
        self.uploadBttn.layer.cornerRadius = min(self.uploadBttn.frame.size.height,self.uploadBttn.frame.size.width) / 2.0
        self.uploadBttn.layer.borderWidth = 1
        let timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(imageSlideToNext), userInfo: nil, repeats: true)
        self.view.setNeedsLayout()
    }
    //    To hide Slidemenu when view touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isSlideHidden{
            self.showHideSlideMenu(isHidden: false)
        }
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
    //    IBOutlets and variable declaration
    @IBOutlet weak var firstImageVw: UIImageView!
    func setData(obj: ImageCollection) {
        if obj.userImage.contains("https://localhost:7184/") {
            let newImageUrl = obj.userImage.replacingOccurrences(of: "https://localhost:7184/", with: Constant.BASE_URL)
            self.firstImageVw.setImageData(urlStr: newImageUrl)
        }else{
            self.firstImageVw.setImageData(urlStr: obj.userImage)
        }
    }
}

// MARK: Main Collection View inside tableView
protocol passSenderDelegate{
    func imageDeletion(cell : SecondViewCell)
}

class SecondViewCell : UICollectionViewCell{
    
    //     outlets and variables
    @IBOutlet weak var deleteBttn: UIButton!
    @IBOutlet weak var secondImageVw: UIImageView!
    var delegate: passSenderDelegate?
    
    //    Set data to imageView
    func setData(obj: ImageCollection) {
        if obj.userImage.contains("https://localhost:7184/") {
            let newImageUrl = obj.userImage.replacingOccurrences(of: "https://localhost:7184/", with: Constant.BASE_URL)
            self.secondImageVw.setImageData(urlStr: "http://192.168.1.148:5181/Resources/ProfileImages/ce2a3835-9d77-4dbc-837b-c6e249b953f4.jpg")
        }else{
            self.secondImageVw.setImageData(urlStr: obj.userImage)
        }
    }
    
    //     delete button action
    @IBAction func deleteButtonAction(_ sender: UIButton) {
        delegate?.imageDeletion(cell: self)
    }
}
