
import UIKit
import Foundation

fileprivate var bottomConstraint : NSLayoutConstraint?
fileprivate var imageCompletion : ((UIImage?)->())?
fileprivate var constraintValue : CGFloat = 0

extension UIViewController {
    
  
    
    func setPresenter(){
        
        if let view = self as? PresenterOutputProtocol {
            
            view.presenter = presenterObject
            view.presenter?.view = view
            presenterObject = view.presenter
            
        }
    }
    
    //MARK:- Pop or dismiss View Controller
    
    func popOrDismiss(animation : Bool){
        
        DispatchQueue.main.async {
            
            if self.navigationController != nil {
                
                self.navigationController?.popViewController(animated: animation)
            } else {
                
                self.dismiss(animated: animation, completion: nil)
            }
            
        }
        
    }
    
    //MARK:- Present
    
    func present(id : String, animation : Bool){
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: id){
            self.present(vc, animated: animation, completion: nil)
        }
        
    }
    
    //MARK:- Push
    
    func push(id : String, animation : Bool, from storyboard : UIStoryboard = Router.main){
        
        let vc = storyboard.instantiateViewController(withIdentifier: id)
        self.navigationController?.pushViewController(vc, animated: animation)
        
        
    }
    
    //MARK:- Push To Right
    
    func pushRight(toViewController viewController : UIViewController){
        
        self.makePush(transition: CATransitionSubtype.fromLeft.rawValue)
        navigationController?.pushViewController(viewController, animated: false)
        
    }
    
    private func makePush(transition type : String){
        
        let transition = CATransition()
        transition.duration = 0.45
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype(rawValue: type)
        //transition.delegate = self
        navigationController?.view.layer.add(transition, forKey: nil)
        //navigationController?.isNavigationBarHidden = false
        
    }
    
    func popLeft() {
        
        self.makePush(transition: CATransitionSubtype.fromRight.rawValue)
        navigationController?.popViewController(animated: true)
        
    }
    
    
    //MARK:- Add observers
    
    func addKeyBoardObserver(with constraint : NSLayoutConstraint){
        
        bottomConstraint = constraint
        constraintValue = constraint.constant
    }
    
    //MARK:- Keyboard will show
    
    @IBAction private func keyboardWillShow(info : NSNotification){
        
        guard let keyboard = (info.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        bottomConstraint?.constant = -(keyboard.height)
        self.view.layoutIfNeeded()
    }
    
    
    //MARK:- Keyboard will hide
    
    @IBAction private func keyboardWillHide(info : NSNotification){
        
        bottomConstraint?.constant = constraintValue
        self.view.layoutIfNeeded()
        
    }
    
    
    //MARK:- Back Button Action
    
    @IBAction func backButtonClick() {
        
        self.popOrDismiss(animation: true)
        
    }
    
   
    //MARK:- Show Image Selection Action Sheet
    
    func showImage(with completion : @escaping ((UIImage?)->())){
        
        var alertStyle = UIAlertController.Style.actionSheet
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            alertStyle = UIAlertController.Style.alert
        }
        
        let alert = UIAlertController(title: Constants.string.selectSource, message: nil, preferredStyle: alertStyle)
        alert.addAction(UIAlertAction(title: Constants.string.camera, style: .default, handler: { (Void) in
            self.chooseImage(with: .camera)
        }))
        alert.addAction(UIAlertAction(title: Constants.string.photoLibrary, style: .default, handler: { (Void) in
            self.chooseImage(with: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: Constants.string.Cancel, style: .cancel, handler:nil))
        alert.view.tintColor = .primary
        imageCompletion = completion
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    //MARK:- Show Image Picker
    
    private func chooseImage(with source : UIImagePickerController.SourceType){
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = source
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    
   
    
    
    //MARK:- Show Search Bar with self delegation
    
    @IBAction private func showSearchBar(){
        
        let searchBar = UISearchController(searchResultsController: nil)
        searchBar.searchBar.delegate = self as? UISearchBarDelegate
        searchBar.hidesNavigationBarDuringPresentation = false
        searchBar.searchBar.tintColor = .primary
        self.present(searchBar, animated: true, completion: nil)
        
    }
    
    
    
}

//MARK:- UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension UIViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true) {
            if  let image = info[.editedImage] as? UIImage {
             imageCompletion?(image)
            }
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}






extension UIViewController {
    
    // Not using static as it wont be possible to override to provide custom storyboardID then
    
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        
        return appStoryboard.viewController(self)
    }
    
    ///Not using static as it won't be possible to override to provide custom storyboardID then
    class var storyboardID : String {
        
        return "\(self)"
    }
}


enum AppStoryboard : String {
    
    case Main , Products , Filter , Wallet
}

extension AppStoryboard {

    var instance : UIStoryboard {
        
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(_ viewControllerClass : T.Type,
                        function : String = #function, // debugging purposes
                        line : Int = #line,
                        file : String = #file) -> T {
        
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        
        return scene
    }
    
    func initialViewController() -> UIViewController? {
        
        return instance.instantiateInitialViewController()
    }
}
