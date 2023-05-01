//
//  HomeVC.swift
//  gallery-project
//
//  Created by Ankush Sharma on 13/04/23.
//


import UIKit



class HomeViewController: BaseViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate{

    // MARK: IBOutlets and variable decleration
    
    var imagePicker = UIImagePickerController()
    var itemHeight: Int = 0
    var currentIndex: Int = 0
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
//        self.deleteImageAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            let token =  UserDefaults.standard.object(forKey: "token")
            APIManager.uploadImageRequestAPI(token: token as! String , selectedProfile: image, completion: {_,_ in

            })
            viewHeight.constant  = CGFloat((Double(self.imageData.count) / 2.0).rounded())  * (UIScreen.main.bounds.width + 20) / 2.0
//            self.imageData.reverse()
        }
        self.firstCollectionView.reloadData()
        self.secondCollectionView.reloadData()

    }
    
}

extension HomeViewController{
    func getImageAPI(){
        let token =  UserDefaults.standard.object(forKey: "token")
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
}


// MARK: Top Collection view cell class

class CollectionViewCell : UICollectionViewCell {
    
    @IBOutlet  weak var firstImageVw: UIImageView!
    
    
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


