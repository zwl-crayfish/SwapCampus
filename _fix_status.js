const fs = require('fs');
let c = fs.readFileSync('d:/SwapCampus-main/frontend/src/views/Home.vue', 'utf8');

// 修改1: 模板部分
c = c.replace(
  /:class="'status-' \+ item\.status\.toLowerCase\(\)"/,
  ":class=\"'status--' + (typeof item.status === 'string' ? item.status.toLowerCase() : ['','on_sale','reserved','sold'][item.status] || '')\""
);

// 修改2: getStatusLabel 函数
c = c.replace(
  `function getStatusLabel(status) {
  const map = {
    ON_SALE: '在售',
    RESERVED: '已预订',
    SOLD: '已售出',
  }
  return map[status] || status
}`,
  `function getStatusLabel(status) {
  if (typeof status === 'number') {
    return { 2: '已预订', 0: '已售出' }[status] || ''
  }
  const map = { ON_SALE: '在售', RESERVED: '已预订', SOLD: '已售出' }
  return map[status] || status
}`
);

fs.writeFileSync('d:/SwapCampus-main/frontend/src/views/Home.vue', c);
console.log('Both modifications applied successfully');
