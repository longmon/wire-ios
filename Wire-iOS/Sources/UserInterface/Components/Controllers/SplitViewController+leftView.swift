//
// Wire
// Copyright (C) 2018 Wire Swiss GmbH
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see http://www.gnu.org/licenses/.
//

import Foundation

extension SplitViewController {
    func setLeftViewControllerRevealed(_ leftViewControllerRevealed: Bool, animated: Bool, completion: (() -> Void)?) {
        if animated {
            view.layoutIfNeeded()
        }
        leftView?.isHidden = false

        resetOpenPercentage()
        if layoutSize != .regularLandscape {
            leftViewController?.beginAppearanceTransition(leftViewControllerRevealed, animated: animated)
            rightViewController?.beginAppearanceTransition(!leftViewControllerRevealed, animated: animated)
        }

        if animated {
            if leftViewControllerRevealed {
                UIApplication.shared.wr_updateStatusBarForCurrentControllerAnimated(false)
            }
            UIApplication.shared.wr_updateStatusBarForCurrentControllerAnimated(true)

            UIView.wr_animate(easing: RBBEasingFunctionEaseOutExpo, duration: 0.55, animations: {() -> Void in
                self.view.layoutIfNeeded()
            }, completion: {(_ finished: Bool) -> Void in
                if let completion = completion {
                    completion()
                }

                if self.layoutSize != .regularLandscape {
                    self.leftViewController?.endAppearanceTransition()
                    self.rightViewController?.endAppearanceTransition()
                }
                if self.openPercentage == 0 &&
                   self.layoutSize != .regularLandscape &&
                   self.leftView.layer.presentation()?.frame == self.leftView.frame {
                    self.leftView?.isHidden = true
                }
            })
        }
    }
}