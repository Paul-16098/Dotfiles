// Windows Shell Link (.lnk) Binary File Format Parser
// Based on MS-SHLLINK specification
// https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-shllink/

registerFileType((fileExt, filePath, fileData) => {
  if (fileExt !== "lnk") return false;

  // Check for LNK magic signature: 0x4C 0x00 0x00 0x00 (HeaderSize = 76 bytes)
  const headerBytes = fileData.getBytesAt(0, 4);
  if (
    headerBytes &&
    headerBytes.length >= 4 &&
    headerBytes[0] === 0x4c &&
    headerBytes[1] === 0x00 &&
    headerBytes[2] === 0x00 &&
    headerBytes[3] === 0x00
  ) {
    return true;
  }
  return false;
});

registerParser(() => {
  setEndianness("little");

  try {
    // ===== SHELL_LINK_HEADER (76 bytes) =====
    addDetails(() => {
      addRow(
        "Structure",
        "ShellLinkHeader",
        "76-byte header containing file identification and metadata",
      );

      // HeaderSize (4 bytes)
      read(4);
      addRow("HeaderSize", getHex0xValue(), "Must be 0x0000004C (76 bytes)");

      // LinkCLSID (16 bytes) - 00021401-0000-0000-C000-000000000046
      read(16);
      const clsidHexRaw = getHexValue();
      const clsidStr = formatGUIDFromHex(clsidHexRaw.toString());
      addRow(
        "LinkCLSID",
        clsidStr,
        "Class identifier - must be 00021401-0000-0000-C000-000000000046",
      );

      // LinkFlags (4 bytes)
      const linkFlagsValue = getNumberValue();
      addDetails(() => {
        addRow(
          "LinkFlags",
          convertToHexString(linkFlagsValue, 4),
          "Bit flags indicating optional structures",
        );
        addRow(
          "HasLinkTargetIDList",
          linkFlagsValue & 0x01 ? "Yes" : "No",
          "LinkTargetIDList structure present",
        );
        addRow(
          "HasLinkInfo",
          linkFlagsValue & 0x02 ? "Yes" : "No",
          "LinkInfo structure present",
        );
        addRow(
          "HasName",
          linkFlagsValue & 0x04 ? "Yes" : "No",
          "StringData Name present",
        );
        addRow(
          "HasRelativePath",
          linkFlagsValue & 0x08 ? "Yes" : "No",
          "StringData RelativePath present",
        );
        addRow(
          "HasWorkingDir",
          linkFlagsValue & 0x10 ? "Yes" : "No",
          "StringData WorkingDir present",
        );
        addRow(
          "HasArguments",
          linkFlagsValue & 0x20 ? "Yes" : "No",
          "StringData Arguments present",
        );
        addRow(
          "HasIconLocation",
          linkFlagsValue & 0x40 ? "Yes" : "No",
          "StringData IconLocation present",
        );
        addRow(
          "IsUnicode",
          linkFlagsValue & 0x80 ? "Yes (UTF-16LE)" : "No (ASCII)",
          "String encoding",
        );
        addRow(
          "ForceNoLinkInfo",
          linkFlagsValue & 0x100 ? "Yes" : "No",
          "Ignore LinkInfo",
        );
        addRow(
          "HasExpString",
          linkFlagsValue & 0x200 ? "Yes" : "No",
          "ExpandString present",
        );
        addRow(
          "RunInSeparateProcess",
          linkFlagsValue & 0x400 ? "Yes" : "No",
          "Run in separate VM",
        );
        addRow(
          "Reserved1to11",
          (linkFlagsValue & 0xf800) >> 11,
          "Reserved bits",
        );
      }, false);

      // FileAttributes (4 bytes)
      const fileAttrsValue = getNumberValue();
      addDetails(() => {
        addRow(
          "FileAttributes",
          convertToHexString(fileAttrsValue, 4),
          "Target file attributes",
        );
        addRow(
          "ReadOnly",
          fileAttrsValue & 0x01 ? "Yes" : "No",
          "FILE_ATTRIBUTE_READONLY",
        );
        addRow(
          "Hidden",
          fileAttrsValue & 0x02 ? "Yes" : "No",
          "FILE_ATTRIBUTE_HIDDEN",
        );
        addRow(
          "System",
          fileAttrsValue & 0x04 ? "Yes" : "No",
          "FILE_ATTRIBUTE_SYSTEM",
        );
        addRow(
          "VolumeLabel",
          fileAttrsValue & 0x08 ? "Yes" : "No",
          "FILE_ATTRIBUTE_VOLUME_LABEL",
        );
        addRow(
          "Directory",
          fileAttrsValue & 0x10 ? "Yes" : "No",
          "FILE_ATTRIBUTE_DIRECTORY",
        );
        addRow(
          "Archive",
          fileAttrsValue & 0x20 ? "Yes" : "No",
          "FILE_ATTRIBUTE_ARCHIVE",
        );
        addRow(
          "Device",
          fileAttrsValue & 0x40 ? "Yes" : "No",
          "FILE_ATTRIBUTE_DEVICE",
        );
        addRow(
          "Normal",
          fileAttrsValue & 0x80 ? "Yes" : "No",
          "FILE_ATTRIBUTE_NORMAL",
        );
        addRow(
          "Temporary",
          fileAttrsValue & 0x100 ? "Yes" : "No",
          "FILE_ATTRIBUTE_TEMPORARY",
        );
        addRow(
          "SparseFile",
          fileAttrsValue & 0x200 ? "Yes" : "No",
          "FILE_ATTRIBUTE_SPARSE_FILE",
        );
        addRow(
          "ReparsePoint",
          fileAttrsValue & 0x400 ? "Yes" : "No",
          "FILE_ATTRIBUTE_REPARSE_POINT",
        );
        addRow(
          "Compressed",
          fileAttrsValue & 0x800 ? "Yes" : "No",
          "FILE_ATTRIBUTE_COMPRESSED",
        );
        addRow(
          "Offline",
          fileAttrsValue & 0x1000 ? "Yes" : "No",
          "FILE_ATTRIBUTE_OFFLINE",
        );
        addRow(
          "NotIndexed",
          fileAttrsValue & 0x2000 ? "Yes" : "No",
          "FILE_ATTRIBUTE_NOT_INDEXED",
        );
        addRow(
          "Encrypted",
          fileAttrsValue & 0x4000 ? "Yes" : "No",
          "FILE_ATTRIBUTE_ENCRYPTED",
        );
      }, false);

      // CreationTime (8 bytes - FILETIME)
      read(8);
      const creationTimeRaw = getDecimalValue();
      addRow(
        "CreationTime",
        formatFILETIME(Number(creationTimeRaw)),
        "UTC creation time",
      );

      // AccessTime (8 bytes - FILETIME)
      read(8);
      const accessTimeRaw = getDecimalValue();
      addRow(
        "AccessTime",
        formatFILETIME(Number(accessTimeRaw)),
        "UTC access time",
      );

      // WriteTime (8 bytes - FILETIME)
      read(8);
      const writeTimeRaw = getDecimalValue();
      addRow(
        "WriteTime",
        formatFILETIME(Number(writeTimeRaw)),
        "UTC write/modification time",
      );

      // FileSize (4 bytes)
      const fileSizeValue = getNumberValue();
      addRow(
        "FileSize",
        fileSizeValue + " bytes",
        "Size of target file (lower 32 bits)",
      );

      // IconIndex (4 bytes - signed)
      const iconIndexValue = getSignedNumberValue();
      addRow("IconIndex", iconIndexValue, "Icon index in icon location");

      // ShowCommand (4 bytes)
      read(4);
      const showCommandValue = getNumberValue();
      let showCmdName = "SW_SHOWNORMAL (default)";
      if (showCommandValue === 1) {
        showCmdName = "SW_SHOWNORMAL";
      } else if (showCommandValue === 3) {
        showCmdName = "SW_SHOWMAXIMIZED";
      } else if (showCommandValue === 7) {
        showCmdName = "SW_SHOWMINNOACTIVE";
      }
      addRow(
        "ShowCommand",
        showCmdName,
        "Window display state (" + showCommandValue + ")",
      );

      // HotKey (2 bytes)
      const hotKeyValue = getNumberValue();
      addDetails(() => {
        addRow(
          "HotKey",
          convertToHexString(hotKeyValue, 2),
          "Keyboard shortcut to launch application",
        );
        const lowByte = hotKeyValue & 0xff;
        const highByte = (hotKeyValue >> 8) & 0xff;
        addRow(
          "LowByte",
          convertToHexString(lowByte, 1),
          "Virtual key code or ASCII code",
        );
        addRow(
          "HighByte",
          convertToHexString(highByte, 1),
          "Modifier keys (Shift, Ctrl, Alt)",
        );
      }, false);

      // Reserved1 (2 bytes)
      read(2);

      // Reserved2 (4 bytes)
      read(4);

      // Reserved3 (4 bytes)
      read(4);
    }, true);

    read(4);
    setOffset(getOffset() - 4);
    read(4);

    // Read LinkFlags again for optional data parsing
    setOffset(28);
    read(4);
    const linkFlags = getNumberValue();

    // ===== LINKTARGET_IDLIST (optional) =====
    if ((linkFlags & 0x01) === 0x01) {
      addDetails(() => {
        addRow(
          "Structure",
          "LinkTargetIDList",
          "Optional item identifier list",
        );

        const idListSizeValue = getNumberValue();
        addRow(
          "IDListSize",
          idListSizeValue + " bytes",
          "Size of IDList structure",
        );

        let itemCount = 0;
        let offset = 0;
        while (offset < idListSizeValue - 2) {
          const itemSizeValue = getNumberValue();
          if (itemSizeValue === 0) break;

          read(itemSizeValue - 2);

          addDetails(() => {
            addRow(
              "ItemID " + itemCount,
              convertToHexString(itemSizeValue, 2) + " bytes",
              "Item ID #" + itemCount,
            );
            addMemDump(false);
          }, false);

          offset += itemSizeValue;
          itemCount++;
        }

        // TerminalID
        const terminalId = getNumberValue();
        addRow(
          "TerminalID",
          terminalId === 0
            ? "0x0000 (End of list)"
            : convertToHexString(terminalId, 2),
          "",
        );
      }, true);
    }

    // ===== LINKINFO (optional) =====
    if ((linkFlags & 0x02) === 0x02) {
      addDetails(() => {
        addRow("Structure", "LinkInfo", "Optional linked file information");

        const linkInfoSizeValue = getNumberValue();
        addRow(
          "LinkInfoSize",
          linkInfoSizeValue + " bytes",
          "Size of LinkInfo structure",
        );

        const headerSizeValue = getNumberValue();
        addRow(
          "LinkInfoHeaderSize",
          headerSizeValue + " bytes",
          "Size of LinkInfoHeader",
        );

        const linkInfoFlagsValue = getNumberValue();
        addDetails(() => {
          addRow(
            "LinkInfoFlags",
            convertToHexString(linkInfoFlagsValue, 4),
            "Volume and path information flags",
          );
          addRow(
            "VolumeIDAndLocalBasePath",
            linkInfoFlagsValue & 0x01 ? "Yes" : "No",
            "",
          );
          addRow(
            "CommonNetworkRelativeLinkAndPathSuffix",
            linkInfoFlagsValue & 0x02 ? "Yes" : "No",
            "",
          );
        }, false);

        const volumeIDOffsetValue = getNumberValue();
        addRow(
          "VolumeIDOffset",
          volumeIDOffsetValue,
          "Offset to VolumeID from LinkInfo start",
        );

        const localBasePathOffsetValue = getNumberValue();
        addRow(
          "LocalBasePathOffset",
          localBasePathOffsetValue,
          "Offset to LocalBasePath",
        );

        const commonNetworkRelativeLinkOffsetValue = getNumberValue();
        addRow(
          "CommonNetworkRelativeLinkOffset",
          commonNetworkRelativeLinkOffsetValue,
          "Offset to CommonNetworkRelativeLink",
        );

        const commonPathSuffixOffsetValue = getNumberValue();
        addRow(
          "CommonPathSuffixOffset",
          commonPathSuffixOffsetValue,
          "Offset to CommonPathSuffix",
        );

        // Skip remaining fields for now
        const remainingBytes =
          linkInfoSizeValue - getOffset() + (getOffset() - headerSizeValue);
        if (remainingBytes > 0) {
          read(remainingBytes);
        }
      }, true);
    }

    // ===== STRING_DATA (optional) =====
    const stringFlags = (linkFlags >> 2) & 0x3f; // Bits 2-7
    if (stringFlags !== 0) {
      addDetails(() => {
        addRow("Structure", "StringData", "Optional string data structures");

        if ((linkFlags & 0x04) === 0x04) {
          // HasName
          addRow("Name", readStringData((linkFlags & 0x80) !== 0), "Link name");
        }

        if ((linkFlags & 0x08) === 0x08) {
          // HasRelativePath
          addRow(
            "RelativePath",
            readStringData((linkFlags & 0x80) !== 0),
            "Relative path to target",
          );
        }

        if ((linkFlags & 0x10) === 0x10) {
          // HasWorkingDir
          addRow(
            "WorkingDir",
            readStringData((linkFlags & 0x80) !== 0),
            "Working directory",
          );
        }

        if ((linkFlags & 0x20) === 0x20) {
          // HasArguments
          addRow(
            "Arguments",
            readStringData((linkFlags & 0x80) !== 0),
            "Command-line arguments",
          );
        }

        if ((linkFlags & 0x40) === 0x40) {
          // HasIconLocation
          addRow(
            "IconLocation",
            readStringData((linkFlags & 0x80) !== 0),
            "Icon file path",
          );
        }
      }, true);
    }

    // ===== EXTRA_DATA (optional) =====
    addDetails(() => {
      addRow("Structure", "ExtraDataBlocks", "Optional extra data blocks");

      let blockCount = 0;
      while (true) {
        read(4);
        const blockSizeValue = getNumberValue();
        if (blockSizeValue === 0) {
          addRow("Terminal Block", "0x00000000", "End of ExtraData blocks");
          break;
        }

        read(4);
        const blockSignatureValue = getNumberValue();

        addDetails(() => {
          addRow(
            "Block #" + blockCount,
            "Size: " +
              blockSizeValue +
              " bytes, Signature: " +
              convertToHexString(blockSignatureValue, 4),
            describeExtraDataBlock(blockSignatureValue),
          );

          // Read block data
          const blockData = blockSizeValue - 8;
          if (blockData > 0) {
            read(blockData);
          }
        }, false);

        blockCount++;
      }
    }, true);
  } catch (e) {
    addRow("ERROR", "Parser error", "File may be malformed");
  }
});

