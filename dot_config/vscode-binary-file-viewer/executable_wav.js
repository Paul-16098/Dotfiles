/**
 * 選擇“wav”擴展名。
 */
registerFileType((fileExt, filePath, fileData) => {
  // 檢查 wav 擴展名
  if (fileExt === "wav") {
    const headerArray = fileData.getBytesAt(0, 4);
    const header = String.fromCodePoint(...headerArray);
    if (header === "RIFF") return true;
  }
  return false;
});

/**
 * WAV 文件的解析器。
 * 該解析器能夠讀取測試二進製文件 mono.wav 和stereo.wav。
 * 它可能會也可能不會讀取其他 wav 文件。
 * 解析器的目的是演示解析器功能。
 * 它不是一個完整的 wav 解析實現。
 */
registerParser(() => {
  // 解析
  read(4);
  addRow("RIFF ID", getHexValue(), "RIFF 文件描述頭");

  read(4);
  addRow(
    "文件大小",
    getNumberValue(),
    "文件大小減去“RIFF”描述的大小（4 字節）和文件描述的大小（4 字節）。",
  );

  read(4);
  addRow("音頻文件編號", getStringValue(), "WAV 描述頭");

  read(4);
  addRow("FMT ID", getStringValue(), "fmt描述頭");

  read(4);
  addRow(
    "WAV 節塊的大小",
    getNumberValue(),
    "WAV 類型格式的大小（2 字節）+ 單聲道/立體聲標誌（2 字節）+ 採樣率（4 字節）+ 字節/秒（4 字節）+ 塊對齊（2 字節）+ 位/樣本（2 字節）。這通常是 16。",
  );

  read(2);
  addRow(
    "WAV類型格式",
    getDecimalValue(),
    "WAV 格式的類型。這是一個 PCM 標頭，或者值 0x01。",
  );

  read(2);
  const countChannels = getNumberValue();
  addRow(
    "單聲道/立體聲",
    countChannels,
    "單聲道 (0x01) 或立體聲 (0x02)。通道數。",
  );

  read(4);
  addRow("頻率", getDecimalValue(), "採樣頻率。");

  read(4);
  addRow("字節/秒", getDecimalValue(), "音頻數據速率（以字節/秒為單位）。");

  read(2);
  addRow("塊對齊。", getDecimalValue());

  read(2);
  const bitsPerSample = getNumberValue();
  addRow("每個樣本的位數", bitsPerSample);

  read(4);
  addRow("數據描述頭", getStringValue());

  read(4);
  const dataSize = getNumberValue();
  addRow("數據塊的大小", dataSize, "數據部分包含數據的字節數。");

  read(dataSize / 4);
  const channels = [];
  const bytesPerSample = bitsPerSample / 8;

  for (let ch = 0; ch < countChannels; ch++) {
    const offs = ch * bytesPerSample;
    const skip = (countChannels - 1) * bytesPerSample;
    const samples = getData(2, offs, "我", skip);
    channels.push(samples);
  }
  addRow("樣品", undefined, "wav 文件的樣本。");
  addDetails(() => {
    addChart(
      {
        type: "line",
        series: channels,
      },
      "樣品",
    );
  }, true);
});
