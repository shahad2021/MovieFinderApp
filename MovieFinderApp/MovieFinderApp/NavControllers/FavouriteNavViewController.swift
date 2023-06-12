import Foundation
import UIKit

class FavouriteNavViewController: UINavigationController {
    init() {
        super.init(nibName: nil, bundle: nil)
        setNavigationBarHidden(true, animated: true)
        let vc = FavouriteViewController(viewModel: FavouriteViewModel())
        viewControllers = [vc]
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
}
