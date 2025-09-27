import UIKit
import Foundation

final class MapViewController: UIViewController {
    private let graph: GraphProtocol = Graph<Station>()
    private lazy var buildPathbutton = makeButton(title: "Построить", action: #selector(builtPathTapped))
    private lazy var cancelButton = makeButton(title: "Сброс", action: #selector(cancelButtonTapped))
    private lazy var detailsButton = makeButton(title: "Подробнее", action: #selector(showDetailsTapped))

    private lazy var mapScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.delegate = self
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    private lazy var map: BezierCurvesMap = {
        let view = BezierCurvesMap(graph: graph)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var hStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [buildPathbutton, cancelButton])
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

    // MARK: Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        graph.clearPath()
        map.subviews.forEach {
            $0.deselect()
        }
    }
}

// MARK: - Private
private extension MapViewController {
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
    
    func animatePath() {
        var delay = 0.03
        graph.path.forEach {
            for view in map.subviews where $0.data.id == view.tag {
                delay += 0.04
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    view.withAnimation { view.select() }
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
        guard graph.pathWay.count == Constants.minStationsPathCount,
              graph.path.isEmpty else { return }

        let fromId = graph.pathWay[0]
        let toId = graph.pathWay[1]

        graph.calculateShortestPath(
            from: Vertex(data: Station(id: fromId, name: graph.info[fromId]!)),
            to: Vertex(data: Station(id: toId, name: graph.info[toId]!))
        )
        
        animatePath()
    }

    @objc func cancelButtonTapped() {
        guard !graph.pathWay.isEmpty else { return }
        map.subviews.forEach { view in view.withAnimation { view.deselect() } }
        graph.clearPath()
    }

    @objc func showDetailsTapped() {
        navigationController?.pushViewController(
            PathDetailsViewController(pathDetails: graph.pathDetails),
            animated: true
        )
    }
}

// MARK: - UIScrollViewDelegate
extension MapViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? { map }
}