// Helper Functions

/** @param {number[]} bytes */
function formatGUID(bytes) {
  if (bytes.length !== 16) return "Invalid GUID";

  // GUID format: XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
  /** @type {string[]} */
  const hex = bytes.map(
    (b) => (b < 16 ? "0" : "") + b.toString(16).toUpperCase(),
  );

  let result = "";
  for (let i = 0; i < 4; i++) result += hex[i];
  result += "-";
  for (let i = 4; i < 6; i++) result += hex[i];
  result += "-";
  for (let i = 6; i < 8; i++) result += hex[i];
  result += "-";
  for (let i = 8; i < 10; i++) result += hex[i];
  result += "-";
  for (let i = 10; i < 16; i++) result += hex[i];

  return result;
}

/** @param {string} hexStr */
function formatGUIDFromHex(hexStr) {
  // Convert hex string to GUID format: XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
  /** @type {string} */
  const cleanHex = hexStr.toString().toUpperCase();
  if (cleanHex.length !== 32) return "Invalid GUID";

  return (
    cleanHex.substring(0, 8) +
    "-" +
    cleanHex.substring(8, 12) +
    "-" +
    cleanHex.substring(12, 16) +
    "-" +
    cleanHex.substring(16, 20) +
    "-" +
    cleanHex.substring(20, 32)
  );
}

