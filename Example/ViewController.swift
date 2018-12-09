//
//  ViewController.swift
//  CardPresentationExample
//
//  Created by Aleksandar Vacić on 9/15/18.
//  Copyright © 2018 Aleksandar Vacić. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
	@IBOutlet private weak var defaultPopupButton: UIButton!
	@IBOutlet private weak var cardPopupButton: UIButton!

	@IBOutlet private weak var expandPopupButton: UIButton!
	@IBOutlet private weak var container: UIView!

	//	Embedded

	private var controller: PlainPopupController?

	//	View lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		let vc = PlainPopupController.instantiate()
		embed(controller: vc, into: container)
		controller = vc
	}
}

private extension ViewController {
	/// Display regular, familiar full screen popup
	///
	/// - Parameter sender: button which initiated this action
	@IBAction func popupDefault(_ sender: UIButton) {
		let vc = PlainPopupController.instantiate()
		addDismissBarButton(to: vc)

		//	wrap inside NC
		let nc = UINavigationController(rootViewController: vc)

		present(nc, animated: true)
	}

	/// Display popup as inset card
	///
	/// - Parameter sender: button which initiated this action
	@IBAction func popupCard(_ sender: UIButton) {
		let vc = PlainPopupController.instantiate()
		addDismissBarButton(to: vc)

		//	wrap inside custom NC, so we can enforce statusBarStyle
		let nc = PopupNavigationController(rootViewController: vc)
		nc.modalPresentationCapturesStatusBarAppearance = true

		presentCard(nc, animated: true)
	}

	/// Expand popup as inset card
	///
	/// - Parameter sender: button which initiated this action
	@IBAction func expandCard(_ sender: UIButton) {
		let vc = PlainPopupController.instantiate()
		vc.modalPresentationCapturesStatusBarAppearance = true

		let transitionManager = CardTransitionManager()
		let f = container.convert(sender.bounds, to: view.window!)
		transitionManager.initialTransitionFrame = f

		presentCard(vc, using: transitionManager, animated: true)
	}
}


fileprivate extension ViewController {
	/// Dismisses whatever popup is currently shown
	///
	/// - Parameter sender: An UI object that initiated dismissal
	@IBAction func dismissPopup(_ sender: Any) {
		dismiss(animated: true)
	}

	func addDismissBarButton(to vc: UIViewController) {
		//	and add Done button to dismiss the popup
		let bbi = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ViewController.dismissPopup))
		var buttonItems = vc.navigationItem.leftBarButtonItems ?? []
		buttonItems.append(bbi)
		vc.navigationItem.leftBarButtonItems = buttonItems

		//	Note: another (better) way to do this is through UIPopoverPresentationControllerDelegate methods
		//	https://stackoverflow.com/questions/15689261/modal-segue-navigation-bar-disappears
	}
}
