import ExcelJS from 'exceljs'
import { saveAs } from 'file-saver'

/**
 * 데이터를 Excel 파일로 내보내기
 * @param {Array} data - 내보낼 데이터 배열
 * @param {string} filename - 파일명
 * @param {Array} headers - 헤더 정보 [{key: 'field', header: '표시명'}]
 * @param {string} sheetName - 시트명
 */
export async function exportToExcel(data, filename, headers, sheetName = 'Sheet1') {
  try {
    const workbook = new ExcelJS.Workbook()
    const worksheet = workbook.addWorksheet(sheetName)

    // 헤더 추가
    worksheet.columns = headers

    // 데이터 추가
    data.forEach(row => {
      worksheet.addRow(row)
    })

    // 스타일 적용
    worksheet.getRow(1).font = { bold: true }
    worksheet.getRow(1).fill = {
      type: 'pattern',
      pattern: 'solid',
      fgColor: { argb: 'FFE0E0E0' }
    }

    // 자동 열 너비 조정
    worksheet.columns.forEach(column => {
      let maxLength = 0
      column.eachCell({ includeEmpty: true }, cell => {
        const columnLength = cell.value ? cell.value.toString().length : 10
        if (columnLength > maxLength) {
          maxLength = columnLength
        }
      })
      column.width = maxLength < 10 ? 10 : maxLength + 2
    })

    // 파일 생성 및 다운로드
    const buffer = await workbook.xlsx.writeBuffer()
    const blob = new Blob([buffer], { 
      type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' 
    })
    saveAs(blob, `${filename}.xlsx`)
  } catch (error) {
    console.error('Excel 내보내기 오류:', error)
    throw error
  }
}

/**
 * Excel 파일에서 데이터 읽기
 * @param {File} file - 업로드된 Excel 파일
 * @returns {Promise<Array>} 읽은 데이터 배열
 */
export async function readExcelFile(file) {
  try {
    const workbook = new ExcelJS.Workbook()
    const buffer = await file.arrayBuffer()
    await workbook.xlsx.load(buffer)
    
    const worksheet = workbook.getWorksheet(1)
    const data = []
    
    worksheet.eachRow((row, rowNumber) => {
      if (rowNumber > 1) { // 헤더 제외
        const rowData = {}
        row.eachCell((cell, colNumber) => {
          rowData[colNumber] = cell.value
        })
        data.push(rowData)
      }
    })
    
    return data
  } catch (error) {
    console.error('Excel 파일 읽기 오류:', error)
    throw error
  }
}

/**
 * 데이터를 CSV 형식으로 내보내기
 * @param {Array} data - 내보낼 데이터 배열
 * @param {string} filename - 파일명
 * @param {Array} headers - 헤더 정보
 */
export function exportToCSV(data, filename, headers) {
  try {
    // 헤더 행 생성
    const headerRow = headers.map(h => h.header).join(',')
    
    // 데이터 행 생성
    const dataRows = data.map(row => {
      return headers.map(h => {
        const value = row[h.key] || ''
        // CSV에서 쉼표가 포함된 값은 따옴표로 감싸기
        return typeof value === 'string' && value.includes(',') 
          ? `"${value}"` 
          : value
      }).join(',')
    })
    
    // 전체 CSV 내용 생성
    const csvContent = [headerRow, ...dataRows].join('\n')
    
    // 파일 다운로드
    const blob = new Blob(['\uFEFF' + csvContent], { 
      type: 'text/csv;charset=utf-8;' 
    })
    saveAs(blob, `${filename}.csv`)
  } catch (error) {
    console.error('CSV 내보내기 오류:', error)
    throw error
  }
} 