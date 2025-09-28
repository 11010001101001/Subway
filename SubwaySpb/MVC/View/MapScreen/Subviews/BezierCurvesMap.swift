import UIKit

final class BezierCurvesMap: UIView {
    private weak var graph: GraphProtocol?
    /// stations arrays devided on lines
    lazy var blueStationsArr: [Station] = []
    lazy var redStationsArr: [Station] = []
    lazy var purpleStationsArr: [Station] = []
    lazy var greenStationsArr: [Station] = []
    lazy var orangeStationsArr: [Station] = []

    private var dimLayer: CAShapeLayer?

    init(graph: GraphProtocol?) {
        self.graph = graph
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: `Small` stations
    /// small(no other stations connected i mean) stations drawing
    func drawSmallStations(
        on view: UIView,
        name: String,
        x: CGFloat,
        y: CGFloat,
        color: UIColor,
        id: Int
    ) {
        let stationName = UILabel()
        let stationButton = UIButton(frame: CGRect(x: x-2.5, y: y-2.5, width: 15, height: 15))
        stationButton.tag = id

        let station = Station(id: id, name: name)
        addStationToItsLine(id: id, station: station)

        let newVertex = Vertex(data: station)
        graph?.append(vertex: newVertex, name: name, id: id)

        if name == "Василеостровская" {
            stationName.frame = CGRect(x: x+8, y: y-7, width: 65, height: 10)
        } else if name == "Балтийская" {
            stationName.frame = CGRect(x: x+12, y: y+5, width: 65, height: 10)
        } else if name == "Адмиралтейская" {
            stationName.frame = CGRect(x: x-67, y: y, width: 65, height: 10)
        } else if name == "Лиговский проспект" {
            stationName.frame = CGRect(x: x - 25, y: y+10, width: 65, height: 10)
            stationName.textColor = .orange
        } else if name == "Московские ворота" {
            stationName.frame = CGRect(x: x+13, y: y+2, width: 55, height: 10)
            stationName.numberOfLines = 0
        } else {
            stationName.frame = CGRect(x: x+13, y: y+2, width: 65, height: 10)
        }

        stationButton.backgroundColor = color
        stationButton.layer.cornerRadius = stationButton.frame.size.height/2
        stationButton.layer.borderWidth = 0.5
        stationButton.layer.borderColor = UIColor.white.cgColor
        stationName.text = name
        stationName.numberOfLines = 0
        stationName.tintColor = UIColor.black
        stationName.font = .boldSystemFont(ofSize: 6)
        stationName.sizeToFit()
        stationName.frame.origin.x += 5
        view.addSubview(stationButton)
        view.addSubview(stationName)
    }

    // MARK: adding to arr stations filtered by id according to their lines
    func addStationToItsLine(id: Int, station: Station) {
        if id <= 18 {
            blueStationsArr.append(station)
        } else if id > 18 && id <= 37 {
            redStationsArr.append(station)
        } else if id > 37 && id <= 52 {
            purpleStationsArr.append(station)
        } else if id > 52 && id <= 64 {
            greenStationsArr.append(station)
        } else if id > 64 && id <= 72 {
            orangeStationsArr.append(station)
        }
    }
}

// MARK: `Big` stations
extension BezierCurvesMap {
    /// draw big stations with connections to other ones
    func drawBigStations(
        on view: UIView,
        name: String,
        x: CGFloat,
        y: CGFloat,
        color: UIColor,
        id: Int
    ) {
        let stationButton = UIButton()
        let stationName = UILabel()

        if name == "Невский проспект" {
            stationButton.frame = CGRect(x: x+2.5, y: y-7, width: 15, height: 15)
        } else if name == "Гостиный двор" {
            stationButton.frame = CGRect(x: x+2.5, y: y+9, width: 15, height: 15)
        } else if name == "Садовая" {
            stationButton.frame = CGRect(x: x-5.5, y: y+5, width: 15, height: 15)
        } else if name == "Сенная площадь" {
            stationButton.frame = CGRect(x: x+2.5, y: y-9, width: 15, height: 15)
        } else if name == "Спасская" {
            stationButton.frame = CGRect(x: x+10.5, y: y+5, width: 15, height: 15)
        } else if name == "Технологический институт 2" {
            stationButton.frame = CGRect(x: x+2.5, y: y-7, width: 15, height: 15)
        } else if name == "Технологический институт 1" {
            stationButton.frame = CGRect(x: x+2.5, y: y+9, width: 15, height: 15)
        } else if name == "Площадь восстания" {
            stationButton.frame = CGRect(x: x+2.5, y: y-7, width: 15, height: 15)
        } else if name == "Маяковская" {
            stationButton.frame = CGRect(x: x+1, y: y+9, width: 15, height: 15)
        } else if name == "Владимирская" {
            stationButton.frame = CGRect(x: x+4.5, y: y-4.5, width: 15, height: 15)
        } else if name == "Достоевская" {
            stationButton.frame = CGRect(x: x-0.5, y: y+11, width: 15, height: 15)
        } else if name == "Площадь Александра Невского 2" {
            stationButton.frame = CGRect(x: x+2.5, y: y+9, width: 15, height: 15)
        } else if name == "Площадь Александра Невского 1" {
            stationButton.frame = CGRect(x: x+2.5, y: y-7, width: 15, height: 15)
        } else if name == "Пушкинская" {
            stationButton.frame = CGRect(x: x+5.5, y: y-7, width: 15, height: 15)
        } else if name == "Звенигородская" {
            stationButton.frame = CGRect(x: x-3.5, y: y+7, width: 15, height: 15)
        } else {
            stationButton.frame = CGRect(x: x, y: y, width: 15, height: 15)
        }

        stationButton.tag = id

        let station = Station(id: id, name: name)
        addStationToItsLine(id: id, station: station)

        let newVertex = Vertex(data: station)
        graph?.insertBigStationId(id: id)
        graph?.append(vertex: newVertex, name: name, id: id)

        if name == "Невский проспект" {
            stationName.frame = CGRect(x: x+20, y: y-10, width: 50, height: 10)
            stationName.textColor = .blue
        } else if name == "Гостиный двор" {
            stationName.frame = CGRect(x: x+20, y: y+15, width: 50, height: 10)
            stationName.textColor = .green
        } else if name == "Спасская" {
            stationName.frame = CGRect(x: x+27, y: y+15, width: 50, height: 10)
            stationName.textColor = .orange
        } else if name == "Садовая" {
            stationName.frame = CGRect(x: x-35, y: y+12, width: 50, height: 10)
            stationName.textColor = .purple
        } else if name == "Технологический институт 2" {
            stationName.frame = CGRect(x: x-60, y: y - 5, width: 60, height: 10)
            stationName.textColor = .blue
            stationName.textAlignment = .right
        } else if name == "Технологический институт 1" {
            stationName.frame = CGRect(x: x+20, y: y + 8, width: 60, height: 10)
            stationName.textColor = .red
            stationName.textAlignment = .left
        } else if name == "Сенная площадь" {
            stationName.textColor = .blue
            stationName.frame = CGRect(x: x+20, y: y-10, width: 50, height: 10)
        } else if name == "Площадь восстания" {
            stationName.textColor = .red
            stationName.frame = CGRect(x: x+20, y: y-6, width: 50, height: 10)
        } else if name == "Маяковская" {
            stationName.textColor = .green
            stationName.frame = CGRect(x: x+22, y: y+11, width: 50, height: 10)
        } else if name == "Владимирская" {
            stationName.textColor = .red
            stationName.frame = CGRect(x: x+22, y: y, width: 50, height: 10)
        } else if name == "Достоевская" {
            stationName.textColor = .orange
            stationName.frame = CGRect(x: x+22, y: y+11, width: 50, height: 10)
        } else if name == "Площадь Александра Невского 1" {
            stationName.textColor = .green
            stationName.frame = CGRect(x: x+22, y: y-13, width: 50, height: 10)
        } else if name == "Площадь Александра Невского 2" {
            stationName.textColor = .orange
            stationName.frame = CGRect(x: x+22, y: y+10, width: 50, height: 10)
        } else if name == "Пушкинская" {
            stationName.textColor = .red
            stationName.frame = CGRect(x: x+22, y: y, width: 50, height: 10)
        } else if name == "Звенигородская" {
            stationName.textColor = .purple
            stationName.frame = CGRect(x: x+18, y: y+10, width: 60, height: 10)
        } else {
            stationName.frame = CGRect(x: x+22, y: y-10, width: 50, height: 10)
            stationName.textColor = .black
        }

        stationButton.backgroundColor = color
        stationButton.layer.cornerRadius = stationButton.frame.size.height/2
        stationButton.layer.borderWidth = 0.5
        stationButton.layer.borderColor = UIColor.white.cgColor
        stationName.text = name
        stationName.numberOfLines = 0
        stationName.font = .boldSystemFont(ofSize: 6)
        stationName.sizeToFit()
        view.addSubview(stationButton)
        view.addSubview(stationName)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        /// draw blue line - stations
        drawSmallStations(on: self, name: "Парнас",x: 160,y: 24,color: .blue, id: 1)
        drawSmallStations(on: self, name: "Проспект просвещения",x: 160,y: 54, color: .blue, id: 2)
        drawSmallStations(on: self, name: "Озерки",x: 160,y: 84, color: .blue, id: 3)
        drawSmallStations(on: self, name: "Удельная",x: 160,y: 114, color: .blue, id: 4)
        drawSmallStations(on: self, name: "Пионерская",x: 160,y: 144, color: .blue, id: 5)
        drawSmallStations(on: self, name: "Черная речка",x: 160,y: 174, color: .blue, id: 6)
        drawSmallStations(on: self, name: "Петроградская",x: 160,y: 224, color: .blue, id: 7)
        drawSmallStations(on: self, name: "Горьковская",x: 160,y: 254, color: .blue, id: 8)
        drawBigStations(on: self, name: "Невский проспект",x: 155, y: 294, color: .blue, id: 9)
        drawBigStations(on: self, name: "Сенная площадь",x: 155, y: 344, color: .blue, id: 10)
        drawBigStations(on: self, name: "Технологический институт 2",x: 155, y: 450, color: .blue, id: 11)
        drawSmallStations(on: self, name: "Фрунзенская",x: 160,y: 480, color: .blue, id: 12)
        drawSmallStations(on: self, name: "Московские ворота",x: 160,y: 510, color: .blue, id: 13)
        drawSmallStations(on: self, name: "Электросила",x: 160,y: 540, color: .blue, id: 14)
        drawSmallStations(on: self, name: "Парк Победы",x: 160,y: 570, color: .blue, id: 15)
        drawSmallStations(on: self, name: "Московская",x: 160,y: 600, color: .blue, id: 16)
        drawSmallStations(on: self, name: "Звездная",x: 160,y: 630, color: .blue, id: 17)
        drawSmallStations(on: self, name: "Купчино",x: 160,y: 660, color: .blue, id: 18)
        /// draw red line - stations
        drawSmallStations(on: self, name: "Девяткино",x: 250, y: 50,color: .red, id: 19)
        drawSmallStations(on: self, name: "Гражданский проспект",x: 250, y: 80,color: .red, id: 20)
        drawSmallStations(on: self, name: "Академическая",x: 250, y: 110,color: .red, id: 21)
        drawSmallStations(on: self, name: "Политехническая",x: 250, y: 140,color: .red, id: 22)
        drawSmallStations(on: self, name: "Площадь мужества",x: 250, y: 170,color: .red, id: 23)
        drawSmallStations(on: self, name: "Лесная",x: 250, y: 200,color: .red, id: 24)
        drawSmallStations(on: self, name: "Выборгская",x: 250, y: 220,color: .red, id: 25)
        drawSmallStations(on: self, name: "Площадь Ленина",x: 250, y: 240,color: .red, id: 26)
        drawSmallStations(on: self, name: "Чернышевская",x: 250, y: 260,color: .red, id: 27)
        drawBigStations(on: self, name: "Площадь восстания", x: 245, y: 294, color: .red, id: 28)
        drawBigStations(on: self, name: "Владимирская", x: 235, y: 344, color: .red, id: 29)
        drawBigStations(on: self, name: "Пушкинская", x: 215, y: 400, color: .red, id: 30)
        drawBigStations(on: self, name: "Технологический институт 1", x: 155, y: 450, color: .red, id: 31)
        drawSmallStations(on: self, name: "Балтийская",x: 80, y: 485,color: .red, id: 32)
        drawSmallStations(on: self, name: "Нарвская",x: 80, y: 510,color: .red, id: 33)
        drawSmallStations(on: self, name: "Кировский завод",x: 80, y: 535,color: .red, id: 34)
        drawSmallStations(on: self, name: "Автово",x: 80, y: 570,color: .red, id: 35)
        drawSmallStations(on: self, name: "Ленинский проспект",x: 80, y: 600,color: .red, id: 36)
        drawSmallStations(on: self, name: "Проспект Ветеранов",x: 80, y: 630,color: .red, id: 37)
        /// draw purple line - stations
        drawSmallStations(on: self, name: "Комендантский проспект",x: 80,y: 120, color: .purple, id: 38)
        drawSmallStations(on: self, name: "Старая деревня",x: 80,y: 150, color: .purple, id: 39)
        drawSmallStations(on: self, name: "Крестовский остров",x: 80,y: 170, color: .purple, id: 40)
        drawSmallStations(on: self, name: "Чкаловская",x: 80,y: 190, color: .purple, id: 41)
        drawSmallStations(on: self, name: "Спортивная",x: 80,y: 210, color: .purple, id: 42)
        drawSmallStations(on: self, name: "Адмиралтейская",x: 120,y: 320, color: .purple, id: 43)
        drawBigStations(on: self, name: "Садовая",x: 155, y: 344, color: .purple, id: 44)
        drawBigStations(on: self, name: "Звенигородская", x: 215, y: 400, color: .purple, id: 45)
        drawSmallStations(on: self, name: "Обводный канал",x: 236,y: 440, color: .purple, id: 46)
        drawSmallStations(on: self, name: "Волховская",x: 236,y: 510, color: .purple, id: 47)
        drawSmallStations(on: self, name: "Бухарестская",x: 236,y: 540, color: .purple, id: 48)
        drawSmallStations(on: self, name: "Международная",x: 236,y: 570, color: .purple, id: 49)
        drawSmallStations(on: self, name: "Проспект Славы",x: 236,y: 600, color: .purple, id: 50)
        drawSmallStations(on: self, name: "Дунайская",x: 236,y: 630, color: .purple, id: 51)
        drawSmallStations(on: self, name: "Шушары",x: 236,y: 660, color: .purple, id: 52)
        /// draw green line - stations
        drawSmallStations(on: self, name: "Беговая",x: 10,y: 224, color: .green, id: 53)
        drawSmallStations(on: self, name: "Зенит",x: 20,y: 244, color: .green, id: 54)
        drawSmallStations(on: self, name: "Приморская",x: 30,y: 266, color: .green, id: 55)
        drawSmallStations(on: self, name: "Василеостровская",x: 40,y: 288, color: .green, id: 56)
        drawBigStations(on: self, name: "Гостиный двор",x: 155, y: 294, color: .green, id: 57)
        drawBigStations(on: self, name: "Маяковская", x: 245, y: 294, color: .green, id: 58)
        drawBigStations(on: self, name: "Площадь Александра Невского 1", x: 295, y: 375, color: .green, id: 59)
        drawSmallStations(on: self, name: "Елизаровская",x: 300,y: 560, color: .green, id: 60)
        drawSmallStations(on: self, name: "Ломоносовская",x: 300,y: 590, color: .green, id: 61)
        drawSmallStations(on: self, name: "Пролетарская",x: 300,y: 620, color: .green, id: 62)
        drawSmallStations(on: self, name: "Обухово",x: 300,y: 650, color: .green, id: 63)
        drawSmallStations(on: self, name: "Рыбацкое",x: 300,y: 680, color: .green, id: 64)
        /// draw orange line - stations
        drawBigStations(on: self, name: "Спасская",x: 155, y: 344, color: .orange, id: 65)
        drawBigStations(on: self, name: "Достоевская", x: 235, y: 344, color: .orange, id: 66)
        drawSmallStations(on: self, name: "Лиговский проспект",x: 265,y: 375, color: .orange, id: 67)
        drawBigStations(on: self, name: "Площадь Александра Невского 2", x: 295, y: 375, color: .orange, id: 68)
        drawSmallStations(on: self, name: "Новочеркасская",x: 310,y: 450, color: .orange, id: 69)
        drawSmallStations(on: self, name: "Ладожская",x: 310,y: 480, color: .orange, id: 70)
        drawSmallStations(on: self, name: "Проспект Большевиков",x: 310,y: 500, color: .orange, id: 71)
        drawSmallStations(on: self, name: "Дыбенко",x: 310,y: 540, color: .orange, id: 72)

        /// draw blue line itself
        let edgeBlue = UIBezierPath()
        edgeBlue.move(to: CGPoint(x: 165,y: 26))
        edgeBlue.addLine(to: CGPoint(x: 165,y: 54))
        edgeBlue.addLine(to: CGPoint(x: 165,y: 84))
        edgeBlue.addLine(to: CGPoint(x: 165,y: 114))
        edgeBlue.addLine(to: CGPoint(x: 165,y: 144))
        edgeBlue.addLine(to: CGPoint(x: 165,y: 174))
        edgeBlue.addLine(to: CGPoint(x: 165,y: 224))
        edgeBlue.addLine(to: CGPoint(x: 165,y: 254))
        edgeBlue.addLine(to: CGPoint(x: 165,y: 294))
        edgeBlue.addLine(to: CGPoint(x: 165,y: 344))
        edgeBlue.addLine(to: CGPoint(x: 165,y: 450))
        edgeBlue.addLine(to: CGPoint(x: 165,y: 480))
        edgeBlue.addLine(to: CGPoint(x: 165,y: 510))
        edgeBlue.addLine(to: CGPoint(x: 165,y: 540))
        edgeBlue.addLine(to: CGPoint(x: 165,y: 570))
        edgeBlue.addLine(to: CGPoint(x: 165,y: 600))
        edgeBlue.addLine(to: CGPoint(x: 165,y: 630))
        edgeBlue.addLine(to: CGPoint(x: 165, y: 660))
        UIColor.blue.setFill()
        UIColor.blue.setStroke()
        edgeBlue.lineWidth = 7.0
        edgeBlue.stroke()
        /// draw red line itself
        let edgeRed = UIBezierPath()
        edgeRed.move(to: CGPoint(x: 255,y: 52))
        edgeRed.addLine(to: CGPoint(x: 255,y: 80))
        edgeRed.addLine(to: CGPoint(x: 255,y: 110))
        edgeRed.addLine(to: CGPoint(x: 255,y: 140))
        edgeRed.addLine(to: CGPoint(x: 255,y: 170))
        edgeRed.addLine(to: CGPoint(x: 255,y: 200))
        edgeRed.addLine(to: CGPoint(x: 255,y: 220))
        edgeRed.addLine(to: CGPoint(x: 255,y: 240))
        edgeRed.addLine(to: CGPoint(x: 255,y: 260))
        edgeRed.addLine(to: CGPoint(x: 255,y: 305))
        edgeRed.addLine(to: CGPoint(x: 247,y: 350))
        edgeRed.addLine(to: CGPoint(x: 225,y: 410))
        edgeRed.addLine(to: CGPoint(x: 160,y: 465))
        edgeRed.addLine(to: CGPoint(x: 85,y: 490))
        edgeRed.addLine(to: CGPoint(x: 85,y: 510))
        edgeRed.addLine(to: CGPoint(x: 85,y: 535))
        edgeRed.addLine(to: CGPoint(x: 85,y: 570))
        edgeRed.addLine(to: CGPoint(x: 85,y: 600))
        edgeRed.addLine(to: CGPoint(x: 85,y: 630))
        UIColor.red.setFill()
        UIColor.red.setStroke()
        edgeRed.lineWidth = 7.0
        edgeRed.stroke()
        /// draw purple line itself
        let edgePurple = UIBezierPath()
        edgePurple.move(to: CGPoint(x: 85, y: 122))
        edgePurple.addLine(to: CGPoint(x: 85, y: 150))
        edgePurple.addLine(to: CGPoint(x: 85, y: 170))
        edgePurple.addLine(to: CGPoint(x: 85, y: 190))
        edgePurple.addLine(to: CGPoint(x: 85, y: 215))
        edgePurple.addLine(to: CGPoint(x: 125, y: 325))
        edgePurple.addLine(to: CGPoint(x: 160, y: 350))
        edgePurple.addLine(to: CGPoint(x: 220, y: 405))
        edgePurple.addLine(to: CGPoint(x: 241, y: 442))
        edgePurple.addLine(to: CGPoint(x: 241, y: 510))
        edgePurple.addLine(to: CGPoint(x: 241, y: 540))
        edgePurple.addLine(to: CGPoint(x: 241, y: 570))
        edgePurple.addLine(to: CGPoint(x: 241, y: 600))
        edgePurple.addLine(to: CGPoint(x: 241, y: 630))
        edgePurple.addLine(to: CGPoint(x: 241, y: 660))
        UIColor.purple.setFill()
        UIColor.purple.setStroke()
        edgePurple.lineWidth = 7.0
        edgePurple.stroke()
        /// draw green line itself
        let edgeGreen = UIBezierPath()
        edgeGreen.move(to: CGPoint(x: 13, y: 226)) // Беговая
        edgeGreen.addLine(to: CGPoint(x: 22, y: 244))
        edgeGreen.addLine(to: CGPoint(x: 33, y: 266))
        edgeGreen.addLine(to: CGPoint(x: 45, y: 294))
        edgeGreen.addLine(to: CGPoint(x: 160, y: 303))
        edgeGreen.addLine(to: CGPoint(x: 255, y: 303))
        edgeGreen.addLine(to: CGPoint(x: 305, y: 380))
        edgeGreen.addLine(to: CGPoint(x: 305, y: 560))
        edgeGreen.addLine(to: CGPoint(x: 305, y: 590))
        edgeGreen.addLine(to: CGPoint(x: 305, y: 620))
        edgeGreen.addLine(to: CGPoint(x: 305, y: 650))
        edgeGreen.addLine(to: CGPoint(x: 305, y: 680))
        UIColor.green.setFill()
        UIColor.green.setStroke()
        edgeGreen.lineWidth = 7.0
        edgeGreen.stroke()
        /// draw orange line itself
        let edgeOrange = UIBezierPath()
        edgeOrange.move(to: CGPoint(x: 160, y: 354))
        edgeOrange.addLine(to: CGPoint(x: 245, y: 354))
        edgeOrange.addLine(to: CGPoint(x: 270, y: 380))
        edgeOrange.addLine(to: CGPoint(x: 305, y: 385))
        edgeOrange.addLine(to: CGPoint(x: 315, y: 450))
        edgeOrange.addLine(to: CGPoint(x: 315, y: 480))
        edgeOrange.addLine(to: CGPoint(x: 315, y: 500))
        edgeOrange.addLine(to: CGPoint(x: 315, y: 540))
        UIColor.orange.setFill()
        UIColor.orange.setStroke()
        edgeOrange.lineWidth = 7.0
        edgeOrange.stroke()

        hideLinesCrossings(165, 352, 10)
        hideLinesCrossings(165, 303, 7)
        hideLinesCrossings(165, 459, 7)
        hideLinesCrossings(255, 303, 7)
        hideLinesCrossings(245, 355, 7)
        hideLinesCrossings(305, 384, 7)
        hideLinesCrossings(224, 409, 7)

        createGraph()
    }

