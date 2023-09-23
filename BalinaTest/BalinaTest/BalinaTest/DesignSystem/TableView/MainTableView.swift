import UIKit

class MainTableView: UITableView {
    var color: UIColor
    var registerClass: AnyClass
    var registerCell: String
    var rowHeigh: CGFloat
    
    init(color: UIColor,
         registerClass: AnyClass,
         cell: String,
         rowHeigh: CGFloat) {
        self.color = color
        self.registerClass = registerClass
        self.registerCell = cell
        self.rowHeigh = rowHeigh
        super.init(frame: .zero, style: .plain)
        self.backgroundColor = color
        self.showsVerticalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
        register(registerClass, forCellReuseIdentifier: registerCell)
        rowHeight = rowHeigh
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
