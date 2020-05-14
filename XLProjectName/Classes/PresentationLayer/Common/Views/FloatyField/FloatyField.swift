//
//  FloatyField2.swift
//  Alpha
//
//  Created by Пользователь on 23.02.2020.
//  Copyright © 2020 'Mintrocket'. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

public enum FloatyFieldTypes {
    case password(showButton: Bool = true, rules: [Condition<String>])
    case email(rules: [Condition<String>])
    case text(rules: [Condition<String>])
}

public class FloatyField: LoadableView {
    @IBOutlet var wrapperField: UIView!
    @IBOutlet var borderField: UIView!
    @IBOutlet var securityButton: UIButton!
    @IBOutlet var textField: UITextField!
    @IBOutlet var placeholderLabel: UILabel!
    @IBOutlet var placeholderView: UIView!
    @IBOutlet var placeholderTopConstraint: NSLayoutConstraint!
    @IBOutlet var textFieldRightConstraint: NSLayoutConstraint!
    @IBOutlet var placeholderViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var tipLabel: UILabel!

    public var onTap: ActionFunc?

    public var type: FloatyFieldTypes = .text(rules: []) {
        didSet { configureType() }
    }
    private var validator: Validator<String>?

    public var text: String {
        get {
            return self.textField.text ?? ""
        }
        set {
            if let text = self.textField.text, text.isEmpty, !newValue.isEmpty {
                self.toggleState(state: true)
            }
            self.textField.text = newValue
        }
    }
    public var tip: String = "" {
        didSet { tipLabel.text = tip }
    }

    public var placeholder: String = "placeholder" {
        didSet { placeholderLabel.text = placeholder }
    }

    private let feedbackGenerator: UIImpactFeedbackGenerator = .init(style: .light)

    private var normalAlpha: CGFloat = 0.2
    private var openedAlpha: CGFloat = 0.5

    private var normalFont = UIFont.font(ofSize: 15, weight: .regular)
    private var openedFont = UIFont.font(ofSize: 15, weight: .bold)

    private let bag = DisposeBag()

    public override func setupNib() {
        super.setupNib()
        setupStyle()
        subscribeTextField()
        toggleState(state: false, animation: false)
        setupSecureButton()
        showTip(state: false)
    }

    // MARK: - Setup

    private func setupSecureButton() {
        securityButton.tintColor = .white
    }

    private func configureType() {
        switch type {
        case .email(let rules):
            validator = Validator(rules)
            textField.textContentType = .emailAddress
            textField.keyboardType = .asciiCapable
        case .text(let rules):
            validator = Validator(rules)
            print(type)
        case .password(let showButton, let rules):
            validator = Validator(rules)
            securityButton.isHidden = showButton ? false : true
            textField.isSecureTextEntry = true
            textField.keyboardType = .asciiCapable
            let priority: Float = showButton ? 900 : 800
            textFieldRightConstraint.priority = UILayoutPriority(rawValue: priority)
            securityButton.setImage(#imageLiteral(resourceName: "eye"), for: .normal)
        }
    }

    private func setupStyle() {
        securityButton.isHidden = true
        borderField.backgroundColor = MainTheme.shared.alphaMiddlePurpure
        wrapperField.backgroundColor = MainTheme.shared.alphaMiddlePurpure
        borderField.layer.cornerRadius = 5
        wrapperField.layer.cornerRadius = 5
        placeholderView.layer.cornerRadius = 2
        placeholderLabel.textColor = .white
        placeholderLabel.font = UIFont.font(ofSize: 15, weight: .regular)
        textField.font = UIFont.font(ofSize: 15, weight: .regular)
        textField.tintColor = MainTheme.shared.alphaBlue
        textField.textColor = .white
        tipLabel.textColor = MainTheme.shared.alphaRed
        tipLabel.font = UIFont.font(ofSize: 12, weight: .regular)
    }

    public func fetchValidationResult() -> Bool {
        guard let tip = validator?.validate(textField.text!)?.first else {
            self.tip = ""
            return true
        }
        showTip(tip: tip, state: true)
        return false
    }

    public func showTip(tip: String = "", state: Bool) {
        self.tip = tip
        borderField.backgroundColor = state ? MainTheme.shared.alphaRed : borderField.backgroundColor
        tipLabel.isHidden = !state
        if state {
            animateFail()
        }
    }

    // MARK: - Subscribe

    private func subscribeTextField() {
        textField.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { [weak self] _ in
                self?.onTap?()
                if let text = self?.textField.text,
                    text.isEmpty {
                    self?.toggleState(state: true)
                }
                self?.onTargetField(state: true)
                self?.showTip(state: false)
            })
            .disposed(by: self.bag)

        textField.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: { [weak self] _ in
                if let text = self?.textField.text,
                    text.isEmpty {
                    self?.toggleState(state: false)
                }
                self?.onTargetField(state: false)
            })
            .disposed(by: self.bag)
    }

    // MARK: - Animation

    private func toggleState(state: Bool, animation: Bool = true) {
        placeholderTopConstraint.constant = state ? -8 : 15
        placeholderViewHeightConstraint.constant = state ? 16 : 20

        UIView.animate(withDuration: animation ? 0.3 : 0) {
                self.placeholderLabel.alpha = state ? self.openedAlpha : self.normalAlpha
                self.placeholderLabel.transform = state ? CGAffineTransform(scaleX: 0.8, y: 0.8) : CGAffineTransform.identity
                self.placeholderView.backgroundColor = state ? MainTheme.shared.alphaDarkPurpure : .clear
                self.layoutIfNeeded()
            }
    }

    private func onTargetField(state: Bool) {
        borderField.backgroundColor = state ? MainTheme.shared.alphaLightPurpure : MainTheme.shared.alphaMiddlePurpure
    }

    private func animateFail() {
        let impliesAnimation = CAKeyframeAnimation(keyPath: "position.x")
        self.feedbackGenerator.prepare()
        impliesAnimation.values = [0, 5, -5, 5, -3, 2, -2, 0]
        impliesAnimation.keyTimes = [0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1]
        impliesAnimation.duration = 0.3
        impliesAnimation.isAdditive = true
        self.layer.add(impliesAnimation, forKey: nil)
        self.feedbackGenerator.impactOccurred()
    }

    @IBAction func securityButtonAction(_ sender: Any) {
        textField.isSecureTextEntry.toggle()
        let state = textField.isSecureTextEntry
        securityButton.setImage(state ? #imageLiteral(resourceName: "eye") : #imageLiteral(resourceName: "eye_close"), for: .normal)
    }
}
