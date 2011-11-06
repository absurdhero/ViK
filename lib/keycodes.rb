class KeyCodes
    VI_CHAR_MAP = {
        0  => '<Nul>',
        8  => '<BS>',
        9  => '<Tab>',
        10 => '<NL>',
        12 => '<FF>',
        13 => '<CR>', # also <Return> <Enter>
        27 => '<Esc>',
        32 => '<Space>',
        60 => '<lt>',
        92 => '<Bslash>',
        124 => '<Bar>',
        127 => '<Del>',
        155 => '<CSI>',
    }

    VI_CHAR_ALTERNATES = {
        '<Return>' => 13,
        '<Enter>' => 13,
    }
end