    private func hideLinesCrossings(_ x: Int,_ y: Int,_ radius: CGFloat) {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: x, y: y),
                                      radius: radius,
                                      startAngle: 0,
                                      endAngle: CGFloat(Double.pi * 2),
                                      clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        UIColor.black.setFill()
        UIColor.white.setStroke()
        circlePath.lineWidth = 1.0
        circlePath.fill()
        circlePath.stroke()
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        super.point(inside: point, with: event)
        guard let pathWay = graph?.pathWay,
              pathWay.count < Constants.minStationsPathCount else { return true }

        subviews.forEach { view in
            if view.frame.contains(point) && view.tag != 0 && !pathWay.contains(view.tag) {
                graph?.appendViewTag(tag: view.tag)
                view.withAnimation(action: { view.select() })
            }
        }

        return true
    }

    func createGraph() {
        guard let graph, graph.allVertexes.count == 72 else { return }
        /// adding vertexes and edges for blue line
        graph.addVertexesAndEdgesToGraph(
            arrStations: blueStationsArr,
            arrWeights: Constants.weightStoreBlueLine
        )
        /// adding vertexes and edges for red line
        graph.addVertexesAndEdgesToGraph(
            arrStations: redStationsArr,
            arrWeights: Constants.weightStoreRedLine
        )
        /// adding vertexes and edges for purple line
        graph.addVertexesAndEdgesToGraph(
            arrStations: purpleStationsArr,
            arrWeights: Constants.weightStorePurpleLine
        )
        /// adding vertexes and edges for green line
        graph.addVertexesAndEdgesToGraph(
            arrStations: greenStationsArr,
            arrWeights: Constants.weightStoreGreenLine
        )
        /// adding vertexes and edges for orange line
        graph.addVertexesAndEdgesToGraph(
            arrStations: orangeStationsArr,
            arrWeights: Constants.weightStoreOrangeLine
        )
        /// adding stations connections
        graph.addVertexesCrossings()
    }

