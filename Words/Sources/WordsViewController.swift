//
//  ViewController.swift
//  Words
//
//  Created by Anton Selivonchyk on 18/09/2023.
//

import UIKit
import Combine

fileprivate let topLeftPixel = CGRect(x: 0, y: 0, width: 1, height: 1)

class WordsViewController: UIViewController {
    @IBOutlet weak var filterControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!

    private var viewModel = WordsViewModel(fileName: "Romeo-and-Juliet.txt")
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupBindings()
        viewModel.loadData()
    }

    @IBAction func filterControlAction(_ sender: UISegmentedControl) {
        viewModel.apply(filter: Filter.allCases[sender.selectedSegmentIndex])
    }

    // MARK: Private interface
    private func setupBindings() {
        viewModel.$words
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.reload()
            })
            .store(in: &cancellables)
    }

    private func setupView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        filterControl.represent(type: Filter.self)
        filterControl.selectedSegmentIndex = viewModel.selectedSegmentIndex
    }

    private func reload() {
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.scrollRectToVisible(topLeftPixel, animated: true)
    }
}

extension WordsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.words.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        cell.textLabel?.text = viewModel.words[indexPath.row]
        return cell
    }
}
