import Foundation

final class FillWithColor {
    private var initialColor = 0
    private var resultImage: [[Int]] = []
    
    func fillWithColor(_ image: [[Int]], _ row: Int, _ column: Int, _ newColor: Int) -> [[Int]] {
        let rowsCount = image.count
        let columnsCount = image[row].count
        
        guard   row >= 0 && row < rowsCount && rowsCount > 0 && rowsCount < 51 &&
                column >= 0 && column < columnsCount && columnsCount > 0 && columnsCount < 51 &&
                image[row][column] >= 0 && newColor >= 0 && newColor < 65536
        else {  return image    }
        
        resultImage = image
        initialColor = resultImage[row][column]
        fill(row, column, newColor)
        return resultImage
    }
    
    private func fill(_ row: Int, _ column: Int, _ newColor: Int){
        guard   row >= 0 && row < resultImage.count && column >= 0 && column < resultImage[row].count &&
                resultImage[row][column] == initialColor && resultImage[row][column] != newColor
        else {  return  }
        
        resultImage[row][column] = newColor
        fill(row - 1, column, newColor)
        fill(row, column + 1, newColor)
        fill(row + 1, column, newColor)
        fill(row, column - 1, newColor)
    }
}
