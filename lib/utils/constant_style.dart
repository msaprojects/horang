import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constant_color.dart';

///style untuk title
var mTitleStyle = GoogleFonts.inter(
  fontWeight: FontWeight.w600, color: mTitleColor, fontSize: 16
);

//style untuk diskon
var mMorediscountstyle = GoogleFonts.inter(
  fontSize: 12, fontWeight: FontWeight.w700, color: mTitleColor
);

// Style untuk Service Section
var mServiceTitleStyle = GoogleFonts.inter(
    fontWeight: FontWeight.bold, fontSize: 20, color: mTitleColor);
var mServiceSubtitleStyle = GoogleFonts.inter(
    fontWeight: FontWeight.w400, fontSize: 10, color: mSubtitleColor);

// Style untuk Popular Destination Section
var mPopularDestinationTitleStyle = GoogleFonts.inter(
  fontWeight: FontWeight.w700,
  fontSize: 16,
  color: mCardTitleColor,
);
var mPopularDestinationSubtitleStyle = GoogleFonts.inter(
  fontWeight: FontWeight.w500,
  fontSize: 10,
  color: mCardSubColor,
);

// Style for Travlog Section
var mTravlogTitleStyle = GoogleFonts.inter(
    fontSize: 14, fontWeight: FontWeight.w900, color: mFillColor);
var mTravlogContentStyle = GoogleFonts.inter(
    fontSize: 10, fontWeight: FontWeight.w500, color: mTitleColor);
var mTravlogPlaceStyle = GoogleFonts.inter(
    fontSize: 10, fontWeight: FontWeight.w500, color: mBlueColor);