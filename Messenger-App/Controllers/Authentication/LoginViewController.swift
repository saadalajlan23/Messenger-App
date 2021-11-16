import UIKit
import Firebase
//import FacebookLogin
import JGProgressHUD
class LoginViewController: UIViewController {

    private let spinner = JGProgressHUD(style: .dark)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    
    }

    @IBOutlet weak var Emailtextfield: UITextField!
    @IBOutlet weak var Passwordtextfiald: UITextField!
    @IBAction func LogInButton(_ sender: UIButton) {
        spinner.show(in:view)
        // Firebase Login
        FirebaseAuth.Auth.auth().signIn(withEmail: Emailtextfield.text!, password: Passwordtextfiald.text!, completion: {[weak self] authResult, error in

            guard let strongSelf = self else{
                return
            }
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            guard let result = authResult, error == nil else {
                print("Failed to log in user with email \(self?.Emailtextfield.text!)")
                return
            }
            let user = result.user
            print("logged in user: \(user)")
            //strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ConversationViewControllerBar")
            self?.navigationController?.pushViewController(vc, animated: true)
        })

    }
//   
//    // if not signed in, show the login screen, allow the user to sign up
//    // Firebase Login
    override func viewDidLoad() {
        super.viewDidLoad()
        Passwordtextfiald.isSecureTextEntry = true
    }
}
