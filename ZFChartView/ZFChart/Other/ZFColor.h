/**
 *  直接填写小数
 */
#define ZFDecimalColor(r, g, b, a)    [UIColor colorWithRed:r green:g blue:b alpha:a]

/**
 *  直接填写整数
 */
#define ZFColor(r, g, b, a)    [UIColor colorWithRed:r / 255.f green:g / 255.f blue:b / 255.f alpha:a]

/**
 *  随机颜色
 */
#define ZFRandom    ZFColor(arc4random() % 256, arc4random() % 256, arc4random() % 256, 1)

#define ZFBlack         [UIColor blackColor]
#define ZFDarkGray      [UIColor darkGrayColor]
#define ZFLightGray     [UIColor lightGrayColor]
#define ZFWhite         [UIColor whiteColor]
#define ZFGray          [UIColor grayColor]
#define ZFRed           [UIColor redColor]
#define ZFGreen         [UIColor greenColor]
#define ZFBlue          [UIColor blueColor]
#define ZFCyan          [UIColor cyanColor]
#define ZFYellow        [UIColor yellowColor]
#define ZFMagenta       [UIColor magentaColor]
#define ZFOrange        [UIColor orangeColor]
#define ZFPurple        [UIColor purpleColor]
#define ZFBrown         [UIColor brownColor]
#define ZFClear         [UIColor clearColor]
#define ZFSkyBlue       ZFDecimalColor(0, 0.68, 1, 1)
#define ZFLightBlue     ZFColor(125, 231, 255, 1)
#define ZFSystemBlue    ZFColor(10, 96, 254, 1)
#define ZFFicelle       ZFColor(247, 247, 247, 1)
#define ZFTaupe         ZFColor(238, 239, 241, 1)
#define ZFTaupe2        ZFColor(237, 236, 236, 1)
#define ZFTaupe3        ZFColor(236, 236, 236, 1)
#define ZFGrassGreen    ZFColor(254, 200, 122, 1)
#define ZFGold          ZFColor(255, 215, 0, 1)
#define ZFDeepPink      ZFColor(238, 18, 137, 1)

#define XRFont(size) [UIFont systemFontOfSize:(size)]
#define XRBoldFont(size) [UIFont boldSystemFontOfSize:(size)]


#define XRColorRGBA(r, g, b, a)           [UIColor colorWithRed:(r) / 255.f green:(g) / 255.f blue:(b) / 255.f alpha:(a)]
#define XRColorRGB(r, g, b)               XRColorRGBA((r), (g), (b), 1.f)
#define XRColor0xRGB(rgb)                 XRColorRGBA((rgb) / 0x10000, ((rgb) % 0x10000) / 0x100, (rgb) % 0x100, 1.f)
#define XRColor0xRGBA(rgb, a)             XRColorRGBA((rgb) / 0x10000, ((rgb) % 0x10000) / 0x100, (rgb) % 0x100, a)
#define XRColor(c)                        XRColorRGBA((c), (c), (c), 1.f)
#define XRColorBlackWithAlpha(a)          [UIColor colorWithWhite:0.f alpha:a]
#define XRColorWhiteWithAlpha(a)          [UIColor colorWithWhite:1.f alpha:a]


#define XRTextGrayColor XRColorRGB(138, 138, 138)
#define XRTextGreenColor XRColorRGB(0, 179, 18)
#define XRTextRedColor XRColorRGB(218, 43, 48)
#define XRTextOrangeColor XRColorRGB(234, 144, 0)
#define XRTextBlueColor XRColorRGB(0, 122, 222)

#define XRBackgroundOrangeColor XRColorRGB(234, 149, 36)
#define XRBackgroundOrangeLightColor XRColorRGB(253, 224, 161)
#define XRBackgroundGrayColor XRColorRGB(239, 238, 244)
#define XRBackgroundRedColor XRColorRGB(252, 100, 103)


#define XRWidth [UIScreen mainScreen].bounds.size.width
#define XRHeight [UIScreen mainScreen].bounds.size.height
