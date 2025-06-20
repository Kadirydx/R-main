setTimeout(function () {
  const letters = 'ABCDEFGH'.split('');
  const container = document.getElementById('js_grid_container');
  const options = [
    'none', 'control', 'treatment',
    '1 uL', '5 uL', '12.5 uL', '25 uL', '50 uL',
    'DMSO control', 'death dose', 'PBS', 'Media'
  ];

  const defaultValues = {};

  // PBS ve Media sütunları
  letters.forEach(row => {
    defaultValues[row + 1] = "PBS";
    defaultValues[row + 12] = "PBS";
    defaultValues[row + 2] = "Media";
  });

  // A–E: dozlar
  for (let i = 3; i <= 11; i++) {
    defaultValues["A" + i] = "1 uL";
    defaultValues["B" + i] = "5 uL";
    defaultValues["C" + i] = "12.5 uL";
    defaultValues["D" + i] = "25 uL";
    defaultValues["E" + i] = "50 uL";
  }

  // F–H: özel gruplar
  for (let i = 3; i <= 11; i++) {
    defaultValues["F" + i] = "control";
    defaultValues["G" + i] = "DMSO control";
    defaultValues["H" + i] = "death dose";
  }

  const colorMap = {
    "PBS": "#0991f2",
    "Media": "#fc0af4",
    "1 uL": "#9cf209",
    "5 uL": "#cbf209",
    "12.5 uL": "#f7eb09",
    "25 uL": "#f9cd09",
    "50 uL": "#f7a409",
    "control": "#f77809",
    "DMSO control": "#f75509",
    "death dose": "#ff0a0a"
  };

  if (!container) {
    console.error("⚠️ Grid container bulunamadı!");
    return;
  }

  // Üst başlıklar (1-12)
  for (let i = -1; i < 12; i++) {
    const label = document.createElement('div');
    label.textContent = i >= 0 ? (i + 1) : '';
    label.style.fontWeight = 'bold';
    container.appendChild(label);
  }

  letters.forEach(row => {
    // Sol etiket (A–H)
    const rowLabel = document.createElement('div');
    rowLabel.textContent = row;
    rowLabel.style.fontWeight = 'bold';
    container.appendChild(rowLabel);

    for (let col = 1; col <= 12; col++) {
      const wellId = row + col;
      const select = document.createElement('select');
      select.id = wellId;

      const defaultValue = defaultValues[wellId];

      options.forEach(opt => {
        const o = document.createElement('option');
        o.value = opt;
        o.text = opt;
        if (defaultValue === opt) {
          o.selected = true;
          Shiny.setInputValue('well_' + wellId, defaultValue, { priority: 'event' });
        }
        select.appendChild(o);
      });

      // Değişince arkaplan ve input güncelle
      select.onchange = function () {
        const selected = this.value;
        this.style.backgroundColor = colorMap[selected] || '';
        Shiny.setInputValue('well_' + wellId, selected, { priority: 'event' });
      };

      // Başlangıçta arkaplan uygula
      if (defaultValue) {
        select.style.backgroundColor = colorMap[defaultValue] || '';
      }

      container.appendChild(select);
    }
  });
}, 0);