    func showShortestPath() {
        let path = UIBezierPath()
        var delay = 0.03

        guard let startView = subviews.first(where: { $0.tag == graph?.path[0].data.id }) else { return }
        path.move(to: startView.center)

        graph?.path.forEach {
            for view in subviews where $0.data.id == view.tag && view is UIButton {
                delay += 0.04
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    view.withAnimation {
                        view.layer.borderWidth = 1
                        view.select()
                    }
                }
                path.addLine(to: view.center)
            }
        }

        let strokedPath = path.cgPath.copy(
            strokingWithWidth: 20,
            lineCap: .round,
            lineJoin: .round,
            miterLimit: .zero
        )

        let dimPath = UIBezierPath(
            rect: .init(
                x: bounds.origin.x - 20,
                y: bounds.origin.y,
                width: bounds.width,
                height: bounds.height
            )
        )

        dimPath.append(UIBezierPath(cgPath: strokedPath))

        graph?.path.forEach {
            for view in subviews where $0.data.name == (view as? UILabel)?.text {
                let frame = CGRect(
                    x: view.frame.minX - 1,
                    y: view.frame.minY - 1,
                    width: view.frame.width + 2,
                    height: view.frame.height + 2
                )
                let titleRect = UIBezierPath(roundedRect: frame, cornerRadius: 3)
                dimPath.append(titleRect)
            }
        }

        dimPath.usesEvenOddFillRule = true

        dimLayer = CAShapeLayer()
        dimLayer?.path = dimPath.cgPath
        dimLayer?.fillRule = .evenOdd
        dimLayer?.fillColor = UIColor.black.withAlphaComponent(0.7).cgColor
        dimLayer?.opacity = .zero

        guard let dimLayer else { return }
        layer.addSublayer(dimLayer)

        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = delay
        dimLayer.add(animation, forKey: "fadeIn")
        dimLayer.opacity = 1
    }

    func clearPath() {
        guard let graph, !graph.pathWay.isEmpty else { return }
        for view in subviews where view is UIButton {
            view.layer.borderWidth = 0.5
            view.deselect()
        }
        graph.clearPath()
        dimLayer?.removeAllAnimations()
        dimLayer?.removeFromSuperlayer()
        dimLayer = nil
    }
}
