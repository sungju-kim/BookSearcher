//
//  MenuBar.swift
//  BookSearcher
//
//  Created by dale on 2022/10/27.
//

import UIKit
import RxSwift
import SnapKit

final class MenuBar: UIView {
    private let disposeBag = DisposeBag()

    let segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl()

        segmentControl.backgroundColor = .clear

        segmentControl.setBackgroundImage(.init(),
                                          for: .normal,
                                          barMetrics: .default)

        segmentControl.setDividerImage(.init(), forLeftSegmentState: .normal,
                                       rightSegmentState: .normal,
                                       barMetrics: .default)

        segmentControl.insertSegment(withTitle: "ebook",
                                     at: 0,
                                     animated: true)

        segmentControl.insertSegment(withTitle: "오디오북",
                                     at: 1,
                                     animated: true)

        segmentControl.selectedSegmentIndex = 0

        segmentControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.Custom.placeholder,
            NSAttributedString.Key.font: UIFont.customFont(ofSize: 16, weight: .regular)
        ], for: .normal)

        segmentControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.Custom.selectedItem,
            NSAttributedString.Key.font: UIFont.customFont(ofSize: 16, weight: .regular)
        ], for: .selected)

        return segmentControl
    }()

    private let underLineView = UnderLineView()

    private let border: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutSegmentControl()
        layoutUnderLineView()
        layoutBorder()

        segmentControl.rx.selectedSegmentIndex
            .bind(onNext: moveUnderLine)
            .disposed(by: disposeBag)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        layoutSegmentControl()
        layoutUnderLineView()
        layoutBorder()

        segmentControl.rx.selectedSegmentIndex
            .bind(onNext: moveUnderLine)
            .disposed(by: disposeBag)
    }

    private func moveUnderLine(index: Int) {
        let segmentWidth = segmentControl.frame.width / CGFloat(segmentControl.numberOfSegments)
        let leadingDistance = segmentWidth * CGFloat(index)

        UIView.animate(withDuration: 0.2) {[weak self] in
            self?.underLineView.snp.updateConstraints { make in
                make.leading.equalToSuperview().offset(leadingDistance)
            }

            self?.layoutIfNeeded()
        }
    }
}

// MARK: - Layout Section

private extension MenuBar {
    func layoutSegmentControl() {
        addSubview(segmentControl)

        segmentControl.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func layoutUnderLineView() {
        addSubview(underLineView)

        underLineView.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview()
            make.height.equalTo(4)
            make.width.equalTo(segmentControl.snp.width).dividedBy(segmentControl.numberOfSegments)
        }
    }

    func layoutBorder() {
        addSubview(border)

        border.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
