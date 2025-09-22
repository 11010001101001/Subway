import UIKit
import Foundation

final class MapViewController: UIViewController {
    private lazy var builtPathbutton = makeButton(title: "Построить", action: #selector(builtPathTapped))
    private lazy var cancelButton = makeButton(title: "Сброс", action: #selector(cancelButtonTapped))
    private lazy var detailsButton = makeButton(title: "Подробнее", action: #selector(showDetailsTapped))

    private lazy var mapScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.delegate = self
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    private lazy var map: BezierCurves = {
        let view = BezierCurves()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var hStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [builtPathbutton, cancelButton])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = Constants.stackSpacing
        return stack
    }()

    private lazy var vStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [hStackView, detailsButton])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = Constants.stackSpacing
        return stack
    }()

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Метро СПБ 2021"
        setupUI()
        setZoomTap()
        mapScrollView.zoomScale = Constants.minZoomScale
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Singleton.clearPath()
        map.subviews.forEach {
            $0.deselect()
        }
    }

    // MARK: setupUI
    private func setupUI() {
        configureMap()
        configureButtons()
    }

    private func configureButtons() {
        // TODO: not working 
        let container = UIVisualEffectView(effect: UIGlassContainerEffect())
        container.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(container)
        container.contentView.addSubview(vStackView)

        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            container.heightAnchor.constraint(equalToConstant: 200)
        ])

        NSLayoutConstraint.activate([
            vStackView.leadingAnchor.constraint(equalTo: container.contentView.leadingAnchor, constant: 16),
            vStackView.trailingAnchor.constraint(equalTo: container.contentView.trailingAnchor, constant: -16),
            vStackView.bottomAnchor.constraint(equalTo: container.contentView.bottomAnchor, constant: -40),
            vStackView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }

    private func configureMap() {
        mapScrollView.addSubview(map)
        view.addSubview(mapScrollView)

        NSLayoutConstraint.activate([
            mapScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            mapScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            map.topAnchor.constraint(equalTo: mapScrollView.contentLayoutGuide.topAnchor),
            map.leadingAnchor.constraint(equalTo: mapScrollView.contentLayoutGuide.leadingAnchor),
            map.trailingAnchor.constraint(equalTo: mapScrollView.contentLayoutGuide.trailingAnchor),
            map.bottomAnchor.constraint(equalTo: mapScrollView.contentLayoutGuide.bottomAnchor),

            map.widthAnchor.constraint(equalTo: mapScrollView.frameLayoutGuide.widthAnchor),
            map.heightAnchor.constraint(equalTo: mapScrollView.frameLayoutGuide.heightAnchor)
        ])

        mapScrollView.minimumZoomScale = Constants.minZoomScale
        mapScrollView.maximumZoomScale = Constants.maxZoomScale
        mapScrollView.contentInsetAdjustmentBehavior = .always
        mapScrollView.contentInset = .init(top: .zero, left: 20, bottom: 160, right: 20)
        mapScrollView.contentInset.bottom = 160
        mapScrollView.contentSize = CGSize(width: view.frame.width * 2,
                                           height: view.frame.height * 2)
        mapScrollView.showsVerticalScrollIndicator = false
        mapScrollView.showsHorizontalScrollIndicator = false
    }

    private func setZoomTap() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
        tapGestureRecognizer.numberOfTapsRequired = 2
        map.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc private func doubleTap(gesture: UITapGestureRecognizer) {
        let pointInView = gesture.location(in: map)

        if mapScrollView.zoomScale == Constants.minZoomScale {
            let newZoomScale = 3.0
            let scrollViewSize = mapScrollView.bounds.size

            let width = scrollViewSize.width / newZoomScale
            let height = scrollViewSize.height / newZoomScale
            let originX = pointInView.x - (width / 2.0)
            let originY = pointInView.y - (height / 2.0)

            let rectToZoom = CGRect(x: originX, y: originY, width: width, height: height)
            mapScrollView.zoom(to: rectToZoom, animated: true)

        } else {
            mapScrollView.setZoomScale(Constants.minZoomScale, animated: true)
        }

        VibrateManager().vibrateFeedback(style: .rigid)
    }
}

// MARK: - Private
private extension MapViewController {
    func animatePath() {
        for view in map.subviews {
            for vertex in Singleton.graph.path {
                if vertex.data.id == view.tag {
                    view.withAnimation(action: { view.select() })
                }
            }
        }
    }

    func makeButton(title: String, action: Selector) -> UIButton {
        var configuration =  UIButton.Configuration.clearGlass()
        configuration.title = title
        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    @objc func builtPathTapped() {
        guard Singleton.pathWay.count == Constants.minStationsPathCount,
              Singleton.graph.path.isEmpty else { return }

        let fromId = Singleton.pathWay[0]
        let toId = Singleton.pathWay[1]

        Singleton.graph.dijkstrasAlgorithm(from: Vertex(data: Station(id: fromId, name: Singleton.graph.info[fromId]!)),
                                           to: Vertex(data: Station(id: toId, name: Singleton.graph.info[toId]!)))
        animatePath()
    }

    @objc func cancelButtonTapped() {
        guard !Singleton.pathWay.isEmpty else { return }
        map.subviews.forEach { view in view.withAnimation(action: { view.deselect() }) }
        Singleton.clearPath()
    }

    @objc func showDetailsTapped() {
        navigationController?.pushViewController(DetailsViewController(), animated: true)
    }
}

// MARK: - UIScrollViewDelegate
extension MapViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? { map }
}
