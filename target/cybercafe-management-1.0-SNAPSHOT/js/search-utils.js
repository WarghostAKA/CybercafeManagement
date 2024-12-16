// 通用搜索函数
function searchTable(tableId, searchCriteria, columnIndices) {
    const table = document.getElementById(tableId);
    const rows = table.getElementsByTagName('tr');
    
    for (let i = 1; i < rows.length; i++) {
        const row = rows[i];
        const cells = row.getElementsByTagName('td');
        let showRow = true;

        // 检查每个搜索条件
        for (const [field, value] of Object.entries(searchCriteria)) {
            const columnIndex = columnIndices[field];
            if (columnIndex === undefined || !value) continue;

            const cellContent = cells[columnIndex].textContent.toLowerCase();
            if (!cellContent.includes(value.toLowerCase())) {
                showRow = false;
                break;
            }
        }
        
        row.style.display = showRow ? '' : 'none';
    }
}

// 重置搜索表单
function resetSearchForm(formId, tableId) {
    document.getElementById(formId).reset();
    const table = document.getElementById(tableId);
    const rows = table.getElementsByTagName('tr');
    for (let i = 1; i < rows.length; i++) {
        rows[i].style.display = '';
    }
}