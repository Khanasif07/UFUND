/*
The MIT License (MIT)

Copyright (c) 2017 Kawoou (Jungwon An)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import UIKit

extension UIViewController {
    
    private struct AssociatedKeys {
        static var drawerController = "drawerController"
    }
    
    public internal(set) var drawerController: DrawerController? {
        get {
            guard let controller = objc_getAssociatedObject(self, &AssociatedKeys.drawerController) as? DrawerController else {
                var parentController = parent
                while let parent = parentController {
                    if let drawerController = parent.drawerController {
                        return drawerController
                    }
                    parentController = parent.parent
                }
                return nil
            }
            return controller
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.drawerController, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    ///Adds Child View Controller to Parent View Controller
   public func add(childViewController:UIViewController){
        
        self.addChild(childViewController)
        let frame = self.view.bounds

        childViewController.view.frame = frame
        self.view.addSubview(childViewController.view)
        
        childViewController.didMove(toParent: self)
    }
    
    ///Removes Child View Controller From Parent View Controller
    public var removeFromParentVC:Void{
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    
}