/** @param {bigint|number} filetime */
function formatFILETIME(filetime) {
  if (filetime === 0n || filetime === 0) {
    return "Not set";
  }

  // FILETIME is 100-nanosecond intervals since 1601-01-01
  // Convert to JavaScript timestamp (milliseconds since 1970-01-01)
  // Epoch difference: 11644473600 seconds = 116444736000000000 100-ns intervals
  const epochDiff = 116444736000000000n;
  const timestamp = Number((BigInt(filetime) - epochDiff) / 10000n);

  if (timestamp < 0) return "Invalid date";

  try {
    const date = new Date(timestamp);
    return date.toISOString();
  } catch (e) {
    // eslint-disable-next-line no-empty
    return "Invalid date";
  }
}

/** @param {boolean} isUnicode */
function readStringData(isUnicode) {
  if (isUnicode) {
    // UTF-16LE string with 2-byte length prefix
    read(2);
    const lengthValue = getNumberValue();
    read(lengthValue * 2);
    return getStringValue();
  } else {
    // ASCII string with 2-byte length prefix
    read(2);
    const lengthValue = getNumberValue();
    read(lengthValue);
    return getStringValue();
  }
}

/** @param {number} signature */
function describeExtraDataBlock(signature) {
  /** @type {Object<number, string>} */
  const blockTypes = {
    0xa0000002: "Console Data Block",
    0xa0000004: "ConsoleFEDataBlock",
    0xa0000014: "Environmental Variables Data Block",
    0xa0000001: "Darwin/Mac Data Block",
    0xa000000c: "Shim Data Block",
    0xa0000008: "Icon Environment Data Block",
    0xa000000e: "Metadata Properties Block",
    0xa0000009: "Known Folder Data Block",
    0xa000000d: "Tracker Data Block",
  };

  return blockTypes[signature] || "Unknown block type";
}
